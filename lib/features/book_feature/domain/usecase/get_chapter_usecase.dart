import '../repositories/book_repository.dart';

class GetChaptersUseCase {
  final BookRepository repository;

  GetChaptersUseCase(this.repository);

  Future<List<String>> execute(String bookId, String bibleId) async {
    final chapters = await repository.fetchChapters(bookId, bibleId);
    // Filter out "Intro"
    return chapters.where((chapter) => chapter.toLowerCase() != 'intro').toList();
  }
}
