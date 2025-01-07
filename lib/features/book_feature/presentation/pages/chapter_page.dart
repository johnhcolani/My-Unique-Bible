import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants.dart';
import 'verse_page.dart';

class ChapterPage extends StatelessWidget {
  final String bookId;
  final String bookName;
  final String bibleId;

  const ChapterPage({
    Key? key,
    required this.bookId,
    required this.bookName,
    required this.bibleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookName),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchChapters(bookId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No chapters available for this book.'),
            );
          }

          final chapters = snapshot.data!..removeWhere((chapter) => chapter.toLowerCase() == 'intro');

          return Column(
            children: [
              // Intro button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VersePage(
                        chapterId: 'intro',
                        chapterName: 'Intro',
                        bibleIdEnglish: bibleId, // Pass the English Bible ID
                        bibleIdPersian: bibleId, // Pass the Persian Bible ID
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Intro',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'مقدمه', // Persian for Intro
                        style: TextStyle(fontSize: 16, fontFamily: 'Vazir'),
                      ),
                    ],
                  ),
                ),
              ),
              // Chapter grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Number of items per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: chapters.length,
                    itemBuilder: (context, index) {
                      final chapter = chapters[index];
                      final persianChapter = convertToPersianNumber(chapter);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VersePage(
                                chapterId: chapter,
                                chapterName: 'Chapter $chapter',
                                bibleIdEnglish: bibleId,
                                bibleIdPersian: bibleId,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade600,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  chapter,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  persianChapter,
                                  style: const TextStyle(fontSize: 18, fontFamily: 'Vazir'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<String>> fetchChapters(String bookId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/bibles/$bibleId/books/$bookId/chapters');
    final response = await http.get(
      url,
      headers: {'api-key': ApiConstants.apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> chapters = json.decode(response.body)['data'];
      return chapters.map<String>((chapter) {
        final idParts = (chapter['id'] as String).split('.');
        return idParts.length > 1 ? idParts[1] : chapter['id'];
      }).toList();
    } else {
      throw Exception('Failed to load chapters: ${response.statusCode} ${response.body}');
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
}


