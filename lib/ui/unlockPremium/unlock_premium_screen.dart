import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/custom/dialogs/ProgressDialog.dart';
import 'package:homeworkout_flutter/inapppurchase/IAPCallback.dart';
import 'package:homeworkout_flutter/inapppurchase/InAppPurchaseHelper.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class UnlockPremiumScreen extends StatefulWidget {
  @override
  _UnlockPremiumScreenState createState() => _UnlockPremiumScreenState();
}

class _UnlockPremiumScreenState extends State<UnlockPremiumScreen>
    implements IAPCallback {
  Map<String, PurchaseDetails>? purchases;
  bool isShowProgress = false;

  bool isSelectFreeTrial = false;
  final kInnerDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(30),
  );

  final kInnerDecorationSelected = BoxDecoration(
    color: Colur.theme,
    border: Border.all(color: Colur.theme),
    borderRadius: BorderRadius.circular(30),
  );

  final kGradientBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
        colors: [Colur.blueGradientButton1, Colur.blueGradientButton2]),
    border: Border.all(
      color: Colur.white,
    ),
    borderRadius: BorderRadius.circular(30),
  );

  @override
  void initState() {
    InAppPurchaseHelper().getAlreadyPurchaseItems(this);
    purchases = InAppPurchaseHelper().getPurchases();
    InAppPurchaseHelper().clearTransactions();
    super.initState();
  }

  void onPurchaseClick() {
    if (!isSelectFreeTrial) {
      ProductDetails? product = InAppPurchaseHelper()
          .getProductDetail(InAppPurchaseHelper.yearlySubscriptionId);
      InAppPurchaseHelper().buySubscription(product!, purchases!);
    } else {
      ProductDetails? product = InAppPurchaseHelper()
          .getProductDetail(InAppPurchaseHelper.monthlySubscriptionId);
      InAppPurchaseHelper().buySubscription(product!, purchases!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      child: ProgressDialog(
        child: _itemUnlockScreen(context),
        inAsyncCall: isShowProgress,
      ),
    );
  }

  _itemUnlockScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colur.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context,false);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colur.theme,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/ic_7_day_free_trial.webp",
                          scale: 4,
                        ),
                      ),
                      _widgetMonth(),
                      _widgetFreeTrial(),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          Languages.of(context)!.txtFreeTrialDesc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colur.txt_gray),
                        ),
                      ),
                      _widgetRemoveAdFunction(),
                    ],
                  ),
                ),
              ),
            ),
            _widgetStartButton(),
          ],
        ),
      ),
    );
  }

  _widgetMonth() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      margin: const EdgeInsets.only(right: 15, left: 15, top: 30),
      child: InkWell(
        onTap: () {
          setState(() {
            isSelectFreeTrial = true;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: (isSelectFreeTrial) ? true : false,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colur.white),
                    child: Icon(Icons.done_rounded),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 10),
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Text(
                          Languages.of(context)!.txt1month.toUpperCase(),
                          style: TextStyle(
                              color: (isSelectFreeTrial)
                                  ? Colur.white
                                  : Colur.theme,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        (InAppPurchaseHelper()
                                    .getProductDetail(InAppPurchaseHelper
                                        .monthlySubscriptionId)
                                    ?.price !=
                                null)
                            ? InAppPurchaseHelper()
                                    .getProductDetail(InAppPurchaseHelper
                                        .monthlySubscriptionId)!
                                    .price +
                                "/month"
                            : "₹850.00/month",
                        style: TextStyle(
                            color:
                                (isSelectFreeTrial) ? Colur.white : Colur.theme,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            decoration: (isSelectFreeTrial)
                ? kInnerDecorationSelected
                : kInnerDecoration,
          ),
        ),
      ),
      decoration: kGradientBoxDecoration,
    );
  }

  _widgetFreeTrial() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            isSelectFreeTrial = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: (isSelectFreeTrial) ? false : true,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colur.white),
                    child: Icon(Icons.done_rounded),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    Languages.of(context)!.txtFree7DaysTrial.toUpperCase(),
                    style: TextStyle(
                        color: (isSelectFreeTrial) ? Colur.theme : Colur.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            decoration: (isSelectFreeTrial)
                ? kInnerDecoration
                : kInnerDecorationSelected,
          ),
        ),
      ),
      decoration: kGradientBoxDecoration,
    );
  }

  _widgetRemoveAdFunction() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Image.asset(
                      "assets/icons/ic_done_purchase.webp",
                      scale: 3.5,
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    Languages.of(context)!.txtRemoveAds,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colur.theme,
                        fontSize: 17),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Image.asset(
                      "assets/icons/ic_done_purchase.webp",
                      scale: 3.5,
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    Languages.of(context)!.txtUnlimitedWorkout,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colur.theme,
                        fontSize: 17),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Image.asset(
                      "assets/icons/ic_done_purchase.webp",
                      scale: 3.5,
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    Languages.of(context)!.txt300PlusWorkout,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colur.theme,
                        fontSize: 17),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Image.asset(
                      "assets/icons/ic_done_purchase.webp",
                      scale: 3.5,
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    Languages.of(context)!.txtAddNewWorkoutConstant,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colur.theme,
                        fontSize: 17),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _widgetStartButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        gradient: LinearGradient(
          colors: [
            Colur.blueGradientButton1,
            Colur.blueGradientButton2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.clamp,
        ),
      ),
      child: TextButton(
        child: Text(
          Languages.of(context)!.txtStart.toUpperCase(),
          style: TextStyle(
            color: Colur.white,
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
          ),
        ),
        onPressed: () {
          setState(() {
            isShowProgress = true;
          });
          onPurchaseClick();
        },
      ),
    );
  }

  @override
  void onBillingError(error) {
    setState(() {
      isShowProgress = false;
      Debug.printLog("onBillingError ==>" + error.message);
    });
  }

  @override
  void onLoaded(bool initialized) {
    // TODO: implement onLoaded
  }

  @override
  void onPending(PurchaseDetails product) {
    // TODO: implement onPending
  }

  @override
  void onSuccessPurchase(PurchaseDetails product) {
    setState(() {
      isShowProgress = false;
    });
    Preference.shared.setBool(Preference.IS_PURCHASED, true);
    Navigator.pop(context, true);
  }
}
