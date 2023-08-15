from flask import jsonify, request, session
from app import app
from app.services.question_service import QuestionService
from app.domain.errors.api_exception import ApiException
from app.controllers.base_controller import *
from app.decorator.requires_auth import requires_auth
from app.repositories.question_repository import QuestionsRepository
from app.repositories.history_of_questions_repository import HistoryOfQuestionsRepository
from app.repositories.abilities_rating_repository import AbilitiesRatingRepository
from app.repositories.ability_repository import AbilityRepository
from app.repositories.history_of_user_rating_update_repository import HistoryOfUserRatingUpdateRepository
from app.repositories.history_of_question_rating_update_repository import HistoryOfQuestionRatingUpdateRepository
from app import connection_pool


@app.route("/api/question/<string:id>", methods=["GET"])
def get_question_teste(id):
        #question = QuestionDAO().get_question_by_id(id)
        return success_api_response(data="question.to_json()")

@app.route("/api/question", methods=["GET"], endpoint="question")
@requires_auth(None)
def get_question(): 
        connection = connection_pool.get_connection()
        questions_repository = QuestionsRepository(connection)
        history_question_repository = HistoryOfQuestionsRepository(connection)
        abilities_rating_repository = AbilitiesRatingRepository(connection)
        abilities_repository = AbilityRepository(connection)
        history_of_user_rating_update_repository = HistoryOfUserRatingUpdateRepository(connection)
        history_of_question_rating_update_repository = HistoryOfQuestionRatingUpdateRepository(connection)
        service = QuestionService(questions_repository, history_question_repository, abilities_rating_repository, abilities_repository, history_of_user_rating_update_repository, history_of_question_rating_update_repository)
        
        user_id = session.get('current_user').get('sub')
        response = service.get_question(user_id)
        
        connection_pool.release_connection(connection)
        return success_api_response(data=response)

    
@app.route("/api/question/answer", methods=["POST"], endpoint="question/answer")
@requires_auth(None)
def post_answer(): 
        connection = connection_pool.get_connection()
        questions_repository = QuestionsRepository(connection)
        history_question_repository = HistoryOfQuestionsRepository(connection)
        abilities_rating_repository = AbilitiesRatingRepository(connection)
        abilities_repository = AbilityRepository(connection)
        history_of_user_rating_update_repository = HistoryOfUserRatingUpdateRepository(connection)
        history_of_question_rating_update_repository = HistoryOfQuestionRatingUpdateRepository(connection)
        service = QuestionService(questions_repository, history_question_repository, abilities_rating_repository, abilities_repository, history_of_user_rating_update_repository, history_of_question_rating_update_repository)
        
        user_id = session.get('current_user').get('sub')
        data = request.get_json()
        answer = data.get('answer')
        duration = data.get('duration')
        history_question_id = data.get('historyQuestionId')
        
        response = service.insert_question_answer(history_question_id, user_id, answer, duration)
        connection_pool.release_connection(connection)
        return success_api_response(data=response)