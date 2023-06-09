import 'package:dorx/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dorx/constants/images.dart';
import 'package:dorx/widgets/custom_sized_box.dart';

import '../constants/ui.dart';

class NoDataFound extends StatefulWidget {
  final String text;
  final String doSthText;
  final Function onTap;
  final double picSize;
  NoDataFound({
    Key key,
    @required this.text,
    this.onTap,
    this.doSthText,
    this.picSize,
  }) : super(key: key);

  @override
  State<NoDataFound> createState() => _NoDataFoundState();
}

class _NoDataFoundState extends State<NoDataFound> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              noDataFoundSVG,
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            CustomSizedBox(
              sbSize: SBSize.small,
              height: true,
            ),
            Text(
              widget.text ?? translation(context).noDataFound,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            CustomSizedBox(
              sbSize: SBSize.small,
              height: true,
            ),
            if (widget.onTap != null)
              GestureDetector(
                onTap: () async {
                  widget.onTap();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: standardBorderRadius,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.doSthText ?? translation(context).tapHere,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
