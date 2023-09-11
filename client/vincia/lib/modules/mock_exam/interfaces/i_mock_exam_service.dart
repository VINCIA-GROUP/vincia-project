import 'package:dartz/dartz.dart';
import 'package:vincia/modules/mock_exam/model/mock_exam_areas_model.dart';
import 'package:vincia/shared/model/failure_model.dart';
import 'package:vincia/shared/model/success_model.dart';

abstract class IMockExamService {
  Future<String> getUserId();
  Future<String> getAcessToken();
  Future<Either<FailureModel, MockExamAreasModel>> getQuestions();
  Future<Either<FailureModel, SuccessModel>> sendMockExamAnswer();
}