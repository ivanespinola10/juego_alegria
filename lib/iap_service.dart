import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IAPService extends ChangeNotifier {
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  
  bool isAvailable = false;
  List<ProductDetails> products = [];
  bool isPremium = false;

  final String _premiumProductId = 'premium_hub_unlock';

  Future<void> init() async {
    isAvailable = await _iap.isAvailable();
    if (isAvailable) {
      await _loadProducts();
      final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        _subscription?.cancel();
      }, onError: (error) {
        debugPrint("Error en stream de compras: $error");
      });
      await _checkLocalPremiumStatus();
    }
  }

  Future<void> _loadProducts() async {
    Set<String> kIds = <String>{_premiumProductId};
    final ProductDetailsResponse response = await _iap.queryProductDetails(kIds);
    if (response.notFoundIDs.isEmpty) {
      products = response.productDetails;
      notifyListeners();
    }
  }

  /// Lectura ligera del estado premium desde SharedPreferences.
  /// Se puede llamar sin inicializar el IAP completo.
  static Future<bool> checkSavedPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isPremium') ?? false;
  }

  Future<void> _checkLocalPremiumStatus() async {
    isPremium = await checkSavedPremium();
    notifyListeners();
  }

  Future<void> _setPremiumStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', value);
    isPremium = value;
    notifyListeners();
  }

  void buyPremium() {
    if (products.isNotEmpty) {
      final ProductDetails productDetails = products.first;
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      debugPrint("No hay productos disponibles para comprar. Simular para pruebas...");
      // Si estamos en entorno de prueba sin tienda, forzamos el premium. (Solo para desarrollo)
      _setPremiumStatus(true);
    }
  }

  void restorePurchases() {
    _iap.restorePurchases();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // En proceso
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint("Error en la compra: ${purchaseDetails.error}");
        } else if (purchaseDetails.status == PurchaseStatus.purchased || 
                   purchaseDetails.status == PurchaseStatus.restored) {
          _setPremiumStatus(true);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
