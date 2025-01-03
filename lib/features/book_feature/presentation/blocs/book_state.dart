import 'package:equatable/equatable.dart';
import 'package:my_unique_bible/features/book_feature/domain/entities/chapter.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/verse.dart';

abstract class BookState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class SectionLoaded extends BookState {
  final List<Book> oldTestamentEnglish;
  final List<Book> newTestamentEnglish;
  final List<Book> oldTestamentPersian;
  final List<Book> newTestamentPersian;

  SectionLoaded(
      this.oldTestamentEnglish,
      this.newTestamentEnglish,
      this.oldTestamentPersian,
      this.newTestamentPersian,
      );

  @override
  List<Object?> get props => [
    oldTestamentEnglish,
    newTestamentEnglish,
    oldTestamentPersian,
    newTestamentPersian,

  ];
}

class BookError extends BookState {
  final String message;

  BookError(this.message);

  @override
  List<Object?> get props => [message];
}
class ChaptersLoaded extends BookState {
  final List<Chapter> chapters;

  ChaptersLoaded(this.chapters);

  @override
  List<Object?> get props => [chapters];
}
class VersesLoaded extends BookState {
  final List<Verse> verses;

  VersesLoaded(this.verses);

  @override
  List<Object?> get props => [verses];
}