import 'package:crypto_bloc/models/coin_model.dart';

abstract class BaseCryptoRepositroy {
  Future<List<Coin>> getTopCoins({int page});
  void dispose();
}
