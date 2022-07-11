import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/pages/details/details_development_section.dart';
import 'package:neo/pages/details/details_investment_section.dart';
import '../../hooks/use_stockdata.dart';
import '../../hooks/use_stockdata_info.dart';
import '../../types/stockdata_interval_enum.dart';
import '../../widgets/appbaractionbutton_widget.dart';

class DetailsPage extends HookWidget {
  final String token;

  // Fetch Data on this screen, caching will make it faster anyways

  const DetailsPage({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chartData = useState<List<FlSpot>>([]);
    final stockData = useStockdata(token, StockdataInterval.twentyFourHours);
    final symbolInfo = useSymbolInfo(token);

    useEffect(() {
      if (stockData.loading == false) {
        chartData.value = stockData.data!
            .map((e) =>
                FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.price))
            .toList();
      }

      return;
    }, ["_", stockData.loading]);

    var title = "";
    if (symbolInfo.data != null) {
      title = symbolInfo.data!.symbol;
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
          DetailsInvestmentsSection(token: token)
        ],
      ),
    );
  }
}
