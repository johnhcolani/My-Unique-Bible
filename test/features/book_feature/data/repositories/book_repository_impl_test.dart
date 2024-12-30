
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_unique_bible/features/book_feature/data/datasources/book_remote_datasource.dart';
import 'package:my_unique_bible/features/book_feature/data/models/book_model.dart';
import 'package:my_unique_bible/features/book_feature/data/repositories/book_repository_impl.dart';
import 'package:my_unique_bible/features/book_feature/domain/entities/book.dart';

class MockBookRemoteDataSource extends Mock implements BookRemoteDataSource {}

void main() {
  late MockBookRemoteDataSource mockDataSource;
  late BookRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockBookRemoteDataSource();
    repository = BookRepositoryImpl(mockDataSource);
  });

  const bibleId = '12345';
  final bookModel = BookModel(id: '1', name: 'Genesis');

  test('Repository should return a list of books from remote data source', () async {
    // Arrange
    when(() => mockDataSource.fetchBooks(bibleId))
        .thenAnswer((_) async => [bookModel]);

    // Act
    final result = await repository.fetchBooks(bibleId);

    // Assert
    expect(result, [Book(id: '1', name: 'Genesis')]);
    verify(() => mockDataSource.fetchBooks(bibleId)).called(1);
  });

  test('Repository should throw an exception if data source fails', () async {
    // Arrange
    when(() => mockDataSource.fetchBooks(bibleId)).thenThrow(Exception('Error'));

    // Act & Assert
    expect(() => repository.fetchBooks(bibleId), throwsException);
    verify(() => mockDataSource.fetchBooks(bibleId)).called(1);
  });
}