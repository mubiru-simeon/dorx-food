import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorx/constants/basic.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/ui.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'widgets.dart';

class PaymentsViewappBar extends StatefulWidget {
  final bool isScrolled;
  final String viewerID;
  final String viewerType;
  final bool pushed;
  final String text;
  PaymentsViewappBar({
    Key key,
    @required this.isScrolled,
    @required this.text,
    @required this.pushed,
    @required this.viewerType,
    @required this.viewerID,
  }) : super(key: key);

  @override
  State<PaymentsViewappBar> createState() => _PaymentsViewappBarState();
}

class _PaymentsViewappBarState extends State<PaymentsViewappBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 150.0,
      elevation: 0,
      pinned: true,
      stretch: true,
      toolbarHeight: 80,
      leading: widget.pushed
          ? IconButton(
              onPressed: () {
                if (context.canPop()) {
                 Navigator.of(context).pop();
                } else {
                  context.pushReplacementNamed(
                    RouteConstants.home,
                  );
                }
              },
              icon: Icon(
                Icons.arrow_back,
              ),
            )
          : SizedBox(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderDouble),
          bottomRight: Radius.circular(borderDouble),
        ),
      ),
      centerTitle: true,
      title: AnimatedOpacity(
        opacity: widget.isScrolled ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Column(
          children: [
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: standardBorderRadius,
              ),
            ),
          ],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        titlePadding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        title: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: widget.isScrolled ? 0.0 : 1.0,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomSizedBox(
                  sbSize: SBSize.smallest,
                  height: true,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: standardBorderRadius,
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: singleMenuItem(
                          Icons.add_circle_outline,
                          "Top-Up",
                          () {
                            UIServices().showDatSheet(
                              MyQrCodes(),
                              true,
                              context,
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 0.5,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: singleMenuItem(
                          FontAwesomeIcons.qrcode,
                          "View QR",
                          () {
                            UIServices().showDatSheet(
                              MyQrCodes(),
                              true,
                              context,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                CustomSizedBox(
                  sbSize: SBSize.smallest,
                  height: true,
                ),
                Container(
                  width: 30,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: standardBorderRadius,
                  ),
                ),
                CustomSizedBox(
                  sbSize: SBSize.smallest,
                  height: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  singleMenuItem(
    IconData icon,
    String text,
    Function onTap,
  ) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.white,
          ),
          CustomSizedBox(
            sbSize: SBSize.smallest,
            height: true,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
            ),
          )
        ],
      ),
    );
  }
}

class SendOptionsBottomSheet extends StatefulWidget {
  final String viewerID;
  final String viewerType;

  SendOptionsBottomSheet({
    Key key,
    @required this.viewerType,
    @required this.viewerID,
  }) : super(key: key);

  @override
  State<SendOptionsBottomSheet> createState() => _SendOptionsBottomSheetState();
}

class _SendOptionsBottomSheetState extends State<SendOptionsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return OnlyWhenLoggedIn(signedInBuilder: (uid) {
      return SingleChildScrollView(
        child: Column(
          children: [
            BackBar(
              icon: null,
              onPressed: null,
              text: "Send Funds to someone",
            ),
            InformationalBox(
              visible: true,
              onClose: null,
              message:
                  "You can send money to the person / business via scanning their QR Code",
            ),
            SingleSelectTile(
              onTap: () {
                StorageServices().scanQRCode(
                  null,
                  (v) {
                    proceedWithPAyment(
                      v[QRCodeScannerResult.THINGID],
                      v[QRCodeScannerResult.THINGTYPE],
                    );
                  },
                  context,
                );
              },
              selected: false,
              icon: Icon(
                FontAwesomeIcons.qrcode,
              ),
              asset: null,
              text: "Scan the QR Code",
              desc:
                  "Tell the recepient to show you their $capitalizedAppName QR Code.",
            ),
            CustomSizedBox(
              sbSize: SBSize.normal,
              height: true,
            ),
          ],
        ),
      );
    });
  }

  proceedWithPAyment(
    String selectedRecepient,
    String type,
  ) {
    if (type == ThingType.USER || type == ThingType.RESTAURANT) {
      UIServices().showDatSheet(
        DecideAmountToSend(
          sender: widget.viewerID,
          senderType: widget.viewerType,
          recepientType: type,
          recepient: selectedRecepient,
        ),
        true,
        context,
      );
    } else {
      CommunicationServices().showToast(
        "Unsupported Item. Please only try sending money to people or businesses. You can't send money to a $type.",
        Colors.red,
      );
    }
  }
}

