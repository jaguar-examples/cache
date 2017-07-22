// GENERATED CODE - DO NOT MODIFY BY HAND

part of models;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class BookSerializer
// **************************************************************************

abstract class _$BookSerializer implements Serializer<Book> {
  Map toMap(Book model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.name != null) {
        ret["name"] = model.name;
      }
      if (model.author != null) {
        ret["author"] = model.author;
      }
      if (model.pages != null) {
        ret["pages"] = model.pages;
      }
      if (model.price != null) {
        ret["price"] = model.price;
      }
      if (modelString() != null && withType) {
        ret[typeKey ?? defaultTypeInfoKey] = modelString();
      }
    }
    return ret;
  }

  Book fromMap(Map map, {Book model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! Book) {
      model = createModel();
    }
    model.id = map["id"];
    model.name = map["name"];
    model.author = map["author"];
    model.pages = map["pages"];
    model.price = map["price"];
    return model;
  }

  String modelString() => "Book";
}
