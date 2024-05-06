from rest_framework import serializers
from .models import Question, UserGameResult, Battle



class QuestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Question
        fields = '__all__'

class UserGameResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserGameResult
        fields = '__all__'

    def validate(self, data):
        # Validating same user and partner
        user = data.get('user')
        partner = data.get('partner')
        if user == partner:
            raise serializers.ValidationError("User and partner cannot be the same.")
        questions = data.get('questions')
        for q in questions:
            if q.created_by != partner:
                raise serializers.ValidationError(f'Question id:{q.id} was not created by the partner')
        correctQuestions = data.get('correct_questions')
        for cq in correctQuestions:
            if cq.created_by != partner:
                raise serializers.ValidationError(f'Correct question id:{cq.id} was not created by the partner')
            if cq not in questions:
                raise serializers.ValidationError(f'Correct question id:{cq.id} is not in the problem set')
        return data

class BattleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Battle
        fields = '__all__'
    
    def validate(self, data):
        # "stats": [],
        # "questions": [],
        # "winners":[],
        # "location_happened": [],
        # "winner_score":69
        userStats = data.get('stats')
        if len(set(userStats))!= 4:
            raise serializers.ValidationError("4 UserGameResults required.")
        
        winners = data.get('winners')
        if len(set(winners))!= 2:
            raise serializers.ValidationError("There's should be 2 winners.")
        
        users = set()
        for stat in userStats:
            users.add(stat.user)
        winnersCount = 0
        for w in winners:
            if w in users: winnersCount += 1
        if winnersCount != 2: raise serializers.ValidationError("Either some winners are not in the Result or not enough 2 winners")
        
        # Adding questions based on the user stats (game result)
        questions_validator = []
        for result in list(userStats):
            questions_validator += list(result.questions.all())
        data['questions'] = questions_validator
            

        return data