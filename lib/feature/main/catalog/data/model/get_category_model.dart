import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'get_category_model.g.dart';

@HiveType(typeId: 5)
class GetCategoryModel extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  const GetCategoryModel({required this.id, required this.name});

  factory GetCategoryModel.fromJson(Map<String, dynamic> json) {
    return GetCategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  List<Object?> get props => [id, name];
}
