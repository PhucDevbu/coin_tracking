
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/crypto.dart';
import '../providers/market_provider.dart';
import 'details_page.dart';

class Markets extends StatefulWidget {
  const Markets({Key? key}) : super(key: key);

  @override
  State<Markets> createState() => _MarketsState();
}

class _MarketsState extends State<Markets> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(
      builder: (context, marketProvider, child) {
        if (marketProvider.isLoading == true) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (marketProvider.markets.length > 0) {
            return RefreshIndicator(
              onRefresh: () async{
                await marketProvider.fetchData();
              },
              child: ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: marketProvider.markets.length,
                itemBuilder: (context, index) {
                  Crypto currentCrypto = marketProvider.markets[index];
                  return ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsPage(
                        id: currentCrypto.id!,
                      )));
                    },
                    contentPadding: EdgeInsets.all(0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:
                      NetworkImage(currentCrypto.image!),
                    ),
                    title: Text(currentCrypto.name! +
                        " #${currentCrypto.marketCapRank!}"),
                    subtitle: Text(currentCrypto.symbol!.toUpperCase()),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "\$" + currentCrypto.currentPrice!.toString(),
                          style: TextStyle(
                            color: Color(0xff0395eb),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Builder(builder: (context) {
                          double priceChange =
                          currentCrypto.priceChange24!;
                          double priceChangePercentage =
                          currentCrypto.priceChangePercentage24!;

                          if (priceChange < 0) {
                            return Text(
                              "-${priceChangePercentage.toStringAsFixed(2)} % (${priceChange.toStringAsFixed(4)})",
                              style: TextStyle(color: Colors.red),
                            );
                          } else {
                            return Text(
                              "+${priceChangePercentage.toStringAsFixed(2)} % (${priceChange.toStringAsFixed(4)})",
                              style: TextStyle(color: Colors.green),
                            );
                          }
                        })
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return Text("Data not found!");
          }
        }
      },
    );
  }
}
