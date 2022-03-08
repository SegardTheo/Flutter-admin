class Utilisateur {
  final int? id;
  final String nomUtilisateur;
  final String mdp;
  final int? dossierId;

  const Utilisateur({
    required this.nomUtilisateur,
    required this.mdp,
    this.id,
    this.dossierId
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomUtilisateur': nomUtilisateur,
      'mdp': mdp,
    };
  }
  Map<String, dynamic> toMapInsert() {
    return {
      'nomUtilisateur': nomUtilisateur,
      'mdp': mdp,
      'dossierId': dossierId,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, nomUtilisateur: $nomUtilisateur, mdp: $mdp}';
  }
}
