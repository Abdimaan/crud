import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'Timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('Timestamp', descending: true).snapshots();
  }

  Future<void> updateNotes(String docId, String newNotes) {
    return notes.doc(docId).update({
      'note': newNotes,
      'Timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteNotes({required String docID}) {
    return notes.doc(docID).delete();
  }
}
