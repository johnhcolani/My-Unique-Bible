import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadBooksEvent extends BookEvent {
  final String bibleId;

  LoadBooksEvent(this.bibleId);

  @override
  List<Object?> get props => [bibleId];
}
