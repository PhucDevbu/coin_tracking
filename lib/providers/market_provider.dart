import 'dart:async';

import 'package:coin_tracking/models/API.dart';
import 'package:coin_tracking/models/local_storage.dart';
import 'package:flutter/material.dart';

import '../models/crypto.dart';

class MarketProvider with ChangeNotifier {
  bool isLoading = true;
  List<Crypto> markets = [];

  MarketProvider(){
    fetchData();
  }
  Future<void> fetchData() async {
    List<dynamic> _markets = await API.getMarkets();
    List<String> favorites = await LocalStorage.fetchFavorites();

    List<Crypto> temp = [];
    for (var market in _markets) {
      Crypto newCrypto = Crypto.fromJSON(market);

      if(favorites.contains(newCrypto.id)){
        newCrypto.isFavorite = true;
      }

      temp.add(newCrypto);
    }

    markets = temp;
    isLoading = false;
    notifyListeners();

  }

  Crypto fetchCryptoById(String id){
    Crypto crypto = markets.where((element) => element.id==id).toList()[0];
    return crypto;
  }

  void addFavorite(Crypto crypto) async{
    int indexOfCrypto = markets.indexOf(crypto);
    markets[indexOfCrypto].isFavorite = true;
    await LocalStorage.addFavorite(crypto.id!);
    notifyListeners();
  }

  void removeFavorite(Crypto crypto) async{
    int indexOfCrypto = markets.indexOf(crypto);
    markets[indexOfCrypto].isFavorite = false;
    await LocalStorage.removeFavorite(crypto.id!);
    notifyListeners();
  }
}
