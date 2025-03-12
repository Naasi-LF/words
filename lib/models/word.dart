class Word {
  final int? id;
  final String word;
  final String meaning;
  final int lessonId;

  Word({this.id, required this.word, required this.meaning, required this.lessonId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'lessonId': lessonId,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],
      word: map['word'],
      meaning: map['meaning'],
      lessonId: map['lessonId'],
    );
  }
}