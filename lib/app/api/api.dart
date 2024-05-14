import 'package:cloud_firestore/cloud_firestore.dart';

class ApiClient {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllData(String collectionName) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection(collectionName).get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<String> createData(
      String collectionName, Map<String, dynamic> newData) async {
    String documentId =
        FirebaseFirestore.instance.collection(collectionName).doc().id;
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .set({...newData, collectionName + 'Id': documentId});
    return documentId;
  }

  Future<void> updateData(String collectionName, String documentId,
      Map<String, dynamic> newData) async {
    await _firestore.collection(collectionName).doc(documentId).update(newData);
  }

  Future<void> deleteData(String collectionName, String documentId) async {
    await _firestore.collection(collectionName).doc(documentId).delete();
  }

  Future<bool> doesStringExistInCollection(
      String searchString, String collectionName) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot =
          await firestore.collection(collectionName).get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        for (String key in data.keys) {
          if (data[key].toString().contains(searchString)) {
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<String?> loginUser(String phoneNumber, String password) async {
    try {
      // Check if user exists with the provided phone number and password
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .where('pass', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // User does not exist with the provided phone number and password
        return null;
      } else {
        // User exists, return user ID
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (userData != null && userData['usersId'] != null) {
          return userData['usersId'] as String;
        } else {
          return null;
        }
      }
    } catch (e) {
      // Handle errors
      print("Error: $e");
      return null;
    }
  }
}
