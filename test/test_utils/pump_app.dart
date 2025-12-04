import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:depi_final_project/l10n/app_localizations.dart';
import 'package:depi_final_project/features/home/cubit/locale_cubit.dart';
import 'package:depi_final_project/features/auth/cubit/auth_cubit.dart';
import 'package:depi_final_project/features/auth/cubit/login_cubit.dart';
import 'package:depi_final_project/features/profile/cubit/profile_cubit.dart';
import 'package:depi_final_project/features/home/manager/history_cubit/history_cubit.dart';

/// Helper function to wrap widgets with necessary providers for testing
Widget pumpApp(
  Widget child, {
  LocaleCubit? localeCubit,
  AuthCubit? authCubit,
  LoginCubit? loginCubit,
  ProfileCubit? profileCubit,
  HistoryCubit? historyCubit,
}) {
  return MultiBlocProvider(
    providers: [
      if (localeCubit != null)
        BlocProvider<LocaleCubit>.value(value: localeCubit)
      else
        BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
      
      if (authCubit != null)
        BlocProvider<AuthCubit>.value(value: authCubit)
      else
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
      
      if (loginCubit != null)
        BlocProvider<LoginCubit>.value(value: loginCubit)
      else
        BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
      
      if (profileCubit != null)
        BlocProvider<ProfileCubit>.value(value: profileCubit),
      
      if (historyCubit != null)
        BlocProvider<HistoryCubit>.value(value: historyCubit),
    ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

/// Helper to create a simple test app without providers
Widget pumpSimpleApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}
