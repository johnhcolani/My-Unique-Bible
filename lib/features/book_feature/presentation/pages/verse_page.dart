import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/book_bloc.dart';
import '../blocs/book_event.dart';
import '../blocs/book_state.dart';

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
        create: (context) => BookBloc(
          getVersesUseCase: context.read(),
          getBooksUseCase: context.read(),
          getChaptersUseCase: context.read(),
        )..add(LoadVersesEvent(chapterId, bibleIdEnglish, bibleIdPersian)),
        child: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VersesLoaded) {
              final verses = state.verses;
              if (verses.isEmpty) {
                return const Center(child: Text('No verses available.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                itemCount: verses.length,
                itemBuilder: (context, index) {
                  final verse = verses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            verse.englishText.isNotEmpty ? verse.englishText : 'No English text available',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            verse.persianText.isNotEmpty ? verse.persianText : 'No Persian text available',
                            style: const TextStyle(fontSize: 16, fontFamily: 'Vazir'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is BookError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
    );
  }
}
