import 'package:dorx/models/language.dart';
import 'package:dorx/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/constants.dart';
import 'widgets.dart';

class MenuBottomSheet extends StatefulWidget {
  MenuBottomSheet({Key key}) : super(key: key);

  @override
  State<MenuBottomSheet> createState() => _MenuBottomSheetState();
}

class _MenuBottomSheetState extends State<MenuBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSizedBox(
                sbSize: SBSize.smallest,
                height: true,
              ),
              Text(
                capitalizedAppName,
                style: TextStyle(
                  fontSize: 30,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              OnlyWhenLoggedIn(
                notSignedIn: Text(
                  "Guest",
                  style: TextStyle(fontSize: 16, color: primaryColor),
                ),
                signedInBuilder: (uid) {
                  return Text(
                    AuthProvider.of(context)
                            .auth
                            .getCurrentUser()
                            .displayName ??
                        "Ola 😊 How are ya..",
                    style: TextStyle(fontSize: 16, color: primaryColor),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OnlyWhenLoggedIn(
                        notSignedIn: singleDrawerItem(
                          onTap: () {
                            UIServices().showLoginSheet(
                              (v) {},
                              context,
                            );
                          },
                          label: "Click here and Log in to access all features",
                          icon: Icon(
                            Icons.login,
                            size: 25,
                            color: primaryColor,
                          ),
                        ),
                        signedInBuilder: (uid) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomSizedBox(
                                sbSize: SBSize.smallest,
                                height: true,
                              ),
                              Text(
                                "Me",
                                style: TextStyle(fontSize: 17),
                              ),
                              singleDrawerItem(
                                label: "Notifications",
                                onTap: () {
                                  if (AuthProvider.of(context)
                                      .auth
                                      .isSignedIn()) {
                                    context.pushNamed(
                                      RouteConstants.notifications,
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return NotLoggedInDialogBox(
                                          onLoggedIn: (v) {
                                            context.pushNamed(
                                              RouteConstants.notifications,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.notifications,
                                  color: primaryColor,
                                ),
                              ),
                              singleDrawerItem(
                                label: "My Profile",
                                onTap: () {
                                  if (AuthProvider.of(context)
                                      .auth
                                      .isSignedIn()) {
                                    context.pushNamed(
                                      RouteConstants.myProfile,
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return NotLoggedInDialogBox(
                                          onLoggedIn: (v) {
                                            context.pushNamed(
                                              RouteConstants.myProfile,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.verified_user,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      CustomSizedBox(
                        sbSize: SBSize.normal,
                        height: true,
                      ),
                      Text(
                        "Explore $capitalizedAppName",
                        style: TextStyle(fontSize: 17),
                      ),
                      singleDrawerItem(
                        image: foodLogoLight,
                        label: "What Is $capitalizedAppName",
                        icon: Icon(
                          Icons.question_answer,
                        ),
                        onTap: () {
                          context.pushNamed(
                            RouteConstants.onboarding,
                          );
                        },
                      ),
                      CustomSizedBox(
                        sbSize: SBSize.normal,
                        height: true,
                      ),
                      Text(
                        "Support",
                        style: TextStyle(fontSize: 17),
                      ),
                      singleDrawerItem(
                        label: "Feedback",
                        icon: Icon(
                          Icons.feedback,
                          color: primaryColor,
                        ),
                        onTap: () {
                          FeedbackServices().startFeedingBackward(
                            context,
                          );
                        },
                      ),
                      singleDrawerItem(
                        label: "Settings",
                        icon: Icon(
                          Icons.settings,
                          color: primaryColor,
                        ),
                        onTap: () {
                          UIServices().showDatSheet(
                            SettingsBottomSheet(),
                            true,
                            context,
                          );
                        },
                      ),
                      singleDrawerItem(
                        label:
                            "${translation(context).about} $capitalizedAppName",
                        onTap: () {
                          context.pushNamed(
                            RouteConstants.aboutUs,
                          );
                        },
                        icon: Icon(
                          Icons.help,
                          color: primaryColor,
                        ),
                      ),
                      singleDrawerItem(
                        label:
                            "Exciting news! We now have a web app for you incase you cant get the app.\nTap here to copy the link.",
                        icon: Icon(
                          Icons.web,
                          color: primaryColor,
                        ),
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: customerWebAppLink,
                            ),
                          );

                          CommunicationServices().showToast(
                            "Link has been copied.",
                            primaryColor,
                          );
                        },
                      ),
                      singleDrawerItem(
                        label: "Share $capitalizedAppName",
                        onTap: () {
                          Share.share(
                            'Hey there. I know we probably haven\'t texted in a while, but i just found a revolutionary app i think you\'d reeeally like.. Tap this link $appLinkToPlaystore',
                            subject: 'I found something you may like.',
                          );
                        },
                        icon: Icon(
                          Icons.share,
                          color: primaryColor,
                        ),
                      ),
                      singleDrawerItem(
                        label: "Rate $capitalizedAppName",
                        onTap: () {
                          StorageServices().launchTheThing(
                            appLinkToPlaystore,
                          );
                        },
                        icon: Icon(
                          Icons.star,
                          color: primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                ShamelessSelfPlug(),
                CustomSizedBox(
                  sbSize: SBSize.small,
                  height: true,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (AuthProvider.of(context).auth.isSignedIn()) {
                      try {
                        await AuthProvider.of(context).auth.signOut();
                      } catch (e) {
                        CommunicationServices().showToast(
                          "There was an error logging you out. ${e.toString()}",
                          Colors.blue,
                        );
                      }
                    } else {
                      UIServices().showLoginSheet(
                        (v) {},
                        context,
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: standardBorderRadius,
                      border: Border.all(),
                    ),
                    child: Center(
                      child: OnlyWhenLoggedIn(
                        notSignedIn: Text(
                          translation(context).signIn,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        signedInBuilder: (uid) {
                          return Text(
                            translation(context).logOut,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  singleDrawerItem({
    @required String label,
    String image,
    @required Function onTap,
    @required Icon icon,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                image == null
                    ? icon
                    : CircleAvatar(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleImage(
                            image: image,
                          ),
                        ),
                      ),
                CustomSizedBox(
                  sbSize: SBSize.small,
                  height: false,
                ),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 5,
          )
        ],
      ),
    );
  }
}
