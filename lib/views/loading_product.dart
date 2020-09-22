import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingProducts extends StatelessWidget {
  const LoadingProducts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (ctx, constraint) => Card(
              color: Colors.black45,
              margin: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Container(
                  width: constraint.maxWidth,
                  height: constraint.maxHeight,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            width: 40,
                            height: constraint.maxHeight * 0.12,
                            child: Card(),
                          ),
                        ],
                      ),
                      SizedBox(height: constraint.maxHeight * 0.01),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: double.infinity,
                        height: constraint.maxHeight * 0.5,
                        child: Card(),
                      ),
                      SizedBox(
                        height: constraint.maxHeight * 0.01,
                      ),
                      Container(
                        width: double.infinity,
                        height: constraint.maxHeight * 0.06,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: Card(),
                      ),
                      SizedBox(height: constraint.maxHeight * 0.01),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: double.infinity,
                        height: constraint.maxHeight * 0.1,
                        child: Card(),
                      ),
                      SizedBox(height: constraint.maxHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: 40,
                            height: constraint.maxHeight * 0.08,
                            child: Card(),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: 60,
                            height: constraint.maxHeight * 0.08,
                            child: Card(),
                          ),
                        ],
                      ),
                      SizedBox(height: constraint.maxHeight * 0.01),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
