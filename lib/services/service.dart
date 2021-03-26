import 'package:CEPmobile/services/documentService.dart';
import 'package:flutter/material.dart';

import 'package:CEPmobile/httpProvider/HttpProviders.dart';
import 'package:CEPmobile/services/commonService.dart';
import 'package:CEPmobile/services/sharePreference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services {
  final SharedPreferences sharedPrefs;
  final HttpBase httpBase;
  final CommonService commonService;
  final SharePreferenceService sharePreferenceService;
  final DocumentService documentService;
  //final GoogleMapService googleMapService;

  Services(this.sharedPrefs, this.httpBase, this.commonService,
      this.sharePreferenceService,  this.documentService);

  static Future<Services> initialize() async {
    // GET instance here and inject
    final sharedPrefs = await SharedPreferences.getInstance();
    final sharePreferenceService = new SharePreferenceService(sharedPrefs);
    final httpBase = new HttpBase();
    final commonService = new CommonService(httpBase);
    final documentService = new DocumentService(httpBase);
   // final googleMapService = new GoogleMapService();

    await sharePreferenceService.getRememberUser();
    await sharePreferenceService.getServerInfo();
    await sharePreferenceService.getDriverProfile();

    return Services(sharedPrefs, httpBase, commonService,
        sharePreferenceService, documentService);
  }

  static Services of(BuildContext context) {
    final provider = context
        .ancestorInheritedElementForWidgetOfExactType(ServicesProvider)
        .widget as ServicesProvider;

    return provider.services;
  }
}

class ServicesProvider extends InheritedWidget {
  final Services services;

  ServicesProvider({Key key, this.services, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(ServicesProvider old) {
    if (services != old.services) {
      throw Exception('Services must be constant!');
    }
    return false;
  }
}
