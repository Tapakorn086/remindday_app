class Group {
  final int id; 
  final String name;
  final String description;
  final String referralCode;
  final int ownerId;

  Group({
    required this.id,
    required this.name,
    this.description = '',
    required this.referralCode,
    required this.ownerId,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as int, 
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      referralCode: json['referralCode'] as String,
      ownerId: json['ownerId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'referralCode': referralCode,
      'ownerId': ownerId,
    };
  }

  Group copyWith({
    int? id, 
    String? name,
    String? description,
    String? referralCode,
    int? ownerId,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      referralCode: referralCode ?? this.referralCode,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  @override
  String toString() {
    return 'Group(id: $id, name: $name, description: $description, referralCode: $referralCode, ownerId: $ownerId)';
  }
}