import 'package:equatable/equatable.dart';
import 'package:quiz_app_flutter/features/data/model/answer_model/answer_model.dart';

class AnswerEntity extends Equatable {
  final String name;
  final bool isCorrect;

  const AnswerEntity({
    required this.name,
    required this.isCorrect,
  });

  factory AnswerEntity.fromModel(AnswerModel model) {
    return AnswerEntity(
      name: model.name ?? '',
      isCorrect: model.correct ?? false,
    );
  }

  @override
  List<Object?> get props => [
    name,
    isCorrect,
  ];
}