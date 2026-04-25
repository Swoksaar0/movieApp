class LocalMovie {
  final int? id;
  final String title;
  final String genre;

  LocalMovie({this.id, required this.title, required this.genre});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
    };
  }

  factory LocalMovie.fromMap(Map<String, dynamic> map) {
    return LocalMovie(
      id: map['id'],
      title: map['title'],
      genre: map['genre'],
    );
  }
}

class CloudReview {
  final String? id;
  final String movieTitle;
  final String reviewText;

  CloudReview({this.id, required this.movieTitle, required this.reviewText});

  Map<String, dynamic> toMap() {
    return {
      'movieTitle': movieTitle,
      'reviewText': reviewText,
    };
  }

  factory CloudReview.fromFirestore(String id, Map<String, dynamic> data) {
    return CloudReview(
      id: id,
      movieTitle: data['movieTitle'] ?? '',
      reviewText: data['reviewText'] ?? '',
    );
  }
}