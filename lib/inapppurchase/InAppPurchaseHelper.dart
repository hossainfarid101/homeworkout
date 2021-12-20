import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:homeworkout_flutter/inapppurchase/IAPCallback.dart';
import 'package:homeworkout_flutter/inapppurchase/IAPReceiptData.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_ios/store_kit_wrappers.dart';
import 'package:in_app_purchase_android/src/billing_client_wrappers/billing_client_wrapper.dart';

import '../main.dart';

class InAppPurchaseHelper {
  static final InAppPurchaseHelper _inAppPurchaseHelper =
      InAppPurchaseHelper._internal();

  InAppPurchaseHelper._internal();

  factory InAppPurchaseHelper({BuildContext? buildContext}) {
    if (buildContext != null) {
      _inAppPurchaseHelper._buildContext = buildContext;
    }
    return _inAppPurchaseHelper;
  }

  BuildContext? _buildContext;

  static const String monthlySubscriptionId = 'sub_month';
  static const String yearlySubscriptionId = 'sub_year';

  static const List<String> _kProductIds = <String>[
    monthlySubscriptionId,
    yearlySubscriptionId,
  ];

  final InAppPurchase _connection = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  IAPCallback? _iapCallback;

  initialize() {
    if (Platform.isAndroid) {
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    } /*else {
      SKPaymentQueueWrapper().restoreTransactions();
    }*/
  }

  /*launchReferralCodeFlow(){
    InAppPurchaseIosPlatformAddition iosPlatformAddition =
    _connection.getPlatformAddition<InAppPurchaseIosPlatformAddition>();
    iosPlatformAddition.presentCodeRedemptionSheet();
  }*/

  ProductDetails? getProductDetail(String productID) {
    for (ProductDetails item in _products) {
      if (item.id == productID) {
        return item;
      }
    }
    return null;
  }

