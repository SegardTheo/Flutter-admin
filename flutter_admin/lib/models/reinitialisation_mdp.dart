class ReinitialisationMdp {
  final int? id;
  final String code;
  final String email;

  const ReinitialisationMdp({
    required this.code,
    required this.email,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'email': email
    };
  }
  Map<String, dynamic> toMapInsert() {
    return {
      'code': code,
      'email': email
    };
  }
}
