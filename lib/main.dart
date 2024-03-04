import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/authentication/presentation/pages/login_page.dart';
import 'package:news_app/config/db_config.dart';
import 'package:news_app/features/news_article/presentation/blocs/main/main_bloc.dart';
import 'package:news_app/features/news_article/presentation/pages/main_page/main_page.dart';
import 'package:news_app/firebase_options.dart';
import 'config/routes/routes.dart';
import 'config/theme/app_themes.dart';
import 'features/authentication/presentation/bloc/auth/auth_cubit.dart';
import 'features/authentication/presentation/bloc/credential/credential_cubit.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDependencies();
  await initDbConfig();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => sl()..appStarted(),
        ),
        BlocProvider<CredentialCubit>(
          create: (_) => sl<CredentialCubit>(),
        ),
        BlocProvider<MainBloc>(
            create: (context) =>
                sl.get<MainBloc>()..add(const MainEvent.fetchArticles())),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme(),
              onGenerateRoute: AppRoutes.onGenerateRoutes,
              routes: {
                "/": (context) {
                  return BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      if (authState is Authenticated) {
                        return const MainPage();
                      } else {
                        return const LoginPage();
                      }
                    },
                  );
                }
              },
            );
          }),
    );
  }
}
