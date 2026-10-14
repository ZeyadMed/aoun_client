part of 'http.dart';

class ApiConsumerImpl implements ApiConsumer {
  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;

  // Token refresh lock mechanism
  static Completer<bool>? _refreshCompleter;
  static bool _isRefreshing = false;

  ApiConsumerImpl({
    required Dio dio,
    int maxRetries = 2,
    Duration retryDelay = const Duration(seconds: 5),
  }) : _dio = dio,
       maxRetries = maxRetries,
       retryDelay = retryDelay;

  // ─────────────────────────────────────────────
  // Private helpers
  // ─────────────────────────────────────────────

  Future<Either<Failure, Map<String, dynamic>>> _handleApiRequest(
    Future<Response> Function() request,
    Future<Either<Failure, Map<String, dynamic>>> Function() retryCall, {
    bool skipAuthRefresh = false,
  }) async {
    try {
      final response = await request();
      if (response.data is Map<String, dynamic>) {
        return Right(response.data as Map<String, dynamic>);
      } else {
        return Right({"data": response.data});
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 && !skipAuthRefresh) {
        final refreshed = await _refreshTokenWithLock();
        if (refreshed) {
          return retryCall();
        }
      }
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  Future<Either<Failure, String>> _handleDownloadRequest(
    Future<Response> Function() request,
    Future<Either<Failure, String>> Function() retryCall,
    String savePath,
  ) async {
    try {
      await request();
      return Right(savePath);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final refreshed = await _refreshTokenWithLock();
        if (refreshed) {
          return retryCall();
        }
      }
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  // ─────────────────────────────────────────────
  // FIX 1: Lock mechanism صح — كان بيستخدم Future<bool>? بدون Completer
  // دلوقتي بيستخدم Completer عشان كل الطلبات تستنى نفس الـ refresh
  // ─────────────────────────────────────────────
  Future<bool> _refreshTokenWithLock() async {
    if (_isRefreshing) {
      // استنى الـ refresh الجاري يخلص
      return _refreshCompleter?.future ?? Future.value(false);
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final result = await _refreshToken();
      _refreshCompleter!.complete(result);
      return result;
    } catch (e) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  Future<bool> _refreshToken() async {
    final cachedToken = getIt<ITokenCache>().getAccessToken();
    final refreshToken = cachedToken?.refreshToken;
    final accessToken = cachedToken?.accessToken;
    final deviceId = await HiveServiceImpl.instance.getDeviceId();
    final deviceInfo = HiveServiceImpl.instance.getDeviceInfo();

    if (refreshToken == null) {
      loggerWarn('No refresh token available');
      _navigateToLogin();
      return false;
    }

    try {
      loggerInfo('Attempting to refresh token...');
      _dio.options.headers.remove('Authorization');

      final response = await _dio.post(
        Endpoints.refreshToken,
        data: {
          "refreshToken": refreshToken,
          "deviceInfo": deviceInfo,
          "deviceId": deviceId,
        },
        options: Options(
          headers: {
            "deviceInfo": deviceInfo,
            "deviceId": deviceId,
            "X-DeviceId": deviceId,
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        final newToken = UserToken.fromJson(response.data);
        getIt<ITokenCache>().saveAccessToken(newToken);
        updateHeader({"Authorization": "Bearer ${newToken.accessToken}"});
        loggerInfo('Token refreshed successfully');
        return true;
      }

      loggerWarn('Invalid response from refresh endpoint');
      _navigateToLogin();
      return false;
    } catch (e) {
      loggerError('Token refresh failed: $e');
      _navigateToLogin();
      return false;
    }
  }

  void _navigateToLogin() {
    getIt<ITokenCache>().clearAccessToken();
    _dio.options.headers.remove('Authorization');

    AppRouter.router.go(AppRouter.login);

    final context =
        navigatorKey.currentContext ??
        AppRouter.router.routerDelegate.navigatorKey.currentContext;
    context?.showTopSnackBar(
      message: 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى',
      type: SnackBarType.error,
    );
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        navigatorKey.currentContext?.showTopSnackBar(
          type: SnackBarType.error,
          message: 'تم الغاء الطلب',
        );
        return ServerFailure(message: 'تم إلغاء الطلب');
      case DioExceptionType.connectionTimeout:
        navigatorKey.currentContext?.showTopSnackBar(
          type: SnackBarType.error,
          message: 'انتهت مهلة الاتصال',
        );
        return ServerFailure(message: 'انتهت مهلة الاتصال');
      case DioExceptionType.receiveTimeout:
        navigatorKey.currentContext?.showTopSnackBar(
          type: SnackBarType.error,
          message: 'انتهت مهلة الاتصال',
        );
        return ServerFailure(message: 'انتهت مهلة الاستقبال في الاتصال');
      case DioExceptionType.sendTimeout:
        navigatorKey.currentContext?.showTopSnackBar(
          type: SnackBarType.error,
          message: 'انتهت مهلة الاتصال',
        );
        return ServerFailure(message: 'انتهت مهلة الإرسال في الاتصال');
      case DioExceptionType.transformTimeout:
        navigatorKey.currentContext?.showTopSnackBar(
          type: SnackBarType.error,
          message: 'انتهت مهلة الاتصال',
        );
        return ServerFailure(message: 'انتهت مهلة معالجة الاستجابة');
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.badCertificate:
        return ServerFailure(message: 'تعذر الاتصال');
      case DioExceptionType.connectionError:
        navigatorKey.currentContext?.showTopSnackBar(
          type: SnackBarType.error,
          message: 'تعذر الاتصال',
        );
        return NetworkFailure(message: 'تعذر الاتصال');
      case DioExceptionType.unknown:
        return UnknownFailure(message: 'Unexpected error: ${error.message}');
    }
  }

  Failure _handleBadResponse(DioException error) {
    if (error.response?.data == null) {
      return ServerFailure(
        message: 'Received invalid status code: ${error.response?.statusCode}',
      );
    }

    try {
      final res = error.response!;
      final data = res.data;

      Map<String, dynamic>? decoded;
      String? textMessage;

      if (data is Map<String, dynamic>) {
        decoded = data;
      } else if (data is String) {
        try {
          decoded = json.decode(data) as Map<String, dynamic>;
        } catch (_) {
          textMessage = data.trim();
        }
      }

      switch (res.statusCode) {
        case 503:
          return ServerFailure(message: 'network failure ${error.message}');
        case 401:
          final msg = _extractErrorMessage(decoded, textMessage, 'غير مصرح لك');
          return ValidationFailure(message: msg, errors: [msg]);
        case 413:
          navigatorKey.currentContext?.showTopSnackBar(
            type: SnackBarType.error,
            message: 'File size is too large',
          );
          return ServerFailure(message: 'File size is too large');
        case 404:
          return NotFoundFailure(message: 'لا توجد نتائج');
        case 407:
          loggerWarn('APP IS OPENED IN ANOTHER DEVICE');
          return SyncAppFailure(message: 'تم فتح التطبيق في جهاز آخر');
        case 402:
          return PaymentFailure(message: error.message ?? "");

        // ─────────────────────────────────────────────
        // FIX 3: كود 409 كان متكرر في مكانين — دلوقتي في مكان واحد بس
        // ─────────────────────────────────────────────
        case 409:
          loggerWarn('VERIFYERROR');
          navigatorKey.currentContext?.showTopSnackBar(
            type: SnackBarType.error,
            message: 'الحساب غير مفعل',
          );

          final context = navigatorKey.currentContext;
          if (context != null) {
            String? phoneNumber;
            final requestData = error.requestOptions.data;
            if (requestData is Map<String, dynamic>) {
              phoneNumber = requestData['userNameOrEmail'] as String?;
            }
            if (phoneNumber != null) {
              context.push(AppRouter.login, extra: phoneNumber);
            } else {
              context.push(AppRouter.login);
            }
          }
          return VerifyOTPFailure(message: 'خطأ في التحقق من الكود');
      }

      if (decoded != null && decoded.containsKey('message')) {
        if (decoded.containsKey('result') && decoded['result'] is Map) {
          return _handleValidationErrors(decoded);
        }

        String message = decoded['message'];
        return (res.statusCode != null &&
                res.statusCode! >= 400 &&
                res.statusCode! < 500)
            ? ValidationFailure(message: message, errors: [message])
            : ServerFailure(message: message);
      }

      if (textMessage != null && textMessage.isNotEmpty) {
        final code = res.statusCode ?? 0;
        if (code >= 400 && code < 500) {
          return ValidationFailure(message: textMessage, errors: [textMessage]);
        }
        return ServerFailure(message: textMessage);
      }
    } catch (e) {
      return ServerFailure(
        message: 'Received invalid status code: ${error.response?.statusCode}',
      );
    }

    return ServerFailure(
      message: 'Received invalid status code: ${error.response?.statusCode}',
    );
  }

  String _extractErrorMessage(
    Map<String, dynamic>? decoded,
    String? textMessage,
    String defaultMessage,
  ) {
    if (decoded != null && decoded.containsKey('message')) {
      return decoded['message']?.toString() ?? defaultMessage;
    }
    if (textMessage?.isNotEmpty == true) {
      return textMessage!;
    }
    return defaultMessage;
  }

  ValidationFailure _handleValidationErrors(Map<String, dynamic> decoded) {
    final errors = decoded['result'] as Map<String, dynamic>;
    List<String> messages = [];

    errors.forEach((key, value) {
      if (value is List) {
        messages.addAll(value.map((e) => '$key: $e'));
      } else if (value is String) {
        messages.add('$key: $value');
      }
    });

    final message = decoded['message'] ?? 'حدث خطأ ما';

    if (messages.isNotEmpty) {
      navigatorKey.currentContext?.showTopSnackBar(
        type: SnackBarType.error,
        message: messages.first,
      );
    }

    return ValidationFailure(
      message: messages.isNotEmpty ? messages.first : message,
      errors: messages,
    );
  }

  // ─────────────────────────────────────────────
  // Public API methods
  // ─────────────────────────────────────────────

  @override
  Future<Either<Failure, Map<String, dynamic>>> retryApiCall(
    Future<Either<Failure, Map<String, dynamic>>> Function() apiCall, {
    int retryCount = 0,
  }) async {
    final result = await apiCall();
    return result.fold((failure) async {
      if (retryCount < maxRetries) {
        log("API failed, retrying attempt #${retryCount + 1}");
        await Future.delayed(retryDelay);
        return retryApiCall(apiCall, retryCount: retryCount + 1);
      } else {
        log("Max retries reached, API failed: ${failure.message}");
        return Left(failure);
      }
    }, (success) => Right(success));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool skipAuthRefresh = false,
  }) {
    return _handleApiRequest(
      () => _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        data: data,
        onReceiveProgress: onReceiveProgress,
      ),
      () => get(
        url,
        headers: headers,
        queryParameters: queryParameters,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        skipAuthRefresh: skipAuthRefresh,
      ),
      skipAuthRefresh: skipAuthRefresh,
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool skipAuthRefresh = false,
  }) {
    return _handleApiRequest(
      () => _dio.post(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        data: formData ?? data,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      () => post(
        url,
        data: data,
        formData: formData,
        queryParameters: queryParameters,
        headers: headers,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        skipAuthRefresh: skipAuthRefresh,
      ),
      skipAuthRefresh: skipAuthRefresh,
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> patch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _handleApiRequest(
      () => _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      () => patch(
        url,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Object? data,
    bool formData = false,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _handleApiRequest(
      () => _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      () => put(
        url,
        data: data,
        formData: formData,
        queryParameters: queryParameters,
        headers: headers,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) {
    return _handleApiRequest(
      () => _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      ),
      () => delete(
        url,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  Future<Either<Failure, String>> downloadFile({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _handleDownloadRequest(
      () => _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      () => downloadFile(
        url: url,
        savePath: savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      savePath,
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> head(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _handleApiRequest(
      () => _dio.head(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      ),
      () => head(
        url,
        headers: headers,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> uploadFile(
    String url, {
    required Map<String, dynamic> formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _handleApiRequest(
      () => _dio.post(
        url,
        data: FormData.fromMap(formData),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      () => uploadFile(
        url,
        formData: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> postFormData(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _handleApiRequest(
      () => _dio.post(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
      () => postFormData(
        url,
        data: data,
        formData: formData,
        queryParameters: queryParameters,
        headers: headers,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  @override
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  @override
  void removeAllInterceptors() {
    _dio.interceptors.clear();
    _dio.options.headers.clear();
  }

  @override
  void updateHeader(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  @override
  Future<bool> refreshToken() async {
    return await _refreshTokenWithLock();
  }
}
