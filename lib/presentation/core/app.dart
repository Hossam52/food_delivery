import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:food_delivery_app/presentation/pages/category/category.dart';
import 'package:food_delivery_app/presentation/pages/edite_profile/edite_profile.dart';
import 'package:food_delivery_app/presentation/pages/meal_details/meal_details.dart';
import 'package:food_delivery_app/presentation/pages/profile/profile.dart';
import 'package:food_delivery_app/presentation/pages/setting/setting_page.dart';

import '../../domain/entities/theme.dart' as domain;
import '../../domain/entities/locale.dart' as domain;
import 'package:food_delivery_app/presentation/bloc/config/config_bloc.dart';

import 'package:food_delivery_app/presentation/pages/auth/auth.dart';
import 'package:food_delivery_app/presentation/pages/forgot_password/forgot_password.dart';
import 'package:food_delivery_app/presentation/pages/language_selection/language_selection.dart';
import 'package:food_delivery_app/presentation/pages/main/main.dart';
import 'package:food_delivery_app/presentation/pages/onboard/onboard.dart';
import 'package:food_delivery_app/presentation/pages/splash/splash.dart';

import 'package:food_delivery_app/presentation/routes/routes.dart';
import 'package:food_delivery_app/presentation/styles/app_themes.dart';

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigCubit, ConfigState>(
      builder: (context, state) => MaterialApp(
        locale: state.locale.locale == domain.Locales.english
            ? const Locale("en")
            : const Locale("ar"),
        title: 'Food Delivery App',
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: state.theme.themeMode == domain.ThemeMode.light
            ? AppTheme.lightTheme
            : AppTheme.darkTheme,
        home: const SplashPage(),
        routes: {
          Routes.categoryPage: (context) => const CategoryPage(),
          Routes.authScreen: (context) => const AuthPage(),
          Routes.forgotPasswordScreen: (context) => const ForgotPasswordPage(),
          Routes.mainScreen: (context) => const MainPage(),
          Routes.onboardScreen: (context) => const OnBoardPage(),
          Routes.languageSelectionScreen: (context) =>
              const LanguageSelectionPage(),
          Routes.mealDetailsPage: (context) => const MealDetailsPage(),
          Routes.profilePage: (context) => const ProfilePage(),
          Routes.editeProfilePage: (context) => const EditeProfilePage(),
          Routes.settingProfile: (context) => const SettingPage(),
        },
      ),
    );
  }
}
