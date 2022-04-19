import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/category_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ProductGridItemWidget.dart';
import '../elements/ProductListItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

class CategoryWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CategoryWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends StateMVC<CategoryWidget> {
  // TODO add layout in configuration file
  String layout = 'grid';

  CategoryController _con;

  _CategoryWidgetState() : super(CategoryController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForProductsByCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).myProducts,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 0,color: Theme.of(context).primaryColor)),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                this.layout = 'list';
              });
            },
            icon: Icon(
              Icons.format_list_bulleted,
              color: this.layout == 'list' ? Theme.of(context).accentColor : Theme.of(context).focusColor,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                this.layout = 'grid';
              });
            },
            icon: Icon(
              Icons.apps,
              color: this.layout == 'grid' ? Theme.of(context).accentColor : Theme.of(context).focusColor,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshCategory,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _con.products.isEmpty
                  ? CircularLoadingWidget(height: 500)
                  : Offstage(
                      offstage: this.layout != 'list',
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.products.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return ProductListItemWidget(
                            heroTag: 'favorites_list',
                            product: _con.products.elementAt(index),
                          );
                        },
                      ),
                    ),
              _con.products.isEmpty
                  ? CircularLoadingWidget(height: 500)
                  : Offstage(
                      offstage: this.layout != 'grid',
                      child: GridView.count(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
                        // Generate 100 widgets that display their index in the List.
                        children: List.generate(_con.products.length, (index) {
                          return ProductGridItemWidget(
                              heroTag: 'category_grid',
                              product: _con.products.elementAt(index));
                        }),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
