import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  List<DropdownMenuItem> getCurrencies() {
    List<DropdownMenuItem<String>> result = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      result.add(newItem);
    }
    return result;
  }

  List<Widget> getPickerItems() {
    List<Widget> result = [];
    for (int i = 0; i < currenciesList.length; i++) {
      var currency = currenciesList[i];
      var newItem = Text(currency);
      result.add(newItem);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pickerItems = getPickerItems();

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
                  '1 BTC = ? USD',
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
            child: CupertinoPicker(
              backgroundColor: Colors.lightBlue,
              itemExtent: 32.0,
              onSelectedItemChanged: (index) {
                print('selected: $index - ${pickerItems[index]}');
              },
              children: pickerItems,
            ),
          ),
        ],
      ),
    );
  }
}

//DropdownButton<String>(
//icon: Icon(Icons.monetization_on),
//value: selectedCurrency,
//items: getCurrencies(),
//onChanged: (val) {
//setState(() {
//selectedCurrency = val;
//});
//},
//),
