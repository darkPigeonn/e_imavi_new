class ModelUser {
  late String fullName, email, jabatan;

  ModelUser(
      {required this.fullName, required this.email, required this.jabatan});

  factory ModelUser.fromJson(Map<String, dynamic> json) {
    return new ModelUser(
        fullName: json['fullName'],
        email: json['email'],
        jabatan : json['jabatan']
     );
  }
}
