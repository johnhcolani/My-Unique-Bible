import 'package:equatable/equatable.dart';

class Verse extends Equatable {
  final String englishText;
  final String persianText;

  const Verse({required this.englishText, required this.persianText});

  @override
  List<Object?> get props => [englishText, persianText];
}
