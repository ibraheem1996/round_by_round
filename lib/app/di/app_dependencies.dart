import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'app_dependencies.config.dart';

@InjectableInit(preferRelativeImports: true)
GetIt configureDependencies() => GetIt.asNewInstance().init();
