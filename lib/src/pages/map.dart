import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:markets_owner/src/models/market.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/map_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/route_argument.dart';

class MapWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MapWidget({Key key, this.routeArgument, this.parentScaffoldKey}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends StateMVC<MapWidget> {
  MapController _con;

  Market market;
  List<Marker> allMarkers = <Marker>[];
  _MapWidgetState() : super(MapController()) {
    _con = controller;
  }

  @override
  void initState() {
    market = widget.routeArgument?.param as Market;
    print(market.toMap());
    /*_con.currentOrder = widget.routeArgument?.param as Market;
    if (_con.currentOrder?.deliveryAddress?.latitude != null) {
      // user select a market
      _con.getOrderLocation();
      _con.getDirectionSteps();
    } else {
      _con.getCurrentLocation();
    }*/
    // _con.getOrderLocation();
    // _con.getDirectionSteps();
    setMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          market.name,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3,color: Theme.of(context).primaryColor)),
        ),
        actions: <Widget>[
          /*IconButton(
            icon: Icon(
              Icons.my_location,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () {
              _con.goCurrentLocation();
            },
          ),*/
        ],
      ),
      body: Stack(
        fit: StackFit.loose,
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          market.latitude == null
              ? CircularLoadingWidget(height: 0)
              : GoogleMap(
                  mapToolbarEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(market.latitude), double.parse(market.longitude)),
                    zoom: 4,
                  ),
                  markers: Set.from(allMarkers),
                  onMapCreated: (GoogleMapController controller) {
                    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(double.parse(market.latitude), double.parse(market.longitude)),
                      zoom: 14.4746,
                    )));
                  },
                  /*onCameraMove: (CameraPosition cameraPosition) {
                    cameraPosition = CameraPosition(
                      target: LatLng(double.parse(market.latitude), double.parse(market.longitude)),
                      zoom: 4,
                    );
                  },*/
                ),
          /*Container(
            height: 95,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.9),
              boxShadow: [
                BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _con.currentOrder?.orderStatus?.id == '5'
                    ? Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.withOpacity(0.2)),
                        child: Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 32,
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor.withOpacity(0.1)),
                        child: Icon(
                          Icons.update,
                          color: Theme.of(context).hintColor.withOpacity(0.8),
                          size: 30,
                        ),
                      ),
                SizedBox(width: 15),
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              S.of(context).order_id + "#${_con.currentOrder.id}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              _con.currentOrder.payment?.method ?? S.of(context).cash_on_delivery,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd HH:mm').format(_con.currentOrder.dateTime),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Helper.getPrice(Helper.getTotalOrdersPrice(_con.currentOrder), context, style: Theme.of(context).textTheme.headline4),
                          Text(
                            S.of(context).items + ':' + _con.currentOrder.productOrders?.length?.toString() ?? 0,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  void setMarker() async {
    final Uint8List markerIcon = await Helper.getBytesFromAsset('assets/img/marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(market.id),
        icon: BitmapDescriptor.fromBytes(markerIcon),
//        onTap: () {
//          //print(res.name);
//        },
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(
            title: market.address,
            snippet: '',
            onTap: () {
              print(market.address);
            }),
        position: LatLng(double.parse(market.latitude), double.parse(market.longitude)));
    allMarkers.add(marker);
    setState(() { });
  }
}
