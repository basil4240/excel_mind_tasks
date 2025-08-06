import 'package:excel_mind_tasks/presentation/providers/auth_provider.dart';
import 'package:excel_mind_tasks/presentation/providers/theme_provider.dart';
import 'package:excel_mind_tasks/presentation/theme/dark_theme.dart';
import 'package:excel_mind_tasks/presentation/theme/light_theme.dart';
import 'package:excel_mind_tasks/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/services/dialog_service.dart';
import 'core/services/navigation_service.dart';
import 'dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: getIt<AuthProvider>()),
        ChangeNotifierProvider.value(value: getIt<ThemeProvider>()),
      ],
      child: ScreenUtilInit(
          designSize: const Size(375, 812),
          fontSizeResolver: (fontSize, instance) {
            if (instance.orientation == Orientation.portrait) {
              return FontSizeResolvers.width(fontSize, instance);
            } else {
              return FontSizeResolvers.diagonal(fontSize, instance);
            }
          },
        builder: (context, instance) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {

              return MaterialApp(
                title: 'ExcelMind Tasks',
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeProvider.themeMode,
                navigatorKey: getIt<NavigationService>().navigatorKey,
                home: const SplashView(),
                // Always start with SplashView
                builder: (context, child) {
                  return Navigator(
                    key: getIt<DialogService>().dialogNavigationKey,
                    onGenerateRoute:
                        (settings) =>
                            MaterialPageRoute(builder: (context) => child!),
                  );
                },
              );
            },
          );
        }
      ),
    );
  }
}
