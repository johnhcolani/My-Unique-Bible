import 'package:equatable/equatable.dart';
import 'package:my_unique_bible/features/book_feature/domain/entities/book.dart';

class BookModel extends Book with EquatableMixin{
  BookModel({
    required super.id,
    required super.name
  });
  factory BookModel.fromJson(Map<String, dynamic>json){
    return BookModel(id: json['id'], name: json['name']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'name':name,
    };
  }

  @override
  List<Object?> get props => [id,name];
}