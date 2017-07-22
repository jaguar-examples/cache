import 'dart:async';
import 'package:jaguar_client/jaguar_client.dart';
import 'package:jaguar_serializer/serializer.dart';

import 'package:cache/common/models.dart';

final JsonRepo jsonRepo = new JsonRepo(serializers: [Book.serializer]);

SerializedJsonClient client;

void init(cl, String hostname) {
  client = new JsonClient(
    cl,
    basePath: hostname,
    repo: jsonRepo,
  )
      .serialized();
}

Future<Book> getById(String id) => client.get('/api/book/$id', type: Book);

Future<List<Book>> getAll() => client.get('/api/book', type: Book);

Future<Book> create(Book book) =>
    client.post('/api/book', body: book, type: Book);

Future<Book> update(Book book) =>
    client.put('/api/book/${book.id}', body: book, type: Book);

Future<List<Book>> remove(String id) =>
    client.delete('/api/book/book', type: Book);
