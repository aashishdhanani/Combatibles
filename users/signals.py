from django.db.models.signals import post_save
from django.dispatch import receiver
from users.generateQuestions import generateQuestions
from trophies.models import Trophy
from trophies.serializers import TrophySerializer
from .models import User
from .profile import UserProfile

@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        UserProfile.objects.create(user=instance)


# Checking for trophies available whenever the user's record being updated
@receiver(post_save, sender = User)
def award_trophies(sender, instance, raw, **kwargs):
    user = instance
    if user.friends.count() >= 1:
        trophy = Trophy.objects.get(name = "Social Butterfly")
        trophy.users.add(user)
    if 5 <= user.questions.count() < 20 :
        trophy = Trophy.objects.get(name = "Question Crafter")
        trophy.users.add(user)
    if user.questions.count() >= 20:
        trophy = Trophy.objects.get(name = "The Curator")
        trophy.users.add(user)
