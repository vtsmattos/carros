import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/login/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritoService {

  //CollectionReference get _carros => Firestore.instance.collection("carros");
  CollectionReference get _users => Firestore.instance.collection("users");
  get _carros => _users.document(firebaseUserId).collection("carros");

  Stream<QuerySnapshot> get stream => _carros.snapshots();
  
  Future<bool> favoritar(Carro c) async {

    DocumentReference docRef = _carros.document("${c.id}");
    DocumentSnapshot doc = await docRef.get();
    final exists = doc.exists;

    if(exists){
      docRef.delete();
          return false;
    }
    else{
      docRef.setData(c.toMap());
    }

    return true;
  }

  Future<bool> isFavorito(Carro c) async {
    DocumentReference docRef = _carros.document("${c.id}");
    DocumentSnapshot doc = await docRef.get();
    return doc.exists;
  }
}
