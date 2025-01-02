import 'package:equatable/equatable.dart';
import '../../domain/entities/book.dart';

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
  final List<String> chapters;

  ChaptersLoaded(this.chapters);

  @override
  List<Object?> get props => [chapters];
}