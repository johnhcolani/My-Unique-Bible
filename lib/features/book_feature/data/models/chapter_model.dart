import '../../domain/entities/chapter.dart';

class ChapterModel extends Chapter {
  ChapterModel({required String englishName, required String persianName})
      : super(englishName: englishName, persianName: persianName);

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    final idParts = (json['id'] as String).split('.');
    final englishName = idParts.length > 1 ? idParts[1] : json['id'];
    final persianName = convertToPersianNumber(englishName);
    return ChapterModel(englishName: englishName, persianName: persianName);
  }

  Map<String, dynamic> toJson() {
    return {
      'englishName': englishName,
      'persianName': persianName,
    };
  }

  static String convertToPersianNumber(String number) {
    const englishToPersianDigits = {
      '0': '۰',
      '1': '۱',
      '2': '۲',
      '3': '۳',
      '4': '۴',
      '5': '۵',
      '6': '۶',
      '7': '۷',
      '8': '۸',
      '9': '۹',
    };

    return number.split('').map((digit) => englishToPersianDigits[digit] ?? digit).join();
  }
}
