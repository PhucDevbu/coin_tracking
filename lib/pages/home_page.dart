import 'package:coin_tracking/models/crypto.dart';
import 'package:coin_tracking/providers/market_provider.dart';
import 'package:coin_tracking/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcomeback",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Crypto Today",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                    icon: (themeProvider.themeMode == ThemeMode.light) ?Icon(Icons.dark_mode):Icon(Icons.light_mode),
                    padding: EdgeInsets.all(0),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(child: Consumer<MarketProvider>(
                builder: (context, marketProvider, child) {
                  if (marketProvider.isLoading == true) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (marketProvider.markets.length > 0) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: marketProvider.markets.length,
                        itemBuilder: (context, index) {
                          Crypto currentCrypto = marketProvider.markets[index];
                          return ListTile(
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
                      );
                    } else {
                      return Text("Data not found!");
                    }
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
