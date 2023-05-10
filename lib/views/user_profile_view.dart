import 'package:dorx/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorx/views/edit_profile_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class UserProfileView extends StatefulWidget {
  UserProfileView({
    Key key,
  }) : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnlyWhenLoggedIn(
        signedInBuilder: (uid) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(UserModel.DIRECTORY)
                .doc(uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingWidget();
              } else {
                UserModel model = UserModel.fromSnapshot(
                  snapshot.data,
                );

                return body(model);
              }
            },
          );
        },
      ),
    );
  }

  body(UserModel userModel) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BackBar(
              icon: null,
              onPressed: null,
              text: translation(context).profile,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        userModel.profilePic != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  userModel.profilePic,
                                  width: kIsWeb
                                      ? 100
                                      : MediaQuery.of(context).size.width * 0.5,
                                  height: kIsWeb
                                      ? 100
                                      : MediaQuery.of(context).size.width * 0.5,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, v, b) {
                                    return Image(
                                      width: kIsWeb
                                          ? 100
                                          : MediaQuery.of(context).size.width *
                                              0.5,
                                      height: kIsWeb
                                          ? 100
                                          : MediaQuery.of(context).size.width *
                                              0.5,
                                      image: AssetImage(
                                        defaultUserPic,
                                      ),
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                  width: kIsWeb
                                      ? 100
                                      : MediaQuery.of(context).size.width * 0.5,
                                  height: kIsWeb
                                      ? 100
                                      : MediaQuery.of(context).size.width * 0.5,
                                  image: AssetImage(defaultUserPic),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Material(
                        elevation: standardElevation,
                        borderRadius: standardBorderRadius,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                              titleAndSub(
                                context,
                                title: translation(context).firstName,
                                sub: userModel.userName,
                                showSpace: true,
                                visible: userModel.userName != null,
                              ),
                              if (userModel.phoneNumber != null &&
                                  userModel.phoneNumber.trim().isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    StorageServices().launchTheThing(
                                        "tel:${userModel.phoneNumber}");
                                  },
                                  child: titleAndSub(
                                    context,
                                    title: translation(context).phoneNumber,
                                    sub: userModel.phoneNumber,
                                    showSpace: true,
                                    clickable: true,
                                    visible: userModel.phoneNumber != null,
                                  ),
                                ),
                              if (userModel.email != null &&
                                  userModel.email.trim().isNotEmpty)
                                GestureDetector(
                                  onTap: () {},
                                  child: titleAndSub(
                                    context,
                                    title: translation(context).email,
                                    sub: userModel.email,
                                    showSpace: true,
                                    clickable: true,
                                    visible: userModel.email != null,
                                  ),
                                ),
                              SizedBox(
                                height: 20,
                              ),
                              SingleBigButton(
                                text:
                                    "${translation(context).change} ${translation(context).email}",
                                color: primaryColor,
                                onPressed: () {
                                  UIServices().showDatSheet(
                                    ResetEmailBottomSheet(),
                                    true,
                                    context,
                                  );
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SingleBigButton(
                                text:
                                    "${translation(context).change} ${translation(context).password}",
                                color: primaryColor,
                                onPressed: () {
                                  UIServices().showDatSheet(
                                    ChangePasswordBottomSheet(),
                                    true,
                                    context,
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          UIServices().showDatSheet(
              EditProfileView(
                user: userModel,
              ),
              true,
              context);
        },
        child: Icon(
          Icons.edit,
        ),
      ),
    );
  }

  titleAndSub(
    BuildContext context, {
    String title,
    String sub,
    bool clickable,
    bool showSpace,
    bool visible,
  }) {
    return Visibility(
      visible: visible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    sub,
                    style: TextStyle(
                      fontSize: 20,
                      color:
                          clickable != null && clickable ? Colors.blue : null,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: showSpace,
            child: SizedBox(
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class ResetEmailBottomSheet extends StatefulWidget {
  const ResetEmailBottomSheet({Key key}) : super(key: key);

  @override
  State<ResetEmailBottomSheet> createState() => _ResetEmailBottomSheetState();
}

class _ResetEmailBottomSheetState extends State<ResetEmailBottomSheet> {
  TextEditingController emailController = TextEditingController();
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BackBar(
          icon: null,
          onPressed: null,
          text: "${translation(context).change} ${translation(context).email}",
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  StatisticText(
                    title: translation(context).stepOneSignOut,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SingleBigButton(
                    text: translation(context).pressHereToLogOut,
                    color: primaryColor,
                    onPressed: () async {
                      await AuthProvider.of(context).auth.signOut();

                      CommunicationServices().showToast(
                        translation(context).successfullySignedOut,
                        primaryColor,
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StatisticText(title: translation(context).stepTwoSignIn),
                  SizedBox(
                    height: 5,
                  ),
                  SingleBigButton(
                    text: translation(context).signIn,
                    color: primaryColor,
                    onPressed: () async {
                      UIServices().showLoginSheet(
                        (id) {
                          CommunicationServices().showToast(
                            translation(context).successfullySignedIn,
                            primaryColor,
                          );
                        },
                        context,
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StatisticText(
                    title: translation(context).stepThreeEnterNewEmail,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: translation(context).typeHere,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SingleBigButton(
                    processing: processing,
                    text:
                        "${translation(context).change} ${translation(context).email}",
                    color: primaryColor,
                    onPressed: () async {
                      if (emailController.text.trim().isEmpty) {
                        CommunicationServices().showToast(
                          translation(context).youNeedToProvideEmail,
                          primaryColor,
                        );
                      } else {
                        setState(() {
                          processing = true;
                        });

                        FirebaseFirestore.instance
                            .collection(UserModel.DIRECTORY)
                            .where(UserModel.EMAIL,
                                isEqualTo: emailController.text.trim())
                            .get()
                            .then(
                          (value) {
                            if (value.docs.isNotEmpty) {
                              setState(() {
                                processing = false;
                              });

                              CommunicationServices().showToast(
                                translation(context)
                                    .thisEmailIsAlreadyBeingUsed,
                                Colors.red,
                              );
                            } else {
                              setState(() {
                                processing = false;
                              });

                              try {
                                AuthProvider.of(context)
                                    .auth
                                    .getCurrentUser()
                                    .updateEmail(
                                      emailController.text.trim(),
                                    )
                                    .then(
                                  (value) {
                                    FirebaseFirestore.instance
                                        .collection(UserModel.DIRECTORY)
                                        .doc(AuthProvider.of(context)
                                            .auth
                                            .getCurrentUID())
                                        .update({
                                      UserModel.EMAIL:
                                          emailController.text.trim(),
                                    });

                                    Navigator.of(context).pop();

                                    CommunicationServices().showToast(
                                      translation(context).success,
                                      Colors.red,
                                    );
                                  },
                                );
                              } catch (e) {
                                CommunicationServices().showToast(
                                  "${translation(context).error}: $e",
                                  Colors.red,
                                );
                              }
                            }
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({Key key}) : super(key: key);

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  TextEditingController passwordController = TextEditingController();
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BackBar(
          icon: null,
          onPressed: null,
          text:
              "${translation(context).change} ${translation(context).password}",
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  StatisticText(
                    title: translation(context).stepOneSignOut,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SingleBigButton(
                    text: translation(context).pressHereToLogOut,
                    color: primaryColor,
                    onPressed: () async {
                      await AuthProvider.of(context).auth.signOut();

                      CommunicationServices().showToast(
                        translation(context).successfullySignedOut,
                        primaryColor,
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StatisticText(
                    title: translation(context).stepTwoSignIn,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SingleBigButton(
                    text: translation(context).signIn,
                    color: primaryColor,
                    onPressed: () async {
                      UIServices().showLoginSheet(
                        (id) {
                          CommunicationServices().showToast(
                            translation(context).successfullySignedIn,
                            primaryColor,
                          );
                        },
                        context,
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StatisticText(
                    title:
                        "Step 3) Enter your new password and press change password. If it's successful, you'll see a notification and this sheet will go away. If nothing happens, please log out and log in again to change your password.",
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: translation(context).typeHere,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SingleBigButton(
                    processing: processing,
                    text:
                        "${translation(context).change} ${translation(context).password}",
                    color: primaryColor,
                    onPressed: () async {
                      if (passwordController.text.trim().isEmpty) {
                        CommunicationServices().showToast(
                          translation(context).youNeedToProvidePassword,
                          primaryColor,
                        );
                      } else {
                        AuthProvider.of(context)
                            .auth
                            .getCurrentUser()
                            .updatePassword(
                              passwordController.text.trim(),
                            )
                            .then(
                          (value) {
                            Navigator.of(context).pop();

                            CommunicationServices().showToast(
                              translation(context).success,
                              Colors.red,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
