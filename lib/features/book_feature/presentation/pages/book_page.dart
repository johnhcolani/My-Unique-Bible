import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/book_bloc.dart';
import '../blocs/book_event.dart';
import '../blocs/book_state.dart';

class BookPage extends StatelessWidget {
  final String bibleId;

  const BookPage({Key? key, required this.bibleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Books')),
      body: BlocProvider(
        create: (_) => BookBloc(getBooksUseCase: context.read())..add(LoadBooksEvent(bibleId)),
        child: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BookLoaded) {
              final books = state.books;
              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return ListTile(
                    title: Text(book.name),
                    onTap: () {
                      // Navigate to chapter page (to be implemented)
                    },
                  );
                },
              );
            } else if (state is BookError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('Select a section to view books.'));
          },
        ),
      ),
    );
  }
}
