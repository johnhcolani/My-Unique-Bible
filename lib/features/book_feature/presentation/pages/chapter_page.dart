import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_unique_bible/features/book_feature/presentation/pages/verse_page.dart';

import '../../domain/entities/chapter.dart';
import '../blocs/book_bloc.dart';
import '../blocs/book_event.dart';
import '../blocs/book_state.dart';

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
      body: BlocProvider(
        create: (context) => BookBloc(getChaptersUseCase: context.read(), getBooksUseCase: context.read(), getVersesUseCase: context.read())
          ..add(LoadChaptersEvent(bookId, bibleId)),
        child: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ChaptersLoaded) {
              final filteredChapters = state.chapters.where((chapter) => chapter.englishName.toLowerCase() != 'intro').toList();

              final chapters = [
                Chapter(englishName: 'Intro', persianName: 'مقدمه'), // Add Intro as the first item
                ...filteredChapters,
              ];

              return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Number of items per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>VersePage(
                          chapterId: chapter.englishName,
                          chapterName: chapter.persianName,
                          bibleIdEnglish: 'de4e12af7f28f599-01',
                          bibleIdPersian: '7cd100148df29c08-01')));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            chapter.englishName, // English chapter name
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            chapter.persianName, // Persian chapter name
                            style: TextStyle(fontSize: 18, fontFamily: 'Vazir'),
                          ),
                        ],
                      ),
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
