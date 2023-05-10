import 'dart:async';

import 'package:dorx/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:dorx/widgets/widgets.dart';
import 'package:hive/hive.dart';
import '../models/models.dart';
import '../services/services.dart';

class SplashScreenView extends StatefulWidget {
  SplashScreenView({Key key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  Box box;

  @override
  void initState() {
    super.initState();
    box = Hive.box(DorxSettings.DORXBOXNAME);
    startTime();
  }

  void navigationPage() async {
    bool finishedOnboarding = box.get(DorxSettings.FINISHEDONBOARDING) ?? false;

    context.pushReplacementNamed(
      finishedOnboarding ? RouteConstants.home : RouteConstants.onboarding,
    );
  }

  startTime() async {
    var duration = Duration(seconds: 5);
    return Timer(duration, navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider.of(context).auth.reloadAccount(context);

    return Scaffold(
      backgroundColor: darkBgColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(
                flex: 1,
              ),
              Center(
                child: Pulser(
                  duration: 800,
                  child: Image(
                    width: MediaQuery.of(context).size.width * 0.4,
                    image: AssetImage(
                      foodLogoLight,
                    ),
                  ),
                ),
              ),
              Spacer(
                flex: 2,
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
