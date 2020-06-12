import 'dart:typed_data';

import 'package:project_runway/features/vision_boards/data/repositories/photos_state.dart';

import 'image_provider.dart';

class PhotosRepository {
  static final PhotosRepository _repository = PhotosRepository._private();
  PhotosRepository._private();
  factory PhotosRepository() => _repository;

  ImageProvider _imageProvider = ImageProvider();

  Future<PhotosState> imageData(query) => _imageProvider.getImagesByName(query);

  Future<Uint8List> getImageToShare(String url) {
    return _imageProvider.getImageFromUrl(url);
  }
}
