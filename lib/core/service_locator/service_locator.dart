import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:aoun_client/core/local_storage/local_storage.dart';
import 'package:aoun_client/feature/auth/presentation/screens/forget_password/data/data_source/forget_password_data_source.dart';
import 'package:aoun_client/feature/auth/presentation/screens/forget_password/presentation/logic/forget_password_bloc.dart';
import 'package:aoun_client/feature/auth/presentation/screens/login/data/data_source/login_data_source.dart';
import 'package:aoun_client/feature/auth/presentation/screens/login/presentation/logic/login_bloc.dart';
import 'package:aoun_client/feature/auth/presentation/screens/logout/data/data_source/logout_data_soutrce.dart';
import 'package:aoun_client/feature/auth/presentation/screens/logout/presentation/logic/logout_bloc.dart';
import 'package:aoun_client/feature/auth/presentation/screens/register/data/data_source/register_data_source.dart';
import 'package:aoun_client/feature/auth/presentation/screens/register/presentation/logic/register_bloc.dart';
import 'package:aoun_client/feature/auth/presentation/screens/verify_otp/data/data_source/verify_otp_data_source.dart';
import 'package:aoun_client/feature/auth/presentation/screens/verify_otp/presentation/logic/verify_otp_bloc.dart';
import 'package:aoun_client/feature/main/profile/data/get_profile_data_source.dart';
import 'package:aoun_client/feature/main/profile/presentation/logic/get_profile_cubit.dart';

import '../extensions/extensions.dart';

import 'package:get_it/get_it.dart';

import '../../main.dart';
import '../helpers/helpers.dart';
import '../http/http.dart';
import 'contracts_service_locator/contracts_service_locator.dart';
import 'get_product_service_locator/get_product_service_locator.dart';
import 'home_services_locator/home_services_locator.dart';
import 'statement_service_locator/statement_service_locator.dart';
import 'theme_service_locator/theme_service_locator.dart';
part 'init/init.dart';
part 'auth_service_locator/auth_service_locator.dart';
part 'shared_service_locator/shared_service_locator.dart';
part 'hive_service_locator/hive_service_locator.dart';
