import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/main_drawer.dart';
import '../views/bag.dart';
import '../providers/history.dart' as histProvider;
import '../providers/auth.dart';
import '../views/history.dart' as hist;

class TransactionHistory extends StatelessWidget {
  static const route = '/transactions';
  const TransactionHistory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context).userId;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [Bag()],
      ),
      drawer: const MainDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: const Text('My History',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
          ),
          Expanded(
            child: FutureBuilder(
                future:
                    Provider.of<histProvider.History>(context, listen: false)
                        .fetchOrdersOnline(int.parse(auth)),
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  } else {
                    if (dataSnapshot.data.toString().isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/history.png',
                              // width: 150,
                            ),
                            SizedBox(height: 3),
                            Text(
                              'No transaction found',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Only delivered orders are shown here',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Consumer<histProvider.History>(
                        builder: (ctx, history, child) =>
                            history.transactions.length < 1
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/history.png',
                                          // width: 150,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'No history yet',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Only delivered orders are shown here',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemBuilder: (ctx, i) => hist.History(
                                      history: history.transactions[i],
                                    ),
                                    itemCount: history.transactions.length,
                                  ),
                      );
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }
}
