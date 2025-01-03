import '../../domain/entities/verse.dart';

class VerseModel extends Verse {
  VerseModel({required String englishText, required String persianText})
      : super(englishText: englishText, persianText: persianText);

  factory VerseModel.fromJson(Map<String, dynamic> json) {

    return VerseModel(
      englishText: json['text'] ?? '', // Safely fetch English text
      persianText: json['persian_text'] ?? '', // Ensure Persian text field matches API
    );
  }
}
