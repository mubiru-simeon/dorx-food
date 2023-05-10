import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorx/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import '../constants/constants.dart';
import '../main.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../theming/theme_controller.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({Key key}) : super(key: key);

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  Box box;
  String mode;

  @override
  void initState() {
    box = Hive.box(DorxSettings.DORXBOXNAME);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mode = box.get(UserModel.ACCOUNTTYPES);

    return Column(
      children: [
        BackBar(
          icon: null,
          onPressed: null,
          text: "Settings",
          dontShowSettings: true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            children: [
              CustomSwitch(
                text: "Change app to light / dark theme ",
                selected: ThemeBuilder.of(context).getCurrentTheme() ==
                    Brightness.light,
                onTap: (v) async {
                  setState(() {
                    if (v) {
                      ThemeBuilder.of(context).makeLight();

                      box.put(
                        sharedPrefBrightness,
                        "light",
                      );
                    } else {
                      ThemeBuilder.of(context).makeDark();

                      box.put(
                        sharedPrefBrightness,
                        "dark",
                      );
                    }
                  });
                },
                icon: Icons.sunny,
              ),
              PopupMenuButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.language),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          translation(context).changeLanguage,
                          style: darkTitle,
                        ),
                      )
                    ],
                  ),
                ),
                itemBuilder: (context) {
                  return Language.languageList()
                      .map(
                        (e) => PopupMenuItem(
                          value: e.languageCode,
                          child: Text(
                            "${e.name}  ${e.flag}",
                          ),
                        ),
                      )
                      .toList();
                },
                onSelected: (val) async {
                  Locale locale = await saveLocaleToPrefs(
                    val,
                    box,
                  );

                  MyApp.setLocale(context, locale);
                },
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
        Expanded(
          child: OnlyWhenLoggedIn(signedInBuilder: (uid) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(UserModel.DIRECTORY)
                    .doc(uid)
                    .snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return LoadingWidget();
                  } else {
                    UserModel userModel = UserModel.fromSnapshot(
                      snap.data,
                    );

                    return body(
                      null,
                      userModel,
                    );
                  }
                });
          }),
        )
      ],
    );
  }

  Widget body(
    Restaurant restaurant,
    UserModel user,
  ) {
    DorxSettings settings = DorxSettings.fromMap(
      null,
      user.settingsMAp,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatisticText(
              title: "User Account Settings",
            ),
            CustomSwitch(
              text: "Email notifications",
              selected: settings.emailNotifications,
              onTap: (v) {
                dynamic dd = user.settingsMAp ?? {};
                dd.addAll({
                  DorxSettings.EMAILNOTIFICATIONS: v,
                });

                FirebaseFirestore.instance
                    .collection(UserModel.DIRECTORY)
                    .doc(user.id)
                    .update({
                  DorxSettings.SETTINGSMAP: dd,
                });
              },
              icon: Icons.email,
            ),
          ],
        ),
      ),
    );
  }
}

class DiNumberTing extends StatefulWidget {
  final bool maxWidth;
  final String text;
  final String subTitle;
  final bool simple;
  final Function onTapSubtitle;
  final int count;
  final Function(int v) onAdd;
  final Function(int v) onRemove;
  DiNumberTing({
    Key key,
    @required this.onAdd,
    @required this.onRemove,
    @required this.text,
    this.maxWidth = false,
    this.simple = false,
    @required this.count,
    this.subTitle,
    this.onTapSubtitle,
  }) : super(key: key);

  @override
  State<DiNumberTing> createState() => _DiNumberTingState();
}

class _DiNumberTingState extends State<DiNumberTing> {
  List<int> options = [
    1,
    2,
    5,
    10,
    20,
    50,
    100,
    1000,
    10000,
    100000,
    1000000,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: Material(
        elevation: standardElevation,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.text,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.subTitle != null)
                            GestureDetector(
                              onTap: () {
                                if (widget.onTapSubtitle != null) {
                                  widget.onTapSubtitle();
                                }
                              },
                              child: Text(
                                widget.subTitle,
                                style: TextStyle(
                                  decorationStyle: TextDecorationStyle.wavy,
                                  fontWeight: widget.onTapSubtitle != null
                                      ? FontWeight.bold
                                      : null,
                                  decoration: widget.onTapSubtitle != null
                                      ? TextDecoration.underline
                                      : null,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onRemove(1);
                          },
                          child: Icon(
                            Icons.remove_circle_outline,
                            size: 32,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              TextService().putCommas(
                                widget.count.toString(),
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onAdd(1);
                          },
                          child: Icon(
                            Icons.add_circle_outline,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!widget.simple)
              Container(
                width: widget.maxWidth ? double.infinity : null,
                padding: const EdgeInsets.all(5),
                child: Wrap(
                    alignment: WrapAlignment.center,
                    children: options.map<Widget>((e) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () {
                            widget.onAdd(e);
                          },
                          child: Chip(
                            elevation: standardElevation,
                            onDeleted: () {
                              widget.onRemove(e);
                            },
                            clipBehavior: Clip.hardEdge,
                            label: Text(
                              e.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList()),
              ),
          ],
        ),
      ),
    );
  }
}
