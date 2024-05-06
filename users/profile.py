from django.db import models
from users.models import User
from django.utils.translation import gettext_lazy as _


# Create your models here.
class UserProfile(models.Model):
    '''
    this represents userProfile
    '''
    CATEGORIES = ('interests', 'bio', 'favorite_movie')


    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
    # profile_picture = models.ImageField(_('Profile Picture'), upload_to='media/images', blank=True, null=True)
    #location = models.CharField(_('Location'), max_length=255, blank=True)
    age = models.IntegerField(_('Age'), blank=True, null=True)
    #username = models.CharField(_('Username'), max_length=50, unique=True, null=True)
    bio = models.TextField(blank=True, null=True)

    image1 = models.FileField(null=False, blank=True,upload_to='media/images')
    image2 = models.FileField(null=False, blank=True,upload_to='media/images')
    image3 = models.FileField(null=False, blank=True,upload_to='media/images')
    image4 = models.FileField(null=False, blank=True,upload_to='media/images')
    image5 = models.FileField(null=False, blank=True,upload_to='media/images')
    image6 = models.FileField(null=False, blank=True,upload_to='media/images')
   
    # Prompts
    # Personalized Tags or Labels
    #interests = models.ManyToManyField('Interest', verbose_name=_('Interests'), blank=True)
    # personality_traits = models.ManyToManyField('PersonalityTrait', verbose_name=_('Personality Traits'), blank=True)

    # Fun Facts
    favorite_quote = models.TextField(_('Favorite Quote'), blank=True)
    pet_peeves = models.TextField(_('Pet Peeves'), blank=True)
    dream_destination = models.CharField(_('Dream Travel Destination'), max_length=255, blank=True)

    # Friendship Insights
    how_we_met = models.TextField(_('How We Met'), blank=True)
    memorable_moments = models.TextField(_('Memorable Moments'), blank=True)
    #shared_interests_with_friend = models.ManyToManyField('Interest', verbose_name=_('Shared Interests with Friend'), blank=True)

    # Personal Details
    #date_of_birth = models.DateField(null=True, blank=True)
    
   
    interests = models.CharField(max_length=200, blank=True, null=True)
    personality_traits = models.CharField(max_length=200, blank=True, null=True)
    #shared_interests_with_friend = models.CharField(max_length=200, blank=True, null=True)
    #interests = models.CharField(max_length=200, blank=True, null=True)
    #interests = models.CharField(max_length=200, blank=True, null=True)
    # Favorite Things
    favorite_movie = models.CharField(max_length=200, blank=True, null=True)
    favorite_book = models.CharField(max_length=200, blank=True, null=True)
    favorite_food = models.CharField(max_length=200, blank=True, null=True)

    # Additional Fields
    virtues = models.TextField(blank=True, null=True)
    vices = models.TextField(blank=True, null=True)
    anecdote = models.TextField(blank=True, null=True)

    created_at = models.DateTimeField(auto_now_add=True, null=True)

# class Interest(models.Model):
#     '''
#     Represents user interests.
#     '''
#     name = models.CharField(_('Interest Name'), max_length=255)

#     def __str__(self):
#         return self.name

# class PersonalityTrait(models.Model):
#     '''
#     Represents user personality traits.
#     '''
#     name = models.CharField(_('Personality Trait'), max_length=255)

#     def __str__(self):
#         return self.name

class SocialProfile(models.Model):
    '''
    Represents user's social media profiles.
    '''
    platform = models.CharField(_('Platform'), max_length=50)
    username = models.CharField(_('Username'), max_length=100)

    def __str__(self):
        return f'{self.platform} - {self.username}'

class Achievement(models.Model):
    '''
    Represents user achievements.
    '''
    name = models.CharField(_('Achievement Name'), max_length=255)

    def __str__(self):
        return self.name

class GameAchievement(models.Model):
    '''
    Represents user achievements in games.
    '''
    name = models.CharField(_('Game Achievement Name'), max_length=255)

    def __str__(self):
        return self.name
