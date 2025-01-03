import 'dart:convert';

import 'package:my_unique_bible/core/constants.dart';
import 'package:my_unique_bible/features/book_feature/data/models/book_model.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/chapter.dart';
import '../models/chapter_model.dart';
import '../models/verse_model.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> fetchBooks(String bibleId);
  Future<List<ChapterModel>> fetchChapters(String bookId, String bibleId);
  Future<List<VerseModel>> fetchVerses(String chapterId, String bibleIdEnglish, String bibleIdPersian);


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
  Future<List<ChapterModel>> fetchChapters(String bookId, String bibleId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/bibles/$bibleId/books/$bookId/chapters');
    final response = await client.get(
      url,
      headers: {'api-key': ApiConstants.apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> chapters = json.decode(response.body)['data'];
      return chapters.map<ChapterModel>((dynamic chapter) {
        return ChapterModel.fromJson(chapter as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception('Failed to load chapters: ${response.body}');
    }
  }
  String convertToPersianNumber(String number) {
    const englishToPersianDigits = {
      '0': '۰',
      '1': '۱',
      '2': '۲',
      '3': '۳',
      '4': '۴',
      '5': '۵',
      '6': '۶',
      '7': '۷',
      '8': '۸',
      '9': '۹',
    };

    return number.split('').map((digit) => englishToPersianDigits[digit] ?? digit).join();
  }
  Future<List<VerseModel>> fetchVerses(String chapterId, String bibleIdEnglish, String bibleIdPersian) async {
    final urlEnglish = Uri.parse('${ApiConstants.baseUrl}/bibles/$bibleIdEnglish/chapters/$chapterId/verses');
    final urlPersian = Uri.parse('${ApiConstants.baseUrl}/bibles/$bibleIdPersian/chapters/$chapterId/verses');

    print('English URL: $urlEnglish');
    print('Persian URL: $urlPersian');

    final responseEnglish = await client.get(urlEnglish, headers: {'api-key': ApiConstants.apiKey});
    final responsePersian = await client.get(urlPersian, headers: {'api-key': ApiConstants.apiKey});

    print('English Response: ${responseEnglish.body}');
    print('Persian Response: ${responsePersian.body}');

    if (responseEnglish.statusCode == 200 && responsePersian.statusCode == 200) {
      final versesEnglish = json.decode(responseEnglish.body)['data'] as List<dynamic>?;
      final versesPersian = json.decode(responsePersian.body)['data'] as List<dynamic>?;

      if (versesEnglish == null || versesPersian == null) {
        throw Exception('Missing data in API response.');
      }

      return List.generate(versesEnglish.length, (index) {
        final englishText = versesEnglish[index]['text'] ?? '';
        final persianText = index < versesPersian.length ? versesPersian[index]['text'] ?? '' : '';
        return VerseModel(englishText: englishText, persianText: persianText);
      });
    } else {
      throw Exception('Failed to load verses. English: ${responseEnglish.body}, Persian: ${responsePersian.body}');
    }
  }


}