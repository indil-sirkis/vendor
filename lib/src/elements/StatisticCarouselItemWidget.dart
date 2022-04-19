import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:markets_owner/src/models/route_argument.dart';

import '../helpers/helper.dart';
import '../models/statistic.dart';

class StatisticCarouselItemWidget extends StatelessWidget {
  final double marginLeft;
  final Statistic statistic;

  StatisticCarouselItemWidget({Key key, this.marginLeft, this.statistic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("VVV:::${statistic.description}");
    return InkWell(
      onTap: (){
        if(statistic.description == "total_orders"){
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
        }else if(statistic.description == "total_markets"){
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
        }else if(statistic.description == "total_products"){
          Navigator.of(context).pushNamed('/Category', arguments: RouteArgument());
        }
      },
      child: Container(
        margin: EdgeInsetsDirectional.only(start: this.marginLeft, end: 20, top: 25, bottom: 25),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 2)),
          ],
        ),
        width: 110,
        height: 130,
        child: Column(
          children: [
            if (statistic.description == "total_earning")
              Helper.getPrice(double.tryParse(statistic.value), context,
                  style: Theme.of(context).textTheme.headline2.merge(
                        TextStyle(height: 1),
                      ))
            else
              Text(
                statistic.value,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2.merge(TextStyle(height: 1)),
              ),
            SizedBox(height: 5),
            Text(
              Helper.of(context).trans(statistic.description,""),
              textAlign: TextAlign.center,
              maxLines: 1,
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(height: 5),
            statistic.description != "total_products" ?Image.asset(statistic.description == "total_markets" ?"assets/img/my_stores.png":statistic.description == "total_orders" ?"assets/img/my_orders.png":"assets/img/total_earning.png",height: 35,width: 35):Image.asset("assets/img/total_products.png",color:Colors.black,height: 35,width: 35,),
          ],
        ),
      ),
    );
  }
}
