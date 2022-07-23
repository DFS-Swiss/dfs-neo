import 'package:flutter/material.dart';

import '../../widgets/cards/recently_closed_order_card.dart';

class RecentlyClosedOrders extends StatelessWidget {
  const RecentlyClosedOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          RecentlyClosedOrderCard(),
          SizedBox(height: 16),
          RecentlyClosedOrderCard(),
          SizedBox(height: 16),
          RecentlyClosedOrderCard(),
        ],
      ),
    );
  }
}
