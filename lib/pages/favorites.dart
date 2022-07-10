import 'package:coin_tracking/providers/market_provider.dart';
import 'package:coin_tracking/widgets/crypto_list_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/crypto.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(builder:  (context,marketProvider,child){

      List<Crypto> favorites = marketProvider.markets.where((element) => element.isFavorite == true).toList();
      if(favorites.length>0){
        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context,index){
            Crypto currentCrypto = favorites[index];
            return CryptoListTitle(currentCrypto:  currentCrypto);
          },
        );
      }else{
        return Center(
          child: Text("No favorites yet",style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),),
        );
      }


    });
  }
}
