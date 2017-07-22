import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_serializer/serializer.dart';
import 'package:jaguar_cache/jaguar_cache.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:jaguar_mongo/jaguar_mongo.dart';
import 'package:jaguar_json/jaguar_json.dart';

import 'package:cache/common/models.dart';
import 'package:cache/server/bean.dart';

const mongoUrl = "mongodb://localhost:27018/todos";

final InMemoryCache cache = new InMemoryCache(new Duration(minutes: 30));

final JsonRepo jsonRepo = new JsonRepo(serializers: [Book.serializer]);

@Api(path: '/api/book')
class BookApi extends JsonRoutes {
  JsonRepo get repo => jsonRepo;

  @Get()
  Future<Response<String>> getAll(Context ctx) async {
    final db = ctx.getInput<Db>(MongoDb);
    final bean = new BookBean(db);
    final List<Book> books = await bean.getAll();
    books.forEach((Book book) {
      cache.upsert(book.id, book);
    });
    return toJson(books);
  }

  @Get(path: '/:id')
  Future<Response<String>> getById(Context ctx) async {
    final String id = ctx.pathParams.id;

    Book book;
    try {
      book = cache.read(id);
    } catch(e) {
      final db = ctx.getInput<Db>(MongoDb);
      final bean = new BookBean(db);
      book = await bean.getById(id);
      cache.upsert(id, book);
    }
    return toJson(book);
  }

  @Post()
  Future<Response<String>> create(Context ctx) async {
    final db = ctx.getInput<Db>(MongoDb);
    Book book = await fromJson(ctx, type: Book);
    final bean = new BookBean(db);
    final String id = await bean.create(book);
    book = await bean.getById(id);
    cache.upsert(id, book);
    return toJson(book);
  }

  @Put(path: '/:id')
  Future<Response<String>> update(Context ctx) async {
    final String id = ctx.pathParams.id;
    final db = ctx.getInput<Db>(MongoDb);
    Book book = await fromJson(ctx, type: Book);
    book.id = id;
    final bean = new BookBean(db);
    await bean.update(book);
    book = await bean.getById(id);
    cache.upsert(id, book);
    return toJson(book);
  }

  @Delete(path: '/:id')
  Future<Response<String>> delete(Context ctx) async {
    final String id = ctx.pathParams.id;
    final db = ctx.getInput<Db>(MongoDb);
    final bean = new BookBean(db);
    await bean.remove(id);
    cache.remove(id);
    final List<Book> books = await bean.getAll();
    return toJson(books);
  }
}

serve() async {
  final server = new Jaguar();
  server.addApiReflected(new BookApi());

  server.wrap((_) => new MongoDb(mongoUrl));
  await server.serve();
}