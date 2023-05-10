import 'package:dorx/services/services.dart';
import 'package:flutter/material.dart';

class BackBar extends StatelessWidget {
  final String text;
  final bool showIcon;
  final Function onPressed;
  final bool dontShowSettings;
  final Widget action;
  final IconData icon;

  BackBar({
    Key key,
    @required this.icon,
    this.showIcon = true,
    @required this.onPressed,
    @required this.text,
    this.action,
    this.dontShowSettings = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 2,
          ),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              showIcon
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: onPressed ??
                            () {
                              if (context.canPop()) {
                               Navigator.of(context).pop();
                              } else {
                                context.pushReplacementNamed(
                                  RouteConstants.home,
                                );
                              }
                            },
                        child: CircleAvatar(
                          child: IconButton(
                            icon: Icon(
                              icon ?? Icons.arrow_back_ios_rounded,
                            ),
                            onPressed: onPressed ??
                                () {
                                  if (context.canPop()) {
                                   Navigator.of(context).pop();
                                  } else {
                                    context.pushReplacementNamed(
                                      RouteConstants.home,
                                    );
                                  }
                                },
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 20,
                    ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (action != null) action,
              if (!dontShowSettings)
                SizedBox(
                  width: 10,
                ),
              if (!dontShowSettings)
                IconButton(
                  onPressed: () {
                    FeedbackServices().startFeedingBackward(context);
                  },
                  icon: Icon(
                    Icons.feedback,
                  ),
                ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
