import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<dynamic> getCoinData(String coin, String currency) async {
    try {
      http.Response response = await http.get(
          'https://apiv2.bitcoinaverage.com/indices/global/ticker/$coin$currency');

      print(convert.jsonDecode(response.body));
      return convert.jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
  }
}
