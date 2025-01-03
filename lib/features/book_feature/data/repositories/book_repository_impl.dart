import 'package:my_unique_bible/features/book_feature/data/datasources/book_remote_datasource.dart';
import 'package:my_unique_bible/features/book_feature/domain/entities/book.dart';
import 'package:my_unique_bible/features/book_feature/domain/entities/chapter.dart';
import 'package:my_unique_bible/features/book_feature/domain/repositories/book_repository.dart';

import '../../domain/entities/verse.dart';

class BookRepositoryImpl implements BookRepository{
  final BookRemoteDataSource remoteDataSource;
  BookRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Book>> fetchBooks(String bibleId)async {
    final bookModels = await remoteDataSource.fetchBooks(bibleId);
    return bookModels.map((bookModel) => Book(id: bookModel.id, name: bookModel.name)).toList();
  }
  @override
  Future<List<Chapter>> fetchChapters(String bookId, String bibleId) async {
    final chapterModels = await remoteDataSource.fetchChapters(bookId, bibleId);
    return chapterModels.map((chapterModel) => Chapter(
      englishName: chapterModel.englishName,
      persianName: chapterModel.persianName,
    )).toList();
  }
  @override
  Future<List<Verse>> fetchVerses(String chapterId, String bibleIdEnglish, String bibleIdPersian) async {
    final verseModels = await remoteDataSource.fetchVerses(chapterId, bibleIdEnglish, bibleIdPersian);
    return verseModels.map((verseModel) => Verse(
      englishText: verseModel.englishText,
      persianText: verseModel.persianText,
    )).toList();
  }
}
