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
class LoadChaptersEvent extends BookEvent {
  final String bookId;
  final String bibleId;

  LoadChaptersEvent(this.bookId, this.bibleId);

  @override
  List<Object?> get props => [bookId, bibleId];
}
class LoadVersesEvent extends BookEvent {
  final String chapterId;
  final String bibleIdEnglish;
  final String bibleIdPersian;

  LoadVersesEvent(this.chapterId, this.bibleIdEnglish, this.bibleIdPersian);

  @override
  List<Object?> get props => [chapterId, bibleIdEnglish, bibleIdPersian];
}