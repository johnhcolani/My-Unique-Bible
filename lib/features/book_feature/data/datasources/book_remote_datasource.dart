import 'dart:convert';

import 'package:my_unique_bible/core/constants.dart';
import 'package:my_unique_bible/features/book_feature/data/models/book_model.dart';
import 'package:http/http.dart' as http;

abstract class BookRemoteDataSource {
  Future<List<BookModel>> fetchBooks(String bibleId);
  Future<List<String>> fetchChapters(String bookId, String bibleId); // Ensure this matches
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final http.Client client;
  BookRemoteDataSourceImpl(this.client);

  @override
  Future<List<BookModel>> fetchBooks(String bibleId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/bibles/$bibleId/books');
    final response =
        await client.get(url, headers: {'api-key': ApiConstants.apiKey});
    if (response.statusCode == 200) {
      final List books = json.decode(response.body)['data'];
      return books.map((book) => BookModel.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books:${response.body}');
    }
  }
  @override
  Future<List<String>> fetchChapters(String bookId, String bibleId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/bibles/$bibleId/books/$bookId/chapters');
    final response = await client.get(
      url,
      headers: {'api-key': ApiConstants.apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> chapters = json.decode(response.body)['data'];
      return chapters.map<String>((dynamic chapter) {
        final idParts = (chapter['id'] as String).split('.');
        return idParts.length > 1 ? idParts[1] : chapter['id'];
      }).toList();
    } else {
      throw Exception('Failed to load chapters: ${response.body}');
    }
  }
}