  getAlreadyPurchaseItems(IAPCallback iapCallback) {
    _iapCallback = iapCallback;
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _connection.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      if (purchaseDetailsList != null && purchaseDetailsList.isNotEmpty) {
        purchaseDetailsList
            .sort((a, b) => a.transactionDate!.compareTo(b.transactionDate!));

        if (purchaseDetailsList[0].status == PurchaseStatus.restored) {
          getPastPurchases(purchaseDetailsList);
        } else
          _listenToPurchaseUpdated(purchaseDetailsList);
      }
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      print(error);
      handleError(error);
      // handle error here.
    });
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      _isAvailable = isAvailable;
      _products = [];
      _purchases = [];
      _purchasePending = false;
      _loading = false;
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      _queryProductError = productDetailResponse.error!.message;
      _queryProductError = productDetailResponse.error!.message;
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _purchasePending = false;
      _loading = false;
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      _queryProductError = null;
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _purchasePending = false;
      _loading = false;
      return;
    } else {
      _queryProductError = null;
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _purchasePending = false;
      _loading = false;
    }

    await _connection.restorePurchases();
    //await getPastPurchases();
  }

  Future<void> getPastPurchases(List<PurchaseDetails> verifiedPurchases) async {
    verifiedPurchases
        .sort((a, b) => a.transactionDate!.compareTo(b.transactionDate!));

    if (Platform.isIOS) {
      Map<String, PurchaseDetails> purchases =
          Map.fromEntries(verifiedPurchases.map((PurchaseDetails purchase) {
        if (purchase.pendingCompletePurchase) {
          _connection.completePurchase(purchase);
        }
        return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
      }));

      if (verifiedPurchases.isNotEmpty)
        await _verifyReceipts(verifiedPurchases);
      else {
        Debug.printLog("You have not Purchased :::::::::::::::::::=>");
        Preference.shared.setBool(Preference.IS_PURCHASED, false);
      }
    } else {
      if (verifiedPurchases.length > 0) {
        if (verifiedPurchases != null && verifiedPurchases.isNotEmpty) {
          _purchases = verifiedPurchases;
          Debug.printLog("You have already Purchased :::::::::::::::::::=>");
          Preference.shared.setBool(Preference.IS_PURCHASED, true);
          MyApp.purchaseStreamController.add(_purchases[0]);
        } else {
          Debug.printLog("You have not Purchased :::::::::::::::::::=>");
          Preference.shared.setBool(Preference.IS_PURCHASED, false);
        }
      } else {
        Debug.printLog("You have not Purchased :::::::::::::::::::=>");
        Preference.shared.setBool(Preference.IS_PURCHASED, false);
      }
    }
  }

  _verifyReceipts(List<PurchaseDetails> verifiedPurchases) async {
    var dio = Dio(
      BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 5000,
      ),
    );

    Map<String, String> data = {};
    data.putIfAbsent("receipt-data",
        () => verifiedPurchases[0].verificationData.localVerificationData);
    data.putIfAbsent("password", () => '89526516ead7470b9f82ebbc3b406ea2');

    try {
      String verifyReceiptUrl;

      if (Debug.SANDBOX_VERIFY_RECEIPT_URL)
        verifyReceiptUrl = 'https://sandbox.itunes.apple.com/verifyReceipt';
      else
        verifyReceiptUrl = 'https://buy.itunes.apple.com/verifyReceipt';

      final graphResponse =
          await dio.post<String>(verifyReceiptUrl, data: data);
      Map<String, dynamic> profile = jsonDecode(graphResponse.data!);

      //print("verifyReceipt Response =========> $profile");
      var receiptData = IapReceiptData.fromJson(profile);

      receiptData.latestReceiptInfo!
          .sort((a, b) => b.expiresDateMs!.compareTo(a.expiresDateMs!));
      if (int.parse(receiptData.latestReceiptInfo![0].expiresDateMs!) >
          DateTime.now().millisecondsSinceEpoch) {
        for (PurchaseDetails data in verifiedPurchases) {
          if (data.productID == receiptData.latestReceiptInfo![0].productId) {
            _purchases.clear();
            _purchases.add(data);
            if (_purchases != null && _purchases.isNotEmpty) {
              Preference.shared.setBool(Preference.IS_PURCHASED, true);
              MyApp.purchaseStreamController.add(_purchases[0]);
            } else {
              Preference.shared.setBool(Preference.IS_PURCHASED, false);
            }
            print("Already Purchased =======>" +
                receiptData.latestReceiptInfo![0].toJson().toString());

            return;
          } else {
            Preference.shared.setBool(Preference.IS_PURCHASED, false);
          }

          if (data.pendingCompletePurchase) {
            await _connection.completePurchase(data);
          }
        }
      } else {
        Preference.shared.setBool(Preference.IS_PURCHASED, false);
      }
    } on DioError catch (ex) {
      try {
        var res = ex.response!.data;
        Preference.shared.setBool(Preference.IS_PURCHASED, false);
        Debug.printLog("Verify Receipt =======> ${ex.response!.data}");
      } catch (e) {
        Preference.shared.setBool(Preference.IS_PURCHASED, false);
        print(e);
      }
    }
  }

  /* PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID, orElse: () => null);
  }*/

  Map<String, PurchaseDetails> getPurchases() {
    Map<String, PurchaseDetails> purchases =
        Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _connection.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    return purchases;
  }

  finishTransaction() async {
    final transactions = await SKPaymentQueueWrapper().transactions();

    for (final transaction in transactions) {
      try {
        if (transaction.transactionState !=
            SKPaymentTransactionStateWrapper.purchasing) {
          await SKPaymentQueueWrapper().finishTransaction(transaction);
          await SKPaymentQueueWrapper()
              .finishTransaction(transaction.originalTransaction!);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  buySubscription(ProductDetails productDetails,
      Map<String, PurchaseDetails> purchases) async {
    if (Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();

      print(transactions);

      for (final transaction in transactions) {
        try {
          if (transaction.transactionState !=
              SKPaymentTransactionStateWrapper.purchasing) {
            await SKPaymentQueueWrapper().finishTransaction(transaction);
            await SKPaymentQueueWrapper()
                .finishTransaction(transaction.originalTransaction!);
          }
        } catch (e) {
          print(e);
        }
      }

      final _transactions = await SKPaymentQueueWrapper().transactions();

      print(_transactions);

      for (final transaction in _transactions) {
        try {
          if (transaction.transactionState !=
              SKPaymentTransactionStateWrapper.purchasing) {
            await SKPaymentQueueWrapper().finishTransaction(transaction);
            await SKPaymentQueueWrapper()
                .finishTransaction(transaction.originalTransaction!);
          }
        } catch (e) {
          print(e);
        }
      }
    }

    /* var userData = Utils.getUserData();
    var applicationUserName = (Platform.isAndroid)?base64Url.encode(utf8.encode(userData.email)):sha256.convert(utf8.encode(userData.email)).toString();*/

    PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      final oldSubscription = _getOldSubscription(productDetails, purchases);

      purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: null,
          changeSubscriptionParam: (oldSubscription != null)
              ? ChangeSubscriptionParam(
                  oldPurchaseDetails: oldSubscription,
                  prorationMode: ProrationMode.immediateWithTimeProration,
                )
              : null);
    } else {
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
      );
    }

    _connection
        .buyNonConsumable(purchaseParam: purchaseParam)
        .catchError((error) async {
      if (error is PlatformException &&
          error.code == "storekit_duplicate_product_object") {
        // await InAppPurchase.instance.completePurchase(purchases[productDetails.id]);
      }
      handleError(error);
      print(error);
    });
  }

  Future<void> clearTransactions() async {
    if (Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (final transaction in transactions) {
        try {
          if (transaction.transactionState !=
              SKPaymentTransactionStateWrapper.purchasing) {
            await SKPaymentQueueWrapper().finishTransaction(transaction);
            await SKPaymentQueueWrapper()
                .finishTransaction(transaction.originalTransaction!);
          }
          //await SKPaymentQueueWrapper().finishTransaction(transaction);
        } catch (e) {
          print(e);
        }
      }
    }
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    _purchases.add(purchaseDetails);
    _purchasePending = false;
    MyApp.purchaseStreamController.add(purchaseDetails);
    _iapCallback!.onSuccessPurchase(purchaseDetails);
  }

  void handleError(dynamic error) {
    _purchasePending = false;
    _iapCallback!.onBillingError(error);
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _iapCallback!.onPending(purchaseDetails);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          getPastPurchases(purchaseDetailsList);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _connection.completePurchase(purchaseDetails);
        }

        finishTransaction();
      }
    });
    await clearTransactions();
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    GooglePlayPurchaseDetails? oldSubscription;
    if (productDetails.id == yearlySubscriptionId &&
        purchases[monthlySubscriptionId] != null) {
      oldSubscription =
          purchases[yearlySubscriptionId] as GooglePlayPurchaseDetails;
    } else {
      if (productDetails.id == monthlySubscriptionId &&
          purchases[yearlySubscriptionId] != null) {
        oldSubscription =
            purchases[monthlySubscriptionId] as GooglePlayPurchaseDetails;
      }
    }
    return oldSubscription;
  }
}