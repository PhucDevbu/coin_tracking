import 'package:coin_tracking/models/API.dart';
import 'package:flutter/material.dart';

import '../models/crypto.dart';

class MarketProvider with ChangeNotifier {
  bool isLoading = true;
  List<Crypto> markets = [];

  void fetchData() async {
    List<dynamic> _markets = await API.getMarkets();

    List<Crypto> temp = [];
    for (var market in _markets) {
      Crypto newCrypto = Crypto.fromJSON(market);
      temp.add(newCrypto);
    }

    markets = temp;
    isLoading = false;
    notifyListeners();
  }
}
