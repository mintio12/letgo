import 'dart:convert';

class countQModel {
  final String winnum;
  countQModel({
    required this.winnum,
  });

  countQModel copyWith({
    String? winnum,
  }) {
    return countQModel(
      winnum: winnum ?? this.winnum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'winnum': winnum,
    };
  }

  factory countQModel.fromMap(Map<String, dynamic> map) {
    return countQModel(
      winnum: map['winnum'],
    );
  }

  String toJson() => json.encode(toMap());

  factory countQModel.fromJson(String source) =>
      countQModel.fromMap(json.decode(source));

  @override
  String toString() => 'countQModel(winnum: $winnum)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is countQModel && other.winnum == winnum;
  }

  @override
  int get hashCode => winnum.hashCode;
}
