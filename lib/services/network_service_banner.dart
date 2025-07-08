import 'package:http/http.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  Future<StreamedResponse> postMultipart({
    required String url,
    required Map<String, String> fields,
    required List<MultipartFile> files,
  }) async {
    var uri = Uri.parse(url);
    var request = MultipartRequest("POST", uri);
    request.fields.addAll(fields);
    request.files.addAll(files);
    return await request.send();
  }

  Future<StreamedResponse> putMultipart({
    required String url,
    required Map<String, String> fields,
    required List<MultipartFile> files,
  }) async {
    var uri = Uri.parse(url);
    var request = MultipartRequest("PUT", uri);
    request.fields.addAll(fields);
    request.files.addAll(files);
    return await request.send();
  }
}
