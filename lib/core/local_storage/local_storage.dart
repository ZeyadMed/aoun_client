import 'package:hive_flutter/hive_flutter.dart';
import 'package:aoun_client/feature/auth/models/user_model.dart';
import 'package:aoun_client/feature/auth/presentation/screens/register/data/models/user_token.dart';
import 'package:aoun_client/feature/main/catalog/data/model/get_category_model.dart';
import 'package:aoun_client/feature/main/catalog/data/model/get_product_model.dart';
import 'package:uuid/uuid.dart';

import '../helpers/helpers.dart';
part 'token_cache_interface.dart';
part 'paginated_cache_interface.dart';
part 'hive_paginated_cache.dart';
part 'user_cache_interface.dart';
part 'cache_theme.dart';
part 'hive_service_impl.dart';
