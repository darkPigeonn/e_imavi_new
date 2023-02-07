class ModelUser {
  late String id, fullName, email, jabatan;

  ModelUser(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.jabatan});

  factory ModelUser.fromJson(Map<String, dynamic> json) {
    return new ModelUser(
        fullName: json['fullName'],
        email: json['email'],
      jabatan: json['jabatan'],
      id: json['_id'],
     );
  }
}
