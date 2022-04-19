import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/product_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/helper.dart';
import '../models/media.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

// ignore: must_be_immutable
class ProductWidget extends StatefulWidget {
  RouteArgument routeArgument;

  ProductWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _ProductWidgetState createState() {
    return _ProductWidgetState();
  }
}

class _ProductWidgetState extends StateMVC<ProductWidget> {
  ProductController _con;

  _ProductWidgetState() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForProduct(productId: widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: _con.product == null || _con.product?.image == null || _con.product?.images == null
          ? CircularLoadingWidget(height: 500)
          : RefreshIndicator(
              onRefresh: _con.refreshProduct,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 125),
                    padding: EdgeInsets.only(bottom: 15),
                    child: CustomScrollView(
                      primary: true,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        SliverAppBar(
                          backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                          expandedHeight: 270,
                          elevation: 0,
                          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.parallax,
                            background: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: <Widget>[
                                CarouselSlider(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 7),
                                    height: 300,
                                    viewportFraction: 1.0,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _con.current = index;
                                      });
                                    },
                                  ),
                                  items: _con.product.images.map((Media image) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return CachedNetworkImage(
                                          height: 300,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          imageUrl: image.url,
                                          placeholder: (context, url) => Image.asset(
                                            'assets/img/loading.gif',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 300,
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                                Container(
                                  //margin: EdgeInsets.symmetric(vertical: 22, horizontal: 42),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: _con.product.images.map((Media image) {
                                      return Container(
                                        width: 20.0,
                                        height: 5.0,
                                        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: _con.current == _con.product.images.indexOf(image)
                                                ? Theme.of(context).accentColor
                                                : Theme.of(context).primaryColor.withOpacity(0.4)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            child: Wrap(
                              runSpacing: 8,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _con.product?.name ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context).textTheme.headline3,
                                          ),
                                          Text(
                                            _con.product?.market?.name ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context).textTheme.bodyText2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Helper.getPrice(
                                            _con.product.price,
                                            context,
                                            style: Theme.of(context).textTheme.headline2,
                                          ),
                                          _con.product.discountPrice > 0
                                              ? Helper.getPrice(_con.product.discountPrice, context,
                                                  style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(decoration: TextDecoration.lineThrough)))
                                              : SizedBox(height: 0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                /*Row(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                        decoration: BoxDecoration(color: Theme.of(context).focusColor, borderRadius: BorderRadius.circular(24)),
                                        child: Text(
                                          _con.product.capacity + " " + _con.product.unit,
                                          style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                                        )),
                                    SizedBox(width: 5),
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                        decoration: BoxDecoration(color: Theme.of(context).focusColor, borderRadius: BorderRadius.circular(24)),
                                        child: Text(
                                          _con.product.packageItemsCount + " " + S.of(context).items,
                                          style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                                        )),
                                  ],
                                ),*/
                                Divider(height: 20),
                                Text(Helper.skipHtml(_con.product.description)),
                                /*ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                  leading: Icon(
                                    Icons.recent_actors_outlined,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  title: Text(
                                    S.of(context).reviews,
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                                ReviewsListWidget(
                                  reviewsList: _con.product.productReviews,
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
