library bean;

import 'dart:async';
import 'package:jaguar_serializer/serializer.dart';
import 'package:jaguar_serializer_mongo/jaguar_serializer_mongo.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:cache/common/models.dart';

part 'bean.g.dart';

@GenSerializer()
@MongoId(#id)
@EnDecodeField(#id, asAndFrom: '_id')
class _BookMgoSerializer extends Serializer<Book> with _$_BookMgoSerializer {
  @override
  Book createModel() => new Book();
}

class BookBean {
  final Db db;

  DbCollection get col => db.collection('book');

  BookBean(this.db);

  final _BookMgoSerializer _ser = new _BookMgoSerializer();

  ObjectId mkId(String id) => ObjectId.parse(id);

  Future<Book> getById(String id) async {
    final Map map = await col.findOne(where.id(mkId(id)));
    return _ser.deserialize(map);
  }

  Future<List<Book>> getAll() async {
    final List<Map> map = await (await col.find()).toList();
    return _ser.deserialize(map);
  }

  Future<String> create(Book book) async {
    final String id = new ObjectId().toHexString();
    book.id = id;
    final Map map = _ser.serialize(book);
    await col.insert(map);
    return id;
  }

  Future update(Book book) async {
    final Map map = _ser.serialize(book);
    final upd = modify;
    map.forEach(upd.set);
    await col.update(where.id(mkId(book.id)), upd);
  }

  Future remove(String id) async {
    await col.remove(where.id(mkId(id)));
  }
}