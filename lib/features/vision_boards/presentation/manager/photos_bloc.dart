import 'dart:async';

import 'package:project_runway/features/vision_boards/data/models/retreived_photo_model.dart';
import 'package:project_runway/features/vision_boards/data/repositories/photo_repository.dart';
import 'package:project_runway/features/vision_boards/data/repositories/photos_state.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenBloc {
  static PhotosRepository _repository = PhotosRepository();
  PublishSubject<String> _query;

  init() {
    _query = PublishSubject<String>();
  }

  Stream<Photos> photosList() {
    print("in photo list");
    return _query.stream
        .debounceTime(Duration(milliseconds: 300))
        .where((String value) => value.isNotEmpty)
        .distinct()
        .transform(streamTransformer);
  }

  final streamTransformer = StreamTransformer<String, Photos>.fromHandlers(
      handleData: (query, sink) async {
    print(query);
    PhotosState state = await _repository.imageData(query);
    if (state is SuccessState) {
      sink.add(state.value);
    } else {
      sink.addError((state as ErrorState).msg);
    }
  });

  Function(String) get changeQuery => _query.sink.add;

  void dispose() {
    _query.close();
  }

  String getDescription(Result result) {
    return (result.description == null || result.description.isEmpty)
        ? result.altDescription
        : result.description;
  }

//  void shareImage(String url) {
//    _repository.getImageToShare(url).then((Uint8List value) async {
//      await Share.file("Share via:","image.png",value,"image/png");
//    });
//  }
}

final bloc = HomeScreenBloc();
