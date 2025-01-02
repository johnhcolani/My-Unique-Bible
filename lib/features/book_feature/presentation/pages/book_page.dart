import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/book.dart';
import '../blocs/book_bloc.dart';
import '../blocs/book_event.dart';
import '../blocs/book_state.dart';
import 'chapter_page.dart';

class BookPage extends StatelessWidget {
  final String section;

  const BookPage({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(section == 'oldTestament' ? 'Old Testament' : 'New Testament'),
      ),
      body: BlocProvider(
        create: (_) => BookBloc(getBooksUseCase: context.read())..add(LoadBooksEvent('de4e12af7f28f599-01')),
        child: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SectionLoaded) {
              // Select the books to display based on the section

              final englishBooks = section == 'oldTestament'
                  ? state.oldTestamentEnglish
                  : state.newTestamentEnglish;

              final persianBooks = section == 'oldTestament'
                  ? state.oldTestamentPersian
                  : state.newTestamentPersian;
            // Combine English and Persian books
              final books = englishBooks.map((englishBook) {
                final persianBook = persianBooks.firstWhere(
                      (book) => book.id == englishBook.id,
                  orElse: () => Book(id: englishBook.id, name: 'Not Found'),
                );
                return {
                  'id': englishBook.id, // Ensure 'id' is always non-null
                  'english': englishBook.name,
                  'persian': persianBook.name
                };
              }).toList();
              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final bookPair = books[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      color: Colors.grey.shade100,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Expanded(child: Text(bookPair['english'] ?? 'Unknown')), // English book name
                            Expanded(
                              child: Text(
                                bookPair['persian'] ?? 'ناشناخته',
                                textAlign: TextAlign.right, // Right-align Persian text
                                style: TextStyle(fontFamily: 'Vazir'), // Use a Persian-compatible font
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navigate to chapter page (to be implemented)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChapterPage(
                                bookId: bookPair['id']!,
                                bookName: bookPair['english'] ?? 'Unknown',
                                bibleId: 'de4e12af7f28f599-01', // Example Bible ID
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (state is BookError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No books available.'));
          },
        ),
      ),
    );
  }
}
