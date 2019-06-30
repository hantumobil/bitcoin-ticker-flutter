import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  double coinRate = 0.0;
  Map rates = {};

  void resetRates() {
    rates.forEach((k, v) {
      rates[k] = 0.0;
    });
  }

  void getInitialRates() {
    for (String coin in cryptoList) {
      rates[coin] = 0.0;
    }
  }

  List<Coin> coins() {
    List<Coin> result = [];
    for (String _coin in cryptoList) {
      var newCoin = Coin(
        coin: _coin,
        selectedCurrency: selectedCurrency,
        coinRate: rates[_coin],
      );
      result.add(newCoin);
    }
    return result;
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> menuItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      menuItems.add(newItem);
    }

    return DropdownButton<String>(
      icon: Icon(Icons.monetization_on),
      value: selectedCurrency,
      items: menuItems,
      onChanged: (val) {
        setState(() {
          coinRate = 0.0;
          selectedCurrency = val;
          updateCoinRate(val);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      var currency = currenciesList[i];
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        print('selected: $index - ${pickerItems[index]}');
        setState(() {
          resetRates();
          selectedCurrency = currenciesList[index];
          updateCoinRate(currenciesList[index]);
        });
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return androidDropdown();
    } else {
      return null;
    }
  }

  Future<dynamic> updateCoinRate(currency) async {
    print('getting coin data...');
    Map data = {};
    for (String coin in cryptoList) {
      data[coin] = await CoinData().getCoinData(coin, currency);
    }
    setState(() {
      for (String coin in cryptoList) {
        rates[coin] = data[coin]['last'];
      }
      print('finish getting $currency coin data... $rates');
    });
  }

  @override
  void initState() {
    super.initState();
    getInitialRates();
    updateCoinRate('USD');
  }

  @override
  Widget build(BuildContext context) {
    print('rates: $rates');
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: coins()),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class Coin extends StatelessWidget {
  const Coin({
    Key key,
    @required this.coin,
    @required this.coinRate,
    @required this.selectedCurrency,
  }) : super(key: key);

  final String coin;
  final double coinRate;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coin = ${coinRate == 0.0 ? "..." : coinRate.toInt()} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
