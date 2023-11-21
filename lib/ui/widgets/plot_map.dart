import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colored_progress_indicators/flutter_colored_progress_indicators.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:flutter_store_catalog/core/models/view/address_data.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';

class PlotMap extends StatefulWidget {
  final AddressData addressData;

  PlotMap({Key key, this.addressData}) : super(key: key);

  @override
  _PlotMapState createState() => _PlotMapState();
}

class _PlotMapState extends State<PlotMap> {
  final AddressData defaultAddressData = AddressData(
    lat: 13.853462245886677,
    lon: 100.5437802121761,
  ); // homepro headquarter - for case cannot get current location

  final _mapKey = GlobalKey<GoogleMapStateBase>();
  
  List<Marker> allMarkers = [];
  Future<AddressData> futureAddressData;

  @override
  void initState() {
    super.initState();
    if (widget.addressData != null && widget.addressData.lon != null && widget.addressData.lat != null) {
      allMarkers.add(Marker(GeoCoord(widget.addressData.lat, widget.addressData.lon)));
    }
    futureAddressData = getInitAddressData();
  }

  Future<AddressData> getInitAddressData() async {
    if (widget.addressData != null && widget.addressData.lon != null && widget.addressData.lat != null) {
      return widget.addressData;
    }
    Position position = await Geolocator.getCurrentPosition();
    return AddressData(
      lat: position.latitude,
      lon: position.longitude,
    );
  }

  void addMarker(GeoCoord coord) {
    // print('addMarker coord : $coord');
    setState(() {
      allMarkers.clear();
      GoogleMap.of(_mapKey).clearMarkers();

      Marker marker = Marker(coord);
      allMarkers.add(marker);
      GoogleMap.of(_mapKey).addMarker(marker);
    });
  }

  void clearMarker() {
    setState(() {
      allMarkers.clear();
      GoogleMap.of(_mapKey).clearMarkers();
    });
  }

  void onBack() {
    Navigator.pop(context);
  }

  void onConfirm() {
    // print('confirm ${allMarkers.first.position}');
    Navigator.pop(
      context,
      AddressData(
        lat: allMarkers.first.position.latitude,
        lon: allMarkers.first.position.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<AddressData>(
        future: futureAddressData,
        builder: (context, snapshot) {

          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: Container(
                height: 64,
                width: 64,
                child: ColoredCircularProgressIndicator(strokeWidth: 8),
              ),
            );
          }

          AddressData addressData = snapshot.hasError ? defaultAddressData : snapshot.data;

          return Stack(
            children: [
              Positioned.fill(
                child: GoogleMap(
                  key: _mapKey,
                  markers: allMarkers.toSet(),
                  initialZoom: 12,
                  initialPosition: GeoCoord(addressData.lat, addressData.lon),
                  mapType: MapType.roadmap,
                  interactive: true,
                  onTap: (GeoCoord coord) {
                    addMarker(coord);
                  },
                  mobilePreferences: const MobileMapPreferences(
                    zoomControlsEnabled: true,
                  ),
                  webPreferences: WebMapPreferences(
                    zoomControl: true,
                  ),
                ),
              ),
              Positioned(
                right: 64,
                bottom: 24,
                child: buildButtons(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildButtons() {
    return PointerInterceptor(
      child: Row(
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              elevation: 4,
              backgroundColor: colorAccent,
              primary: Colors.white,
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: onBack,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                'text.back'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
          SizedBox(width: 16),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              elevation: 4,
              backgroundColor: allMarkers.isEmpty ? colorGrey1 : colorBlue7,
              primary: Colors.white,
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: allMarkers.isEmpty ? null : onConfirm,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                'common.button_confirm'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
