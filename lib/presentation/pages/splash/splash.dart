import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/presentation/bloc/auth/auth_bloc.dart';

import 'package:food_delivery_app/presentation/bloc/config/config_bloc.dart';

import 'package:food_delivery_app/presentation/routes/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() async {
    BlocProvider.of<AuthBloc>(context).add(const AuthEvent.checkAuth());

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<ConfigCubit, ConfigState>(
      child: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: 400,
        ),
      ),
      listener: (context, state) {
        if (state.status == ConfigStatus.init) {
          if (state.isFirstTime) {
            Navigator.of(context)
                .pushReplacementNamed(Routes.languageSelectionScreen);

//goto onboard screen
          } else {
            Navigator.of(context).pushReplacementNamed(Routes.mainScreen);
            //go to main screen

          }
        }
      },
    ));
  }
}
