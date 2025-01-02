

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        create: (context) => BookBloc(getChaptersUseCase: context.read(), getBooksUseCase: context.read())
          ..add(LoadChaptersEvent(bookId, bibleId)),
        child: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ChaptersLoaded) {
              final chapters = state.chapters;

              return Column(
                children: [
                  // Intro button
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: Center(
                        child: Text(
                          'مقدمه',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: chapters.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                          child: Text(
                            chapters[index],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
