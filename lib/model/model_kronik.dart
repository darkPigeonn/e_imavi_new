class KronikModel {
  String? subject, character, type, concerns;
  String? content, createdAt, createdBy, title;

  KronikModel(
      {this.title,
      this.subject,
      this.character,
      this.type,
      this.concerns,
      this.content,
      this.createdAt,
      this.createdBy});

  factory KronikModel.fromJson(Map<String, dynamic> json) {
    return new KronikModel(
        title: json['title'],
        subject: json['subject'],
        character: json['character'],
        type: json['type'],
        concerns: json['concern'],
        content: json['content'],
        createdAt: json['createdAt'],
        createdBy: json['createdBy']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = title;
    data['subject'] = subject;
    data['characterActivities'] = character;
    data['type'] = type;
    data['concern'] = concerns;
    data['createdAt'] = createdAt;
    data['createdBy'] = createdBy;
    return data;
  }
}
