import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:vincia/modules/question/interfaces/iquestion_service.dart';
import 'package:vincia/modules/question/model/question_model.dart';
import 'package:vincia/modules/question/page/controller/states/question_states.dart';
import 'package:vincia/shared/model/failure_model.dart';

part 'question_controller.g.dart';

class QuestionController = _QuestionController with _$QuestionController;

abstract class _QuestionController with Store {
  final IQuestionService _questionService;

  Timer? timeWatcher;

  @observable
  Duration duration = const Duration(seconds: 0);

  @observable
  QuestionModel? question;

  @observable
  QuestionState state = InitialState();

  _QuestionController(this._questionService);

  @computed
  String get time {
    final value = duration.toString().split(':');
    return "${value[1]}:${value[2].split('.').first}";
  }

  @action
  Future<void> init() async {
    state = InitialState();
    question = null;
    duration = const Duration(seconds: 0);
    timeWatcher?.cancel();
    var result = await _questionService.getQuestion();
    if (result.isRight()) {
      question = (result as Right).value;
    }
    if (result.isLeft()) {
      FailureModel value = (result as Left).value;
      state = FailureState(value);
    }
    timeWatcher = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration += const Duration(seconds: 1);
    });
  }

  @action
  void answerQuestion(alternativeId) {
    if (state is InitialState) {
      timeWatcher?.cancel();
      _questionService.sendAnswerQuestion(alternativeId, duration);
      if (alternativeId == question!.answer) {
        state = AnsweredQuestionState(true, alternativeId);
      } else {
        state = AnsweredQuestionState(false, alternativeId);
      }
    }
  }
}
