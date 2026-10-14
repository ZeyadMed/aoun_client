import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:go_router/go_router.dart';
import 'package:aoun_client/core/extensions/extensions.dart';
import 'package:aoun_client/feature/auth/presentation/screens/register/data/models/user_token.dart';

import '../enum/snack_bar_enum.dart';
import '../router/app_router.dart';
import '../../main.dart';
import '../helpers/helpers.dart';
import '../local_storage/local_storage.dart';
import '../service_locator/service_locator.dart';
import 'either.dart';
import 'failure.dart';

import 'package:dio/dio.dart';

part 'api_consumer.dart';
part 'base_api_consumer.dart';
part 'endpoints.dart';
