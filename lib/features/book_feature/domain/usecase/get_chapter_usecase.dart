import '../entities/chapter.dart';
import '../repositories/book_repository.dart';

class GetChaptersUseCase {
  final BookRepository repository;

  GetChaptersUseCase(this.repository);

  Future<List<Chapter>> execute(String bookId, String bibleId) {
    return repository.fetchChapters(bookId, bibleId);
  }
}
