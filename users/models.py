from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    """
    This model represents a user in the application.
    """
    email = models.EmailField(unique=True, blank=False)
    date_of_birth = models.DateField(blank=True, null=True)
    battles = models.ManyToManyField('battles.Battle', through='battles.UserGameResult', through_fields=('user', 'battle'))
    questions = models.ManyToManyField('battles.Question', related_name='users_answered',blank=True)
    friends = models.ManyToManyField('self', blank=True)
    # active_status = models.BooleanField(default=True) # handle user deletion (NO NEEDED SINCE ABSTRACTUSER ALREADY HAVE THIS)
    location = models.CharField(max_length=255, blank=True)   
    photo_url = models.URLField(blank=True)
    time_created = models.DateTimeField(auto_now_add=True)
