import 'package:equatable/equatable.dart';

class Chapter extends Equatable {
  final String englishName;
  final String persianName;

  Chapter({required this.englishName, required this.persianName});

  @override
  List<Object?> get props => [englishName, persianName];
}
