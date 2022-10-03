class PermitModel {
  late String createdAt;
  late int status;
  late String reason;
  late String startDatePermit;
  late String endDatePermit;

  PermitModel({
    required this.createdAt,
    required this.status,
    required this.reason,
    required this.startDatePermit,
    required this.endDatePermit
  });

  factory PermitModel.fromJson(Map<String, dynamic> json) {
    return new PermitModel(
      createdAt : json["createdAt"],
      status : json['status'],
      reason : json['reason'],
      startDatePermit : json['startDatePermit'],
      endDatePermit : json['endDatePermit']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic> ();

    data['createdAt'] = createdAt;
    data['status'] = status;
    data['reason'] = reason;
    data['startDatePermit'] = startDatePermit;
    data['endDatePermit'] = endDatePermit;
    return data;
  }
}