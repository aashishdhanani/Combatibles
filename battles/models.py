from django.db import models
from users.models import User
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _

class Question(models.Model):
    """
    This model represents a question in the application.
    """
    created_by = models.ForeignKey(User,on_delete=models.PROTECT, related_name='created_questions',null=False, blank=False)
    question_content = models.TextField()
    answer = models.CharField(max_length=255)
    wrong_answers = models.CharField(max_length=1000, blank=True)  # Comma separated string of wrong answers
    time_created = models.DateTimeField(auto_now_add=True)

    def get_questions_by_user(user):
        return Question.objects.filter(created_by=user)

class UserGameResult(models.Model):
    """
    This model stores individual user results for each battle.
    """
    user = models.ForeignKey(User, on_delete=models.PROTECT, related_name='game_results', null=False, blank=False)
    partner = models.ForeignKey(User, on_delete=models.PROTECT, related_name='partner_results', null=False, blank=False)
    battle = models.ForeignKey('battles.Battle', on_delete=models.PROTECT, related_name='game_results', null=True, blank=True)
    questions = models.ManyToManyField(Question, related_name='game_results')
    correct_questions = models.ManyToManyField(Question, related_name='correctly_answered_by', blank=True)
    score = models.IntegerField()
    time_created = models.DateTimeField(auto_now_add=True)



class Battle(models.Model):
    """
    This model represents a battle session between two pairs of users.
    """
    stats = models.ManyToManyField(UserGameResult, related_name='battles')
    questions = models.ManyToManyField(Question, related_name='battles', blank=True)
    winners = models.ManyToManyField(User, related_name='battles_won')
    location_happened = models.CharField(max_length=255, blank=True)
    winner_score = models.IntegerField()
    time_created = models.DateTimeField(auto_now_add=True)
