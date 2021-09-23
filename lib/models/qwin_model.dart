import 'dart:convert';

class showqwinModel {
  final String winnum;
  final String name;
  final String avatar;
  showqwinModel({
    required this.winnum,
    required this.name,
    required this.avatar,
  });

  showqwinModel copyWith({
    String? winnum,
    String? name,
    String? avatar,
  }) {
    return showqwinModel(
      winnum: winnum ?? this.winnum,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'winnum': winnum,
      'name': name,
      'avatar': avatar,
    };
  }

  factory showqwinModel.fromMap(Map<String, dynamic> map) {
    return showqwinModel(
      winnum: map['winnum'],
      name: map['name'],
      avatar: map['avatar'],
    );
  }

  String toJson() => json.encode(toMap());

  factory showqwinModel.fromJson(String source) =>
      showqwinModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'showqwinModel(winnum: $winnum, name: $name, avatar: $avatar)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is showqwinModel &&
        other.winnum == winnum &&
        other.name == name &&
        other.avatar == avatar;
  }

  @override
  int get hashCode => winnum.hashCode ^ name.hashCode ^ avatar.hashCode;
}
