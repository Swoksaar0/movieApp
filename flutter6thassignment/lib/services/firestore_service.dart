import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addReview(CloudReview review) async {
    await _db.collection('reviews').add(review.toMap());
  }

  Stream<QuerySnapshot> getReviewsStream() {
    return _db.collection('reviews').snapshots();
  }
}