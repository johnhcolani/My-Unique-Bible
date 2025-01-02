import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants.dart';

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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load chapters: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No chapters available for this book.'),
            );
          }

          // Chapters without Intro (Intro handled separately)
          final chapters = snapshot.data!..removeWhere((chapter) => chapter.toLowerCase() == 'intro');

          return Column(
            children: [
              // Intro button at the top
              Center(
                child: GestureDetector(
                  onTap: (){
                    // Handle intro tap
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
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade400, width: 2),),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Intro',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'مقدمه', // Persian for Intro
                              style: TextStyle(fontSize: 16, fontFamily: 'Vazir'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Chapters grid
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
                      return Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600, // Shadow color with transparency
                              blurRadius: 8, // Softness of the shadow
                              offset: Offset(0, 8), // X and Y offsets
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade400, width: 2),),
                            child: Column(
                              spacing: 16,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  chapter, // English number
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),

                                Text(
                                  persianChapter, // Persian number
                                  style: TextStyle(fontSize: 18, fontFamily: 'Vazir'),
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
      final List <dynamic>chapters = json.decode(response.body)['data'];
      return chapters.map<String>((dynamic chapter) {
        final idParts = (chapter['id'] as String).split('.');
        return idParts.length > 1 ? idParts[1] : chapter['id']; // Extract number
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
}
