import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:homeworkout_flutter/inapppurchase/IAPCallback.dart';
import 'package:homeworkout_flutter/inapppurchase/IAPReceiptData.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import '../main.dart';

class InAppPurchaseHelper {
  static final InAppPurchaseHelper _inAppPurchaseHelper =
  InAppPurchaseHelper._internal();

  InAppPurchaseHelper._internal();

  factory InAppPurchaseHelper() {
    return _inAppPurchaseHelper;
  }

  static const String monthlySubscriptionId = 'sub_month';
  static const String yearlySubscriptionId = 'sub_year';

  static const List<String> _kProductIds = <String>[
    monthlySubscriptionId,
    yearlySubscriptionId,
  ];

  final InAppPurchase _connection = InAppPurchase.instance;

  // ignore: cancel_subscriptions
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  IAPCallback? _iapCallback;

  initialize() {
    if (Platform.isAndroid) {
      // ignore: deprecated_member_use
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    }
  }


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
      if (purchaseDetailsList != [] && purchaseDetailsList.isNotEmpty) {
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
    });
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      _products = [];
      _purchases = [];
      return;
    }

    ProductDetailsResponse productDetailResponse =
    await _connection.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      _products = productDetailResponse.productDetails;
      _purchases = [];
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      _products = productDetailResponse.productDetails;
      _purchases = [];
      return;
    } else {
      _products = productDetailResponse.productDetails;
      _purchases = [];
    }

    await _connection.restorePurchases();
  }

  Future<void> getPastPurchases(List<PurchaseDetails> verifiedPurchases) async {
    verifiedPurchases
        .sort((a, b) => a.transactionDate!.compareTo(b.transactionDate!));

    if (Platform.isIOS) {
      if (verifiedPurchases.isNotEmpty)
        await _verifyReceipts(verifiedPurchases);
      else {
        Debug.printLog("You have not Purchased :::::::::::::::::::=>");
        Preference.shared.setBool(Preference.IS_PURCHASED, false);
      }
    } else {
      if (verifiedPurchases.length > 0) {
        if (verifiedPurchases != [] && verifiedPurchases.isNotEmpty) {
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


      var receiptData = IapReceiptData.fromJson(profile);

      receiptData.latestReceiptInfo!
          .sort((a, b) => b.expiresDateMs!.compareTo(a.expiresDateMs!));
      if (int.parse(receiptData.latestReceiptInfo![0].expiresDateMs!) >
          DateTime
              .now()
              .millisecondsSinceEpoch) {
        for (PurchaseDetails data in verifiedPurchases) {
          if (data.productID == receiptData.latestReceiptInfo![0].productId) {
            _purchases.clear();
            _purchases.add(data);
            if (_purchases != [] && _purchases.isNotEmpty) {
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
        Preference.shared.setBool(Preference.IS_PURCHASED, false);
        Debug.printLog("Verify Receipt =======> ${ex.response!.data}");
      } catch (e) {
        Preference.shared.setBool(Preference.IS_PURCHASED, false);
        print(e);
      }
    }
  }


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


    PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      final oldSubscription = _getOldSubscription(productDetails, purchases);

      purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: null,
          changeSubscriptionParam: (oldSubscription != null)
              ? ChangeSubscriptionParam(
            oldPurchaseDetails: oldSubscription,

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
        } catch (e) {
          print(e);
        }
      }
    }
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    _purchases.add(purchaseDetails);
    MyApp.purchaseStreamController.add(purchaseDetails);
    _iapCallback!.onSuccessPurchase(purchaseDetails);
  }

  void handleError(dynamic error) {
    _iapCallback!.onBillingError(error);
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {

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

  GooglePlayPurchaseDetails? _getOldSubscription(ProductDetails productDetails,
      Map<String, PurchaseDetails> purchases) {
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
