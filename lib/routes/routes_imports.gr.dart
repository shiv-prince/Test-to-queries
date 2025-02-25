// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:final_sheshu/pages/csv_upload.dart' as _i1;
import 'package:final_sheshu/pages/excel_upload.dart' as _i2;
import 'package:final_sheshu/pages/home_page.dart' as _i3;
import 'package:final_sheshu/pages/sql_connect.dart' as _i4;
import 'package:final_sheshu/pages/sql_queries.dart' as _i5;

abstract class $AppRouter extends _i6.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    CsvUploaderRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.CsvUploader(),
      );
    },
    ExcelUploaderRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ExcelUploader(),
      );
    },
    HomePageRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HomePage(),
      );
    },
    SqlConncetRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.SqlConncet(),
      );
    },
    SqlQueriesRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.SqlQueries(),
      );
    },
  };
}

/// generated route for
/// [_i1.CsvUploader]
class CsvUploaderRoute extends _i6.PageRouteInfo<void> {
  const CsvUploaderRoute({List<_i6.PageRouteInfo>? children})
      : super(
          CsvUploaderRoute.name,
          initialChildren: children,
        );

  static const String name = 'CsvUploaderRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ExcelUploader]
class ExcelUploaderRoute extends _i6.PageRouteInfo<void> {
  const ExcelUploaderRoute({List<_i6.PageRouteInfo>? children})
      : super(
          ExcelUploaderRoute.name,
          initialChildren: children,
        );

  static const String name = 'ExcelUploaderRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i3.HomePage]
class HomePageRoute extends _i6.PageRouteInfo<void> {
  const HomePageRoute({List<_i6.PageRouteInfo>? children})
      : super(
          HomePageRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomePageRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i4.SqlConncet]
class SqlConncetRoute extends _i6.PageRouteInfo<void> {
  const SqlConncetRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SqlConncetRoute.name,
          initialChildren: children,
        );

  static const String name = 'SqlConncetRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i5.SqlQueries]
class SqlQueriesRoute extends _i6.PageRouteInfo<void> {
  const SqlQueriesRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SqlQueriesRoute.name,
          initialChildren: children,
        );

  static const String name = 'SqlQueriesRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}
