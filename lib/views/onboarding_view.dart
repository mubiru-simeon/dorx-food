import 'package:dorx/models/models.dart';
import 'package:dorx/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:hive/hive.dart';
import '../constants/constants.dart';
import '../widgets/widgets.dart';

class OnboardingView extends StatefulWidget {
  OnboardingView({
    Key key,
  }) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  Box box;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box(DorxSettings.DORXBOXNAME);
  }

  @override
  Widget build(BuildContext context) {
    final List<OnBoardingItem> dayta = [
      OnBoardingItem(
        translation(context).welcomeToDorx,
        welcomeSVG,
        translation(context).yourBestRestaurantPaymentsManager,
      ),
      OnBoardingItem(
        translation(context).balances,
        walletSVG,
        translation(context).easilyManageYourBalances,
      ),
      OnBoardingItem(
        translation(context).food,
        foodSVG,
        translation(context).easilyManageOrders,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          ConcentricPageView(
            duration: Duration(
              milliseconds: 1000,
            ),
            verticalPosition: 0.8,
            onFinish: () async {
              box.put(
                DorxSettings.FINISHEDONBOARDING,
                true,
              );

              if (context.canPop()) {
                Navigator.of(context).pop();
              } else {
                context.pushReplacementNamed(
                  RouteConstants.home,
                );
              }
            },
            colors: <Color>[
              Colors.orange,
              Colors.blue,
              Colors.green,
            ],
            itemCount: dayta.length, // null = infinity
            nextButtonBuilder: (context) {
              return CircleAvatar(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              );
            },
            itemBuilder: (int index) {
              return SingleOnboardingPage(
                item: dayta[index],
              );
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(
                    RouteConstants.aboutUs,
                  );
                },
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        UIServices().showDatSheet(
                          SettingsBottomSheet(),
                          true,
                          context,
                        );
                      },
                      child: Material(
                        elevation: standardElevation,
                        borderRadius: BorderRadius.circular(50),
                        child: CircleAvatar(
                          radius: 25,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.settings,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: standardElevation,
                        borderRadius: BorderRadius.circular(50),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Logo(
                            withImage: true,
                            picSize: 30,
                            withString: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SingleOnboardingPage extends StatelessWidget {
  final OnBoardingItem item;

  const SingleOnboardingPage({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SvgPicture.asset(
                item.image,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              item.desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
