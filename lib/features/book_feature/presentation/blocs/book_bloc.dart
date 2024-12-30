import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/get_books_usecase.dart';
import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooksUseCase getBooksUseCase;

  BookBloc({required this.getBooksUseCase}) : super(BookInitial()) {
    on<LoadBooksEvent>((event, emit) async {
      emit(BookLoading());
      try {
        final books = await getBooksUseCase.execute(event.bibleId);
        emit(BookLoaded(books));
      } catch (e) {
        emit(BookError('Failed to load books'));
      }
    });
  }
}
