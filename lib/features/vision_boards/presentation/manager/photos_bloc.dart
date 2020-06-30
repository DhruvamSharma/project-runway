import 'dart:async';

import 'package:project_runway/features/vision_boards/data/models/retreived_photo_model.dart';
import 'package:project_runway/features/vision_boards/data/repositories/photo_repository.dart';
import 'package:project_runway/features/vision_boards/data/repositories/photos_state.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenBloc {
  static PhotosRepository _repository = PhotosRepository();
  PublishSubject<Photos> _query;

  init() {
    _query = PublishSubject<Photos>();
  }

  Stream<Photos> photosList() {
    return _query.stream;
  }

  void findPhotos(String query) async {
    PhotosState state = await _repository.imageData(query);
    if (state is SuccessState) {
      print(query);
      _query.sink.add(state.value);
    } else {
      _query.sink.addError((state as ErrorState).msg);
    }
  }

  void dispose() {
    _query.close();
  }
}

final bloc = HomeScreenBloc();
