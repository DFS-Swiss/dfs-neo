import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/details/details_about.dart';
import 'package:neo/pages/details/details_development_section.dart';
import 'package:neo/pages/details/details_investment_section.dart';
import 'package:neo/pages/details/details_open_orders_section.dart';
import 'package:neo/pages/details/details_public_sentiment.dart';
import 'package:neo/pages/portfolio/exclusive_recently_closed_section.dart';
import 'package:neo/utils/display_popup.dart';
import '../../hooks/use_stockdata_info.dart';
import '../../service_locator.dart';
import '../../services/analytics_service.dart';
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

    useEffect(() {
      locator<AnalyticsService>()
          .trackEvent("display:detail", eventProperties: {"symbol": token});
      return;
    }, ["_"]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          AppBarActionButton(
            icon: Icons.favorite_outline,
            callback: () {
              displayPopup(context);
            },
          )
        ],
        title: Text(title),
      ),
      body: ListView(
        addAutomaticKeepAlives: true,
        cacheExtent: 1000,
        children: [
          DetailsDevelopmentSection(token: token),
          SizedBox(
            height: 12,
          ),
          DetailsInvestmentsSection(
            token: token,
            key: UniqueKey(),
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
          ExclusiveRecentlyClosedSection(
            exclusiveSymbol: token,
            key: UniqueKey(),
          ),
          DetailsAboutSection(symbol: title, description: description),
          SizedBox(
            height: 12,
          ),
          DetailsPublicSentiment(sentiment: publicSentimentIndex),
          SizedBox(
            width: 25,
          ),
        ],
      ),
    );
  }
}
