import '../entities/verse.dart';
import '../repositories/book_repository.dart';

class GetVersesUseCase {
  final BookRepository repository;

  GetVersesUseCase(this.repository);

  Future<List<Verse>> execute(String chapterId, String bibleIdEnglish, String bibleIdPersian) {
    return repository.fetchVerses(chapterId, bibleIdEnglish, bibleIdPersian);
  }
}
