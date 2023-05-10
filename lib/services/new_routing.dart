import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/models.dart';
import '../views/views.dart';
import '../services/services.dart';

final GoRouter router = GoRouter(
  redirect: (context, state) {
    if (!AuthProvider.of(context).auth.isSignedIn() && state.subloc == "/") {
      return "/";
    }

    return null;
  },
  errorBuilder: (context, state) {
    return Builder(builder: (context) {
      return Scaffold(
        body: NoDataFound(
          text:
              "Error 404. Page Not Found\nPlease press the button below to report this error to us so we can fix it.",
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            FeedbackServices().startFeedingBackward(context);
          },
          icon: Icon(
            FontAwesomeIcons.bug,
          ),
          label: Text(
            "Report this error",
          ),
        ),
      );
    });
  },
  routes: [
    //splash
    GoRoute(
      name: RouteConstants.splash,
      path: "/",
      pageBuilder: (context, state) {
        return MaterialPage(
          child: SplashScreenView(),
        );
      },
    ),
    //about us
    GoRoute(
      name: RouteConstants.aboutUs,
      path: "/${RouteConstants.aboutUs}",
      pageBuilder: (context, state) {
        return MaterialPage(
          child: AboutUs(),
        );
      },
    ),
    //onboarding
    GoRoute(
      name: RouteConstants.onboarding,
      path: "/${RouteConstants.onboarding}",
      pageBuilder: (context, state) {
        return MaterialPage(
          child: OnboardingView(),
        );
      },
    ),
    //dash and home
    GoRoute(
      name: RouteConstants.home,
      path: "/${RouteConstants.home}",
      pageBuilder: (context, state) {
        return MaterialPage(
          child: Dashboard(),
        );
      },
    ),
    //detailed image
    GoRoute(
      name: RouteConstants.image,
      path: "/${RouteConstants.image}",
      pageBuilder: (context, state) {
        return MaterialPage(
          child: DetailedImage(
            images: state.extra,
          ),
        );
      },
    ),
    //detailed restaurant
    GoRoute(
      name: RouteConstants.restaurant,
      path: "/${RouteConstants.restaurant}/:id",
      pageBuilder: (context, state) {
        return MaterialPage(
          child: RestaurantView(
            restaurant: state.extra as Restaurant,
            restaurantID: state.params["id"],
          ),
        );
      },
    ),
    //detailed food
    GoRoute(
      name: RouteConstants.food,
      path: "/${RouteConstants.food}/:id",
      pageBuilder: (context, state) {
        return MaterialPage(
          child: FoodDetails(
            food: state.extra as FoodModel,
            foodID: state.params["id"],
          ),
        );
      },
    ),
    //detailed order
    GoRoute(
      name: RouteConstants.order,
      path: "/${RouteConstants.order}/:id",
      pageBuilder: (context, state) {
        return MaterialPage(
          child: OrderDetails(
            order: state.extra as DorxOrder,
            orderID: state.params["id"],
          ),
        );
      },
    ),
    //detailed menu
    GoRoute(
      name: RouteConstants.menu,
      path: "/${RouteConstants.menu}/:id",
      pageBuilder: (context, state) {
        return MaterialPage(
          child: DetailedMenuView(
            menu: state.extra as Menu,
            menuID: state.params["id"],
          ),
        );
      },
    ),
    //notifications
    GoRoute(
      name: RouteConstants.notifications,
      path: "/${RouteConstants.notifications}",
      pageBuilder: (context, state) {
        return MaterialPage(
          child: NotificationsView(),
        );
      },
    ),
    //user
    GoRoute(
      name: RouteConstants.myProfile,
      path: "/${RouteConstants.myProfile}",
      pageBuilder: (context, state) {
        return MaterialPage(
          child: UserProfileView(),
        );
      },
    ),
  ],
);

class RouteConstants {
  static String aboutUs = "aboutUs";
  static String splash = "splash";
  static String image = "image";
  static String menu = "menu";
  static String order = "order";
  static String onboarding = "onboarding";
  static String restaurant = "restaurant";
  static String food = "food";
  static String home = "home";
  static String notifications = "notifications";
  static String myProfile = "myprofile";
}
