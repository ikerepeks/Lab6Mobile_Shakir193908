import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // collection reference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  final String uid;
  DatabaseService({this.uid});

  // To create and update user doc data
  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // convert to brew list from snapshot
  List<Brew> _brewlistFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
          name: doc.data['name'] ?? '',
          strength: doc.data['strength'] ?? 0,
          sugars: doc.data['sugars'] ?? '0');
    }).toList();
  }

  //userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        sugars: snapshot.data['sugars'],
        strength: snapshot.data['strength']);
  }

  //get brews stream data
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewlistFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return brewCollection
        .document(uid)
        .snapshots()
        .map((_userDataFromSnapshot));
  }
}
