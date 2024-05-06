from rest_framework import serializers
from .models import User
from .profile import UserProfile
from users.forms import ProfileForm

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'

    def create(self, validated_data):
        user = User(
            email=validated_data['email'],
            username=validated_data['username']
        )
        user.set_password(validated_data['password'])
        user.save()
        return user
    
class BasicInfoUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('username','first_name','last_name','battles','questions', 'friends', 'email', 'date_of_birth', 'location', 'photo_url')

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = '__all__'

class UserProfileForm(serializers.ModelSerializer):
    class Meta:
        model = ProfileForm
        fields = '__all__'