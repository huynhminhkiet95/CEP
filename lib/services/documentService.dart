import 'dart:io';

import 'package:CEPmobile/httpProvider/HttpProviders.dart';
import 'package:CEPmobile/services/service_constants.dart';
import 'package:http/http.dart';

class DocumentService {
  final HttpBase _httpBase;
  DocumentService(this._httpBase);

  Future<Response> getDocuments(dynamic body) {
    String url = ServiceName.GetDocuments.toString();
    return _httpBase.httpPostToken(url, body);
  }

  Future<Response> deleteDocuments(dynamic body) {
    String url = ServiceName.DeleteDocument.toString();
    return _httpBase.httpPostToken(url, body);
  }

  Future<StreamedResponse> saveImage(File file, int itemId) {
    return _httpBase.httpPostOpenalpr(file, itemId);
  }
}
