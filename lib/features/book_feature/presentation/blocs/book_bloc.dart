import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/get_books_usecase.dart';
import '../../domain/usecase/get_chapter_usecase.dart';
import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooksUseCase getBooksUseCase;
  final GetChaptersUseCase getChaptersUseCase;

  BookBloc({required this.getBooksUseCase,required this.getChaptersUseCase}) : super(BookInitial()) {
    on<LoadBooksEvent>((event, emit) async {
      emit(BookLoading());
      try {
        // Fetch books for English and Persian Bibles
        final englishBooks = await getBooksUseCase.execute('de4e12af7f28f599-01'); // English Bible ID
        final persianBooks = await getBooksUseCase.execute('7cd100148df29c08-01'); // Persian Bible ID

        // Separate Old Testament and New Testament by predefined book IDs
        final oldTestamentIds = <String>[
          'GEN', 'EXO', 'LEV', 'NUM', 'DEU', 'JOS', 'JDG', 'RUT', '1SA', '2SA', '1KI', '2KI',
          '1CH', '2CH', 'EZR', 'NEH', 'EST', 'JOB', 'PSA', 'PRO', 'ECC', 'SNG', 'ISA', 'JER',
          'LAM', 'EZK', 'DAN', 'HOS', 'JOE', 'AMO', 'OBA', 'JON', 'MIC', 'NAH', 'HAB', 'ZEP',
          'HAG', 'ZEC', 'MAL'
        ];

        final newTestamentIds = <String>[
          'MAT', 'MRK', 'LUK', 'JHN', 'ACT', 'ROM', '1CO', '2CO', 'GAL', 'EPH', 'PHP', 'COL',
          '1TH', '2TH', '1TI', '2TI', 'TIT', 'PHM', 'HEB', 'JAS', '1PE', '2PE', '1JN', '2JN',
          '3JN', 'JUD', 'REV'
        ];

        // Filter books for each section
        final oldTestamentEnglish = englishBooks.where((book) => oldTestamentIds.contains(book.id)).toList();
        final newTestamentEnglish = englishBooks.where((book) => newTestamentIds.contains(book.id)).toList();

        final oldTestamentPersian = persianBooks.where((book) => oldTestamentIds.contains(book.id)).toList();
        final newTestamentPersian = persianBooks.where((book) => newTestamentIds.contains(book.id)).toList();

        emit(SectionLoaded(
          oldTestamentEnglish,
          newTestamentEnglish,
          oldTestamentPersian,
          newTestamentPersian,
        ));
      } catch (e) {
        emit(BookError('Failed to load books'));
      }
    });
    on<LoadChaptersEvent>((event, emit) async {
      emit(BookLoading());
      try {
        final chapters = await getChaptersUseCase.execute(event.bookId, event.bibleId);
        emit(ChaptersLoaded(chapters));
      } catch (e) {
        emit(BookError('Failed to load chapters'));
      }
    });
  }

}
