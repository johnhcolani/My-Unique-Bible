import 'package:equatable/equatable.dart';
import '../../domain/entities/book.dart';

abstract class BookState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<Book> books;

  BookLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

class BookError extends BookState {
  final String message;

  BookError(this.message);

  @override
  List<Object?> get props => [message];
}
