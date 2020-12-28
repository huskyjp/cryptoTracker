import 'dart:convert';

import 'package:crypto_bloc/models/coin_model.dart';
import 'package:crypto_bloc/repositories/base_crypto_repository.dart';
import 'package:http/http.dart' as http;

class CryptoRepository extends BaseCryptoRepositroy {
  // endpoint
  static const String _baseUrl = 'https://min-api.cryptocompare.com';
  // number of coins return from API call per time
  static const int _perPage = 20;

  // client
  final http.Client _httpClient;

  // constructor: if client exists or not
  CryptoRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<List<Coin>> getTopCoins({int page}) async {
    // empty list of coins
    List<Coin> coins = [];
    String requestUrl =
        '$_baseUrl/data/top/totalvolfull?limit=$_perPage&tsym=USD&page=$page';

    try {
      final response = await _httpClient.get(requestUrl);
      if (response.statusCode == 200) {
        // response.body is string so decode it into json: <String, dynanic>
        Map<String, dynamic> data = json.decode(response.body);
        // convert each coinList json to Coin model
        List<dynamic> coinList = data['Data'];
        coinList.forEach((json) => {coins.add(Coin.fromJson(json))});
      }
      return coins;
    } catch (err) {
      throw (err);
    }
  }

  @override
  void dispose() {
    _httpClient.close();
  }
}
