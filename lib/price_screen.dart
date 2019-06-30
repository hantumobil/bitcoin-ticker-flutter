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
          coinRate = 0.0;
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
    var data = await CoinData().getCoinData(currency);
    setState(() {
      coinRate = data['last'];
      print('finish getting $currency coin data... $coinRate');
    });
  }

  @override
  void initState() {
    super.initState();
    updateCoinRate('USD');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
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
                  '1 BTC = ${coinRate == 0.0 ? "..." : coinRate.toInt()} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
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
