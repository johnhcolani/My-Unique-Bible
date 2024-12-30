import 'package:my_unique_bible/features/book_feature/domain/repositories/book_repository.dart';

import '../entities/book.dart';

class GetBooksUseCase {
  final BookRepository repository;
  GetBooksUseCase(this.repository);

  Future<List<Book>> execute(String bibleId){
    return repository.fetchBooks(bibleId);
  }
}