class DecideAmountToSend extends StatefulWidget {
  final String recepient;
  final String sender;
  final String senderType;
  final String recepientType;
  DecideAmountToSend({
    Key key,
    @required this.recepient,
    @required this.senderType,
    @required this.recepientType,
    @required this.sender,
  }) : super(key: key);

  @override
  State<DecideAmountToSend> createState() => _DecideAmountToSendState();
}

class _DecideAmountToSendState extends State<DecideAmountToSend> {
  bool processing = false;
  TextEditingController amountController = TextEditingController();
  ButtonController controller;

  @override
  void initState() {
    controller = ButtonController(
      buttonColor: primaryColor,
      onSlideSuccessCallback: () {
        pay();
      },
      widgetWhenSlideIsCompleted: SpinKitWave(
        size: 20,
        color: primaryColor,
      ),
      slideButtonIconColor: primaryColor,
      radius: 25,
      buttonHeight: 55,
      buttonText: "Slide to send",
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BackBar(
            icon: null,
            onPressed: null,
            text: "How much?",
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Recepient",
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: SinglePreviousItem(
                      type: widget.recepientType,
                      usableThingID: widget.recepient,
                    ),
                  ),
                  CustomSizedBox(
                    sbSize: SBSize.smallest,
                    height: true,
                  ),
                  if (widget.recepientType == ThingType.RESTAURANT)
                    IndividualBalanceWidget(
                      balance: null,
                      entity: widget.recepient,
                      customer: AuthProvider.of(context).auth.getCurrentUID(),
                    ),
                  CustomSizedBox(
                    sbSize: SBSize.smallest,
                    height: true,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: amountController,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter Amount",
                            hintStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      CustomSizedBox(
                        sbSize: SBSize.small,
                        height: false,
                      ),
                      Text(
                        "UGX",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomSizedBox(
                        sbSize: SBSize.small,
                        height: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Wrap(
        children: [
          Column(
            children: [
              SlidingButton(
                controller: controller,
                processing: processing,
              ),
            ],
          )
        ],
      ),
    );
  }

  pay() {
    setState(() {
      processing = true;
    });

    FirebaseDatabase.instance
        .ref()
        .child(Payment.ACCOUNTBALANCEDIRECTORY)
        .child(widget.sender)
        .once()
        .then(
      (value) {
        int balance = value.snapshot.value ?? 0;

        if (int.parse(amountController.text.trim().toString()) > balance) {
          stopLoading();

          CommunicationServices().showToast(
            "Your wallet account balance is insufficient. You have UGX $balance. Please top up and try again.",
            Colors.red,
          );
        } else {
          sendMoney();
        }
      },
    ).catchError((b) {
      stopLoading();

      CommunicationServices().showToast(
        "There was an error finding your account balance. Please check your internet connection and try again.",
        Colors.red,
      );
    });
  }

  sendMoney() {
    StorageServices().paySomeone(
      double.parse(amountController.text.trim()),
      false,
      widget.sender,
      widget.recepient,
      widget.senderType,
      "Wallet Transfer",
      widget.senderType,
      widget.senderType,
      widget.recepientType,
      true,
      true,
      false,
      WALLET,
    );

   Navigator.of(context).pop();
   Navigator.of(context).pop();

    FirebaseFirestore.instance
        .collection(Payment.USUALRECEPIENTS)
        .doc(widget.sender)
        .collection(widget.sender)
        .add({
      Payment.TIME: DateTime.now().millisecondsSinceEpoch,
      Payment.THINGID: widget.recepient,
      Payment.THINGTYPE: widget.recepientType,
    });

    CommunicationServices().showToast(
      "Successfully transfereed the funds.",
      Colors.green,
    );
  }

  stopLoading() {
    controller.reset();
    processing = false;
    setState(() {});
  }
}
