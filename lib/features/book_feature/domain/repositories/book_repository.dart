import 'package:my_unique_bible/features/book_feature/domain/entities/chapter.dart';

import '../entities/book.dart';
import '../entities/verse.dart';

abstract class BookRepository {
  Future<List<Book>> fetchBooks(String bibleId);
  Future<List<Chapter>> fetchChapters(String bookId, String bibleId);
  Future<List<Verse>> fetchVerses(String chapterId, String bibleIdEnglish, String bibleIdPersian);

}