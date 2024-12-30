import 'package:flutter_test/flutter_test.dart';
import 'package:my_unique_bible/features/book_feature/data/models/book_model.dart';

void main(){
  const bookJson = {
    'id':'1',
    'name': 'Genesis',
  };

  final bookModel = BookModel(id: '1', name: 'Genesis');
  test('BookModel should parse JSON correctly', (){
    //Arrange
    const inputJson = bookJson;

    //Act
    final result = BookModel.fromJson(inputJson);
    //Assert
    expect(result, bookModel);

  });

  test('BookModel should convert to JSON correctly', (){
    //Arrange
    final inputModel = bookModel;

    //Act
    final result = inputModel.toJson();
    //Assert
    expect(result, bookJson);

  });
}