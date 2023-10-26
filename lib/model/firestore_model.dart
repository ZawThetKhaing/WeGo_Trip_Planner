class FireStoreModel {
  final String collection;
  final String? doc;
  final Map<String, dynamic> data;
  FireStoreModel({
    required this.collection,
    this.doc,
    required this.data,
  });
}
