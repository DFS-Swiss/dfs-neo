import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/details/details_about.dart';
import 'package:neo/pages/details/details_development_section.dart';
import 'package:neo/pages/details/details_investment_section.dart';
import 'package:neo/pages/details/details_open_orders_section.dart';
import 'package:neo/pages/details/details_public_sentiment.dart';
import '../../hooks/use_stockdata_info.dart';
import '../../widgets/appbaractionbutton_widget.dart';

class DetailsPage extends HookWidget {
  final String token;

  // Fetch Data on this screen, caching will make it faster anyways

  const DetailsPage({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final symbolInfo = useSymbolInfo(token);


    var title = "";
    var description = "";
    var image = "";
    var publicSentimentIndex = 0;

    if (symbolInfo.data != null) {
      title = symbolInfo.data!.symbol;
      description = symbolInfo.data!.description;
      image = symbolInfo.data!.imageUrl;
      publicSentimentIndex = symbolInfo.data!.publicSentimentIndex;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          AppBarActionButton(
            icon: Icons.favorite_outline,
            callback: () {
              print("Tapped favorites");
            },
          )
        ],
        title: Text(title),
      ),
      body: ListView(
        children: [
          DetailsDevelopmentSection(token: token),
          DetailsInvestmentsSection(
            token: token,
            symbol: title,
          ),
          SizedBox(
            height: 12,
          ),
          DetailsOpenOrdersSection(
            image: image,
          ),
          SizedBox(
            height: 12,
          ),
          DetailsAboutSection(symbol: title, description: description),
          SizedBox(
            height: 12,
          ),
          DetailsPublicSentiment(sentiment: publicSentimentIndex),
        ],
      ),
    );
  }
}
