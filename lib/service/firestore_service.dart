import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_go/model/firestore_model.dart';

class FireStoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ///Write
  Future<void> write(FireStoreModel storeModel) => _firebaseFirestore
      .collection(storeModel.collection)
      .doc(storeModel.doc)
      .set(storeModel.data);

  ///Update
  Future<void> update(FireStoreModel storeModel) => _firebaseFirestore
      .collection(storeModel.collection)
      .doc(storeModel.doc)
      .update(storeModel.data);

  ///Read All
  Future<QuerySnapshot<Map<String, dynamic>>> readAll(
    String collection,
  ) =>
      _firebaseFirestore.collection(collection).get();

  ///Read Only
  Future<DocumentSnapshot<Map<String, dynamic>>> readOnly(
    String collection,
    String doc,
  ) =>
      _firebaseFirestore.collection(collection).doc(doc).get();

  ///Watch All
  Stream<QuerySnapshot<Map<String, dynamic>>> watchAll(
    String collection,
  ) =>
      _firebaseFirestore.collection(collection).snapshots();

  ///Watch Only
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchOnly(
    String collection,
    String doc,
  ) =>
      _firebaseFirestore.collection(collection).doc(doc).snapshots();

  ///Delete Data
  void drop(String collection, String doc) =>
      _firebaseFirestore.collection(collection).doc(doc).delete();
}
