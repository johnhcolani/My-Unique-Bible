import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/book_bloc.dart';
import '../blocs/book_event.dart';
import '../blocs/book_state.dart';

class VersePage extends StatelessWidget {
  final String chapterId;
  final String chapterName;
  final String bibleIdEnglish;
  final String bibleIdPersian;

  const VersePage({
    Key? key,
    required this.chapterId,
    required this.chapterName,
    required this.bibleIdEnglish,
    required this.bibleIdPersian,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapterName),
      ),
      body: BlocProvider(
        create: (context) => BookBloc(getVersesUseCase: context.read(), getBooksUseCase: context.read(), getChaptersUseCase: context.read())
          ..add(LoadVersesEvent(chapterId, bibleIdEnglish, bibleIdPersian)),
        child: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is VersesLoaded) {
              final verses = state.verses;
              if (verses.isEmpty) {
                return Center(child: Text('No verses available.'));
              }
              return ListView.builder(
                itemCount: verses.length,
                itemBuilder: (context, index) {
                  final verse = verses[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          verse.englishText.isNotEmpty ? verse.englishText : 'No English text available',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          verse.persianText.isNotEmpty ? verse.persianText : 'No Persian text available',
                          style: TextStyle(fontSize: 16, fontFamily: 'Vazir'),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is BookError) {
              return Center(child: Text(state.message));
            }

            return Container();
          },
        ),
      ),
    );
  }
}
