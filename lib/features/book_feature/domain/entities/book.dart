import 'package:equatable/equatable.dart';

class Book extends Equatable{
  final String id;
  final String name;

  Book({required this.id, required this.name});

  @override
  // TODO: implement props
  List<Object?> get props => [id,name];
}