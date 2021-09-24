import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/injection.dart';
import 'package:food_delivery_app/presentation/bloc/config/config_bloc.dart';
import 'package:food_delivery_app/presentation/bloc/signup/cubit/signup_cubit.dart';

import 'package:food_delivery_app/presentation/core/app.dart';

import 'domain/repositories/auth/auth.dart';

import 'domain/repositories/config/first_time_repository_interface.dart';
import 'domain/repositories/config/locale_repository_interface.dart';
import 'domain/repositories/config/theme_repository_interface.dart';
import 'domain/usecases/auth/login_with_email.dart';
import 'domain/usecases/auth/login_with_google.dart';
import 'domain/usecases/auth/validate_email.dart';
import 'domain/usecases/auth/validate_password.dart';

import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/login/login_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDependencies();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => ConfigCubit(
        locator<LocaleRepositoryInterface>(),
        locator<ThemeRepositoryInterface>(),
        locator<FirstTimeRepositoryInterface>(),
      )..initConfig(),
    ),
    BlocProvider(
      create: (context) => SignupCubit(locator<AuthRepositoryInterface>()),
    ),
    BlocProvider(
      create: (context) => AuthBloc(locator<AuthRepositoryInterface>()),
    ),
    BlocProvider(
      create: (context) => LoginCubit(
          loginWithEmail: LoginWithEmail(locator<AuthRepositoryInterface>()),
          loginWithGoogle: LoginWithGoogle(locator<AuthRepositoryInterface>()),
          validateEmail: ValidateEmail(),
          validatePassword: ValidatePassword()),
    )
  ], child: const FoodDeliveryApp()));
}
