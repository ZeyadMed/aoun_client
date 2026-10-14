import 'package:equatable/equatable.dart';
import 'statement_model.dart';

class StatementsModel extends Equatable {
  final List<StatementModel> statements;

  const StatementsModel({required this.statements});

  factory StatementsModel.fromJson(List<dynamic> json) => StatementsModel(
    statements: (json)
        .whereType<Map<String, dynamic>>()
        .map(StatementModel.fromJson)
        .toList(),
  );

  @override
  List<Object?> get props => [statements];
}
