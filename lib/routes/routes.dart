part of "routes_imports.dart";

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends $AppRouter {
  RouteType get defaultRouteType => RouteType.adaptive();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomePageRoute.page, path: '/'),
        AutoRoute(page: CsvUploaderRoute.page),
        AutoRoute(page: ExcelUploaderRoute.page),
        AutoRoute(page: SqlConncetRoute.page),
        AutoRoute(page: SqlQueriesRoute.page)
      ];
}
