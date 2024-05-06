from django.shortcuts import render
from rest_framework import generics, status
from rest_framework.response import Response

from rest_framework.generics import GenericAPIView

from users.models import User
from .models import Question, Battle, UserGameResult

from .serializers import QuestionSerializer, BattleSerializer, UserGameResultSerializer
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404
import random

# Create your views here.


class QuestionList(generics.ListCreateAPIView):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer

    def delete(self, request, *args, **kwargs):
        Question.objects.all().delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class QuestionRetrieveUpdateDestroy(GenericAPIView):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer
    lookup_field = 'created_by'
    
    def get_queryset(self):
        user_id = self.kwargs.get(self.lookup_field)
        user = User.objects.get(id=user_id)
        return Question.get_questions_by_user(user)

    def get(self, request, *args, **kwargs):
        questions = self.get_queryset()
        serializer = self.get_serializer(questions, many=True)
        return Response(serializer.data)


9
class QuestionManager(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        question_id = request.query_params.get('id')
        if not question_id:
            user_questions = Question.objects.filter(created_by = user)
            return Response(QuestionSerializer(user_questions, many = True).data, status.HTTP_200_OK)
        else:
            question = get_object_or_404(Question, pk = question_id, created_by = user)
            serializer = QuestionSerializer(question)
            return Response(serializer.data, status.HTTP_200_OK)
    
    def post(self, request):
        # Creating question from client's side
        user = request.user #get authenticated user

        question_data = request.data
        question_data['created_by'] = user.id
        serializer = QuestionSerializer(data=question_data)

        if serializer.is_valid():
            serializer.save()
            return Response({'message':f'Question created for {user.username}'}, status.HTTP_201_CREATED)
        return Response(serializer.errors(), status.HTTP_400_BAD_REQUEST)
        
    def put(self, request):
        user = request.user

        question_id = request.data.get('id')
        question = get_object_or_404(Question, pk = question_id, created_by = user)
        serializer = QuestionSerializer(question, data = request.data, partial = True)

        if serializer.is_valid():
            serializer.save()
            return Response({'message':'Question updated successfully'}, status.HTTP_200_OK)
        return Response(serializer.errors, status.HTTP_400_BAD_REQUEST)

    def delete(self, request):
        user = request.user

        question_id = request.data.get('id')
        question = get_object_or_404(Question, pk = question_id, created_by = user)
        question.delete()

        return Response({'message':'Question deleted'}, status.HTTP_200_OK)
    
class RetrieveRandomQuestionsUsingUserID(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        uid = request.data.get('uid')
        number_of_questions = request.data.get('number_of_questions')
        targetUser = get_object_or_404(User, pk = uid)

        user_questions = Question.objects.filter(created_by = targetUser)


        if user_questions.count() < number_of_questions:
            return Response({
                'error': 'Not enough questions available.'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        random_questions = random.sample(list(user_questions), number_of_questions)

        # Serialize the random questions
        serializer = QuestionSerializer(random_questions, many=True)

        return Response(serializer.data, status=status.HTTP_200_OK)





class UserGameResultList(generics.ListCreateAPIView):
    queryset = UserGameResult.objects.all()
    serializer_class = UserGameResultSerializer

    def delete(self, request, *args, **kwargs):
        UserGameResult.objects.all().delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class UserGameResultRetrieveUpdateDestroy(generics.RetrieveUpdateDestroyAPIView):
    queryset = UserGameResult.objects.all()
    serializer_class = UserGameResultSerializer
    lookup_field = 'pk'

class UserGameResultManager(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        game_result_id = request.data.get('id')
        if not game_result_id:
            user_game_results = UserGameResult.objects.filter(user = user)
            serializer = UserGameResultSerializer(user_game_results, many = True)
            return Response(serializer.data, status.HTTP_200_OK)
        else:
            user_game_specific_result = get_object_or_404(UserGameResult, user = user, pk = game_result_id)
            serializer = UserGameResultSerializer(user_game_specific_result)
            return Response(serializer.data, status.HTTP_200_OK)
    
    def post(self, request):
        user = request.user

        userGameResultData = request.data

        # get the partner instance
        partner_id = userGameResultData.get('partner_id')
        partner = get_object_or_404(User, id = partner_id)

        # get the questions instance
        question_ids = list(userGameResultData.get('question_ids', []))
        questions = list(Question.objects.filter(id__in = question_ids).values_list('id', flat=True))
        # get the correct questions instance
        correct_questions_ids = list(userGameResultData.get('correct_question_ids', []))
        correct_questions =  list(Question.objects.filter(id__in = correct_questions_ids).values_list('id', flat=True))

        # get the score
        score = userGameResultData.get('score')

        data_to_validate = {
            "user": user.id,
            "partner": partner.id,
            "questions": questions,
            "correct_questions": correct_questions,
            "score": score
        }
        serializer = UserGameResultSerializer(data=data_to_validate)
        # data validation
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status.HTTP_400_BAD_REQUEST)

    def delete(self, request, **kwargs):
        user = request.user

        user_result_to_delete_id = request.data.get("usergameresult_id")

        user_result_to_delete = get_object_or_404(UserGameResult, user=user, pk = user_result_to_delete_id)

        user_result_to_delete.delete()

        return Response({'message':'UserGameresult deleted'}, status.HTTP_200_OK)








class BattleList(generics.ListCreateAPIView):
    queryset = Battle.objects.all()
    serializer_class = BattleSerializer

    def delete(self, request, *args, **kwargs):
        Battle.objects.all().delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class BattleRetrieveUpdateDestroy(generics.RetrieveUpdateDestroyAPIView):
    queryset = Battle.objects.all()
    serializer_class = BattleSerializer
    lookup_field = 'pk'

class BattleManager(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        battle_id = request.query_params.get('id')
        if not battle_id:
            battles = Battle.objects.all()
            return Response(BattleSerializer(battles, many = True).data, status.HTTP_200_OK)
        else:
            battle = get_object_or_404(Battle, pk = battle_id)
            serializer = BattleSerializer(battle)
            return Response(serializer.data, status.HTTP_200_OK)
        
    def post(self, request, **kwarg):
        
        battle_data = request.data

        serializer = BattleSerializer(data=battle_data)

        if serializer.is_valid():
            newBattle = serializer.save()
            newBattleData = serializer.data
            # save the newly created battle into the user game result
            for result in newBattleData['stats']:
                userGameResult = UserGameResult.objects.get(pk = result)
                userGameResult.battle = newBattle
                userGameResult.save()
            return Response(newBattleData, status.HTTP_201_CREATED)

        return Response(serializer.errors, status.HTTP_201_CREATED)

class BattleManagerForGet(APIView):
    permission_classes = [IsAuthenticated]
    # Get battles that user participated
    def get(self, request):
        user = request.user
        battles = []
        userResults = list(UserGameResult.objects.filter(user=user))
        if not userResults:
            return Response(status.HTTP_404_NOT_FOUND)
        for result in userResults:
            battle = result.battle.id
            if battle:
                battles.append(battle)
        
        
        return Response({'battles':battles}, status.HTTP_200_OK)

    