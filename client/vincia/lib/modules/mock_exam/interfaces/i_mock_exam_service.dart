import 'package:dartz/dartz.dart';
import 'package:vincia/modules/mock_exam/model/mock_exam_answer_model.dart';
import 'package:vincia/modules/mock_exam/model/mock_exam_question_model.dart';
import 'package:vincia/shared/model/failure_model.dart';
import 'package:vincia/shared/model/success_model.dart';

abstract class IMockExamService {
  Future<String> getUserId();
  Future<String> getAcessToken();
  Future<Either<FailureModel, List<List<MockExamQuestionModel>>>> getQuestionsFromAPI();
  Future<Either<FailureModel, List<List<MockExamQuestionModel>>>> getQuestions();
  // Future<Either<FailureModel, MockExamAreasModel>> saveQuestionState(MockExamQuestionModel question, MockExamAnswerModel answer);
  Future<Either<FailureModel, SuccessModel>> sendMockExamAnswer(List<MockExamAnswerModel> answer);
}