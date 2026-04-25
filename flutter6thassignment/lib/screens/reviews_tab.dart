import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_models.dart';
import '../services/firestore_service.dart';

class ReviewsTab extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  void _showAddReviewDialog(BuildContext context) {
    final movieController = TextEditingController();
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Movie Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: movieController, decoration: InputDecoration(labelText: 'Movie Title')),
            TextField(controller: reviewController, decoration: InputDecoration(labelText: 'Review')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (movieController.text.isNotEmpty && reviewController.text.isNotEmpty) {
                await _firestoreService.addReview(CloudReview(
                  movieTitle: movieController.text,
                  reviewText: reviewController.text,
                ));
                Navigator.pop(context);
              }
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getReviewsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No reviews yet.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final review = CloudReview.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(review.movieTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(review.reviewText),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReviewDialog(context),
        child: Icon(Icons.rate_review),
      ),
    );
  }
}