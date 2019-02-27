import 'package:err/err.dart';

var logger = ErrRouter(
    criticalRoute: [ErrRoute.console, ErrRoute.screen],
    errorRoute: [ErrRoute.screen, ErrRoute.console],
    warningRoute: [ErrRoute.screen, ErrRoute.console],
    infoRoute: [ErrRoute.screen, ErrRoute.console],
    debugRoute: [ErrRoute.screen, ErrRoute.console]);
