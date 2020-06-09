import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:project_runway/features/vision_boards/data/repositories/photos_state.dart';

import '../models/retreived_photo_model.dart';

class ImageProvider {
  //Singleton
  static final ImageProvider _imageProvider = ImageProvider._private();
  ImageProvider._private();
  factory ImageProvider() => _imageProvider;

  Client _client = Client();
  static const String _apiKey = "xZ04LEcFWvdu-8GiAyxt5LikjEgdBi1mLndVQEt-LAk";
  static const String _baseUrl = "https://api.unsplash.com";

  //Get list of images based on the query
  Future<PhotosState> getImagesByName(String query) async {
    Response response;
    if (_apiKey == 'api-key') {
      return PhotosState<String>.error("Please enter your API Key");
    }
    response = await _client
        .get("$_baseUrl/search/photos?page=1&query=$query&client_id=$_apiKey");
    if (response.statusCode == 200)
      return PhotosState<Photos>.success(
          Photos.fromJson(json.decode(response.body)));
    else
      return PhotosState<String>.error(response.statusCode.toString());
  }

  Future<Uint8List> getImageFromUrl(String url) async {
    var response = await _client.get(url);
    Uint8List bytes = response.bodyBytes;
    return bytes;
  }
}
