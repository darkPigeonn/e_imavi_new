class ModelAttendances {
  late String date, checkIn, checkOut, flag;

  ModelAttendances(
      {required this.date, required this.checkIn, required this.checkOut});

  factory ModelAttendances.fromJson(Map<String, dynamic> json) {
    return new ModelAttendances(
        date: json['date'],
        checkIn: json['checkIn'],
        checkOut: json['checkOut']);
  }
}
class ModelResources1 {
  late String title, content, excerpt, publishDate, author, slug, imageLink;

  ModelResources1(
      {required this.title,
      required this.content,
      required this.excerpt,
      required this.publishDate,
      required this.author,
      required this.slug,
      required this.imageLink});

  factory ModelResources1.fromJson(Map<String, dynamic> json) {
    String imageUrl = 'kosong';
    final imageLinkApi = json['imageLink'];

    if (!imageLinkApi.toString().isEmpty) {
      imageUrl = json['imageLink'];
    }

    return new ModelResources1(
        title: json['title'],
        content: json['content'],
        excerpt: json['excerpt'],
        publishDate: json['publishDate'],
        author: json['author'],
        slug: json['slug'],
        imageLink: imageUrl);
  }
}
