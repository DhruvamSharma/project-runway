import 'package:equatable/equatable.dart';

class VisionBoardListArgs extends Equatable {
  final int pageNumber;
  VisionBoardListArgs(this.pageNumber);
  @override
  // TODO: implement props
  List<Object> get props => [
        this.pageNumber,
      ];
}
