import 'package:buzz_talk/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference? _usersCollection;

  DatabaseService();

  void _setupCollectionReferences() {
    _usersCollection = _firestore
        .collection('users')
        .withConverter<UserProfile>(
            fromFirestore: (snapshots, _) =>
                UserProfile.fromJson(snapshots.data()!),
            toFirestore: (userProfile, _) => userProfile.toJson());
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    if (_usersCollection == null) {
      _setupCollectionReferences();
    }

    try {
      await _usersCollection!.doc(userProfile.uid).set(userProfile);
    } catch (e) {
      rethrow;
    }
  }
}
