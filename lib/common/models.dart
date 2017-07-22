library models;

import 'package:jaguar_serializer/serializer.dart';

part 'models.g.dart';

class Book {
  String id;

  String name;

  String author;

  int pages;

  int price;

  Book();

  Book clone({String name, String author, int pages, int price}) => Book.make(
      name ?? this.name,
      author ?? this.author,
      pages ?? this.pages,
      price ?? this.price,
      id: id);

  String toString() => 'Book($id, $name, $author, $pages, $price)';

  static Book make(String name, String author, int pages, int price,
          {String id}) =>
      new Book()
        ..id = id
        ..name = name
        ..author = author
        ..pages = pages
        ..price = price;

  static Book number(int number, {String id}) => new Book()
    ..id = id
    ..name = 'Name$number'
    ..author = 'Author$number'
    ..pages = number * 100
    ..price = number * 10;

  static final BookSerializer serializer = new BookSerializer();
}

@GenSerializer()
class BookSerializer extends Serializer<Book> with _$BookSerializer {
  @override
  Book createModel() => new Book();
}
