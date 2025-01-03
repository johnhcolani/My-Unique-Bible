import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/book_feature/data/repositories/book_repository_impl.dart';
import 'features/book_feature/data/datasources/book_remote_datasource.dart';
import 'features/book_feature/domain/usecase/get_books_usecase.dart';
import 'features/book_feature/domain/usecase/get_chapter_usecase.dart';
import 'features/book_feature/domain/usecase/get_verses_usecase.dart';
import 'features/book_feature/presentation/pages/main_page.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();
    final dataSource = BookRemoteDataSourceImpl(httpClient);
    final repository = BookRepositoryImpl(dataSource);
    final getBooksUseCase = GetBooksUseCase(repository);
    final getChaptersUseCase = GetChaptersUseCase(repository); // Add this use case
    final getVersesUseCase = GetVersesUseCase(repository);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GetBooksUseCase>(create: (_) => getBooksUseCase),
        RepositoryProvider<GetChaptersUseCase>(create: (_) => getChaptersUseCase), // Provide GetChaptersUseCase
        RepositoryProvider<GetVersesUseCase>(create: (_)=> getVersesUseCase),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}
