import 'package:my_unique_bible/features/book_feature/data/datasources/book_remote_datasource.dart';
import 'package:my_unique_bible/features/book_feature/domain/entities/book.dart';
import 'package:my_unique_bible/features/book_feature/domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository{
  final BookRemoteDataSource remoteDataSource;
  BookRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Book>> fetchBooks(String bibleId)async {
    final bookModels = await remoteDataSource.fetchBooks(bibleId);
    return bookModels.map((bookModel) => Book(id: bookModel.id, name: bookModel.name)).toList();
  }
  @override
  Future<List<String>> fetchChapters(String bookId, String bibleId) async {
    return await remoteDataSource.fetchChapters(bookId, bibleId); // Pass to data source
  }

}