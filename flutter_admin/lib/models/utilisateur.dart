class Utilisateur {
  final int id;
  final String nomUtilisateur;
  final String mdp;

  const Utilisateur({
    required this.id,
    required this.nomUtilisateur,
    required this.mdp,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomUtilisateur': nomUtilisateur,
      'mdp': mdp,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, nomUtilisateur: $nomUtilisateur, mdp: $mdp}';
  }
}
