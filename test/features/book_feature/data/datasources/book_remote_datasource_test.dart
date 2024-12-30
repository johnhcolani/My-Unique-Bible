
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:my_unique_bible/features/book_feature/data/datasources/book_remote_datasource.dart';
import 'package:my_unique_bible/features/book_feature/data/models/book_model.dart';

class MockHttpClient extends Mock implements http.Client{}

void main(){
  late MockHttpClient mockHttpClient;
  late BookRemoteDataSourceImpl dataSource;

  setUpAll((){
    // Register a fallback value for Uri
    registerFallbackValue(Uri.parse(''));


  });
  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = BookRemoteDataSourceImpl(mockHttpClient);
  });

  const bibleId = '12345';
  final bookJson = {'id':'1', 'name':'Genesis'};
  final bookList = [bookJson];

  test('fetchBooks should return a list of BookModels on success',() async {
    // Arrange
    when(()=> mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(json.encode({'data':bookList}),200));

    // Act
    final result = await dataSource.fetchBooks(bibleId);

    //Assert
    expect(result,[BookModel.fromJson(bookJson)] );
    verify(()=> mockHttpClient.get(any(),headers: any(named: 'headers'))).called(1);
  });

  test('fetchBooks should throw an exception on error', () async {
    // Arrange
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response('Error', 404));

    // Act & Assert
    expect(() => dataSource.fetchBooks(bibleId), throwsException);
  });

}