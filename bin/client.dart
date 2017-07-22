import 'package:http/http.dart';
import 'package:cache/client/client.dart';

import 'package:cache/common/models.dart';

main() async {
  init(new Client(), "http://localhost:8080");

  Book book1 = await create(Book.number(1));
  print(book1);

  Book book2 = await create(Book.number(2));
  print(book2);

  book1 = await getById(book1.id);
  print(book1);

  book1 = await update(book1.clone(author: 'teja'));
  print(book1);

  book1 = await getById(book1.id);
  print(book1);
}
