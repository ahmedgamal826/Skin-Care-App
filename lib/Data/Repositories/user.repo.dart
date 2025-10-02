import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/User/user.model.dart';

class UserRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserRepo();

  UserModel? toModel(Map<String, dynamic>? item) =>
      UserModel.fromMap(item ?? {});

  Map<String, dynamic>? fromModel(UserModel? item) => item?.toMap() ?? {};

  Future<String?> createSingle(String collection, String documentId,
      Map<String, dynamic> documentData) async {
    try {
      print(
          '🔍 UserRepo: Creating document in collection: $collection, documentId: $documentId');
      print('📊 UserRepo: Document data: $documentData');
      await _firestore.collection(collection).doc(documentId).set(documentData);
      print('✅ UserRepo: Document created successfully');
      return documentId;
    } catch (e, stackTrace) {
      print('💥 UserRepo: Error creating document: $e');
      print('📍 UserRepo: Stack trace: $stackTrace');
      return null;
    }
  }

  Future<UserModel?> readSingle(String collection, String documentId) async {
    try {
      print(
          '🔍 UserRepo: Reading document from collection: $collection, documentId: $documentId');
      DocumentSnapshot doc =
          await _firestore.collection(collection).doc(documentId).get();
      print('📄 UserRepo: Document exists: ${doc.exists}');

      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        print('📊 UserRepo: Document data: $data');
        UserModel? model = toModel(data);
        print('✅ UserRepo: Converted to model: $model');
        return model;
      } else {
        print('❌ UserRepo: Document does not exist');
        return null;
      }
    } catch (e, stackTrace) {
      print('💥 UserRepo: Error reading document: $e');
      print('📍 UserRepo: Stack trace: $stackTrace');
      return null;
    }
  }

  Future<bool> updateSingle(String collection, String documentId,
      Map<String, dynamic> documentData) async {
    try {
      await _firestore
          .collection(collection)
          .doc(documentId)
          .update(documentData);
      return true;
    } catch (e) {
      print('Error updating document: $e');
      return false;
    }
  }
}
