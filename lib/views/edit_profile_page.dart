import 'dart:io';
import 'package:dorx/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorx/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dorx/widgets/proceed_button.dart';
import 'package:dorx/widgets/top_back_bar.dart';

import '../services/services.dart';

class EditProfileView extends StatefulWidget {
  final UserModel user;
  EditProfileView({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  List<File> temp = [];
  File img;
  String initialPic;
  bool processing = false;
  TextEditingController userNameController;
  TextEditingController phoneNumberController;

  String url;

  @override
  void initState() {
    super.initState();
    setDefaults();
  }

  setDefaults() {
    initialPic = widget.user.profilePic;
    userNameController = TextEditingController(
      text: widget.user.userName,
    );

    phoneNumberController = TextEditingController(
      text: widget.user.phoneNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.5),
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.9),
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0,
              0.4,
              0.8,
              0.9,
              1,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackBar(
                  icon: null,
                  onPressed: null,
                  text: translation(context).editYourProfile,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          setDefaults();
                          img = null;
                          if (mounted) setState(() {});
                        },
                        child: Center(
                          child: Text(
                            translation(context).resetAll,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 25),
                  child: Center(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: initialPic != null
                              ? Image.network(
                                  widget.user.profilePic,
                                  width: kIsWeb
                                      ? 100
                                      : MediaQuery.of(context).size.width * 0.5,
                                  height: kIsWeb
                                      ? 100
                                      : MediaQuery.of(context).size.width * 0.5,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, v, n) {
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
                                )
                              : Image(
                                  width: kIsWeb
                                      ? 100
                                      : MediaQuery.of(context).size.width * 0.5,
                                  height: kIsWeb
                                      ? 100
                                      : MediaQuery.of(context).size.width * 0.5,
                                  image: img == null
                                      ? AssetImage(
                                          defaultUserPic,
                                        )
                                      : FileImage(img),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Visibility(
                          visible: img != null,
                          child: Positioned(
                            top: 7,
                            right: 7,
                            child: IconButton(
                              icon: CircleAvatar(
                                child: Icon(
                                  Icons.close,
                                  size: 25,
                                ),
                              ),
                              onPressed: () async {
                                img = null;
                                if (mounted) setState(() {});
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 7,
                          right: 7,
                          child: IconButton(
                            icon: Icon(
                              Icons.camera,
                              size: 40,
                            ),
                            onPressed: () async {
                              temp = await ImageServices().pickImages(
                                context,
                                limit: 1,
                              );

                              initialPic = null;
                              img = temp[0];
                              if (mounted) setState(() {});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          titleAndSub(
                            title: translation(context).firstName,
                            type: TextInputType.text,
                            controller: userNameController,
                            hint: widget.user.userName,
                            showSpace: true,
                            visible: true,
                          ),
                          titleAndSub(
                            title: translation(context).phoneNumber,
                            type: TextInputType.phone,
                            controller: phoneNumberController,
                            hint: widget.user.phoneNumber,
                            showSpace: true,
                            visible: true,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Wrap(
        children: [
          ProceedButton(
            text: translation(context).editYourProfile,
            onTap: () {
              if (userNameController.text.trim().isEmpty) {
                CommunicationServices().showToast(
                  translation(context).youNeedToProvideName,
                  Colors.red,
                );
              } else {
                if (phoneNumberController.text.trim().isEmpty) {
                  CommunicationServices().showToast(
                    translation(context).phoneNumber,
                    Colors.red,
                  );
                } else {
                  uploadImages();
                }
              }
            },
            enablable: false,
            processing: processing,
          ),
        ],
      ),
    );
  }

  uploadImages() async {
    List<String> imgUrls = [];

    setState(() {
      processing = true;
    });

    imgUrls = await ImageServices().uploadImages(
      path: "display_pic",
      onError: () {
        setState(() {
          processing = false;
        });

        CommunicationServices().showSnackBar(
          translation(context).errorUploadingImages,
          context,
        );
      },
      images: [img],
    );

    if (imgUrls.isNotEmpty) {
      url = imgUrls[0];
    }

    if (processing) updateProfile();
  }

  updateProfile() async {
    if (img != null &&
        (widget.user.id == AuthProvider.of(context).auth.getCurrentUID())) {
      await AuthProvider.of(context).auth.updateProfPic(url);
    }

    if (userNameController.text.trim().isNotEmpty &&
        (widget.user.id == AuthProvider.of(context).auth.getCurrentUID())) {
      AuthProvider.of(context).auth.updateUserName(
            userNameController.text.trim(),
            AuthProvider.of(context).auth.getCurrentUser(),
          );
    }

    FirebaseFirestore.instance
        .collection(UserModel.DIRECTORY)
        .doc(widget.user.id)
        .update({
      UserModel.PHONENUMBER: phoneNumberController.text.trim().isEmpty
          ? null
          : phoneNumberController.text.trim(),
      UserModel.PROFILEPIC: img == null ? widget.user.profilePic : url,
      UserModel.USERNAME: userNameController.text.trim().isEmpty
          ? null
          : userNameController.text.trim(),
    }).then((value) {
      if (context.canPop()) {
        Navigator.of(context).pop();
      } else {
        context.pushReplacementNamed(
          RouteConstants.home,
        );
      }
    });
  }

  singleDateThing(
    String day,
    TextEditingController startDate,
    TextEditingController stopDate,
  ) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              controller: startDate,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 0,
                  ),
                ),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              controller: stopDate,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 0,
                  ),
                ),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          )
        ],
      ),
    );
  }

  titleAndSub({
    String title,
    String hint,
    TextInputType type,
    TextEditingController controller,
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
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    keyboardType: type,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      //hintText: hint,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0)),
                      contentPadding: EdgeInsets.all(10),
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

class Item {
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}
