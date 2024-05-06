import json
from django.http import HttpResponse
from django.shortcuts import render, redirect, get_object_or_404
import openai
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import User
from .serializers import UserSerializer, UserProfileSerializer, ProfileForm, BasicInfoUserSerializer
from rest_framework.authtoken.models import Token
from rest_framework.permissions import IsAuthenticated
from .profile import UserProfile
from .prelimPrompt import rizz
from django.utils.encoding import force_str
from users.generateQuestions import generateQuestions



# Create your views here.


class UserList(generics.ListCreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    def delete(self, request, *args, **kwargs):
        User.objects.all().delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class UserRetrieveUpdateDestroy(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    lookup_field = 'pk'


class CreateUser(APIView):
    def post(self, request, **args):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            try:
                user = serializer.save()
                token, created = Token.objects.get_or_create(user=user)
                return Response(
                    {
                        "token": token.key,
                        "user_id": user.pk,
                        "username": user.username,
                    }, 
                    status=status.HTTP_201_CREATED)
            except Exception as e:
                return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(serializer.errors, status.HTTP_409_CONFLICT)
        

class UserUpdate(APIView):
    permission_classes = [IsAuthenticated]  
    def get(self, request, **args):     
        #to be implemented to get access token using refresh token
        user = request.user
        user_data = BasicInfoUserSerializer(user).data
        return Response(user_data, status.HTTP_200_OK)


    def put(self, request, **args):
        user = request.user
        # Create a serializer instance with the user instance and request data
        # and set partial=True for partial updates
        serializer = UserSerializer(user, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response({'message':'User information updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    def delete(self, request, **args):
        user = request.user
        user.delete()
        return Response({'message': 'User deleted successfully'}, status=status.HTTP_204_NO_CONTENT)

    
class UserUpdateFirstName(APIView):
    permission_classes = [IsAuthenticated]
    def put(self,request):
        user = request.user
        body = request.data
        # check the body only contains the changeing field
        if len(body)>1 or 'first_name' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserSerializer(user, data=body, partial = True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'User first_name updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class UserUpdateLastName(APIView):
    permission_classes = [IsAuthenticated]
    def put(self,request):
        user = request.user
        body = request.data
        # check the body only contains the changeing field
        if len(body)>1 or 'last_name' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserSerializer(user, data=body, partial = True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'User last_name updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UserUpdateDateOfBirth(APIView):
    permission_classes = [IsAuthenticated]
    def put(self,request):
        user = request.user
        body = request.data
        # check the body only contains the changeing field
        if len(body)>1 or 'date_of_birth' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserSerializer(user, data=body, partial = True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'User date_of_birth updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UserUpdatePhotoUrl(APIView):
    permission_classes = [IsAuthenticated]
    def put(self,request):
        user = request.user
        body = request.data
        # check the body only contains the changeing field
        if len(body)>1 or 'photo_url' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserSerializer(user, data=body, partial = True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'User photo_url updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UserUpdateLocation(APIView):
    permission_classes = [IsAuthenticated]
    def put(self,request):
        user = request.user
        body = request.data
        # check the body only contains the changeing field
        if len(body)>1 or 'location' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserSerializer(user, data=body, partial = True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'User location updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# Add Friend
class UserAddFriend(APIView):
    permission_classes = [IsAuthenticated]

    def put(self, request, *args):
        user = request.user
        friend_id = request.data.get('id')
        friend = get_object_or_404(User, pk=friend_id)
        if user == friend:
            return Response({'message':'You cannot add yourself as a friend'}, status.HTTP_400_BAD_REQUEST)
        # Check if friend request already exists (optional)
        # existing_request = FriendRequest.objects.filter(from_user=user, to_user=friend).exists()
        # if existing_request:
        #     return Response({'message': 'Friend request already sent'}, status=status.HTTP_400_BAD_REQUEST)

        # Add friend to user's friend list (one-way for now)
        user.friends.add(friend)
        user.save()
        # Consider adding a friend request model (optional)
        # friend_request = FriendRequest.objects.create(from_user=user, to_user=friend)

        #  Consider adding a two-way friendship (optional)
        # friend.friends.add(user)
        # friend.save()
        return Response({'message': 'Friend added successfully'}, status=status.HTTP_200_OK)


#Profile prompt testing
class ProfileDetailList(generics.ListCreateAPIView):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer

class UserProfileRetrieveUpdateDestroy(generics.RetrieveUpdateDestroyAPIView):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    lookup_field = 'pk'

# def prompt_view(request, pk):
#     user_profile = get_object_or_404(UserProfile, pk=pk)
   
#     if request.method == 'POST':
#         form = ProfileForm(request.POST, instance=user_profile)
#         if form.is_valid():
#             print(form.cleaned_data)
#             instance = form.save(commit=False)
#             instance.category_for_prompt_1 = form.cleaned_data['interests']
#             instance.category_for_prompt_2 = form.cleaned_data['bio']
#             instance.category_for_prompt_3 = form.cleaned_data['favorite_movie']
#             instance.save()
#             return redirect('user-profile-detail', pk=pk)  # Redirect to the user profile view with the updated profile
#         else:
#             print(form.errors)
#     else:
#         form = ProfileForm(instance=user_profile)
#     return render(request, 'prompt.html', {'form': form})

#endpoints for user profile deployment
#already have get, and post (bc profile is auto created once user registers)

#PUT - changing all data 
class UserProfileUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request, **args):
        user = request.user
        body = request.data
        #print(body)
        userProfile = get_object_or_404(UserProfile, user = user)
        serializer = UserProfileSerializer(userProfile, data=body, partial=True)
        if serializer.is_valid():
            print(serializer.validated_data)
            serializer.save()
            generateQuestions(request, serializer.validated_data)
            return Response({'message':'User profile updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
#PUT - age
class UserProfileAgeUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'age' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile age updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#PUT - bio
class UserProfileBioUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'bio' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile bio updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - favorite_quote
class UserProfileQuoteUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'favorite_quote' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile favorite_quote updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - pet_peeves
class UserProfilePeevesUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'pet_peeves' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile pet peeves updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - dream_destination
class UserProfileDestinationUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'dream_destination' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile dream_destination updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - how_we_met
class UserProfileMeetUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'how_we_met' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile how_we_met updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - memorable_moments
class UserProfileMomentsUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'memorable_moments' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile memorable_moments updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - interests
class UserProfileInterestsUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'interests' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile interests updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - favorite_movie
class UserProfileMovieUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'favorite_movie' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile favorite_movie updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - favorite_book
class UserProfileBookUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'favorite_book' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile favorite_book updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - favorite_food
class UserProfileFoodUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'favorite_food' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile favorite_food updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - virtues
class UserProfileVirtueUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'virtues' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile virtues updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - vices
class UserProfileVicesUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'vices' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile vices updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - anecdote
class UserProfileAnecdoteUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'anecdote' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile anecdote updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
#PUT - personality_traits
class UserProfilePersonalityUpdate(APIView):
    permission_classes = [IsAuthenticated]
    def put(self, request):
        user = request.user 
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'personality_traits' not in body:
            return Response({'message':'cannot update given field'}, status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response({'message':'UserProfile personality_traits updated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#post - openai in prelimPrompt request for deployment
class RizzView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, *args, **kwargs):
        user = request.user
        body = force_str(request.body)
        userProfile = get_object_or_404(UserProfile, user = user)
        if 'interests' and 'bio' and 'favorite_movie' not in body:
            return Response({'message': 'cannot generate prelim questions'}, status=status.HTTP_405_METHOD_NOT_ALLOWED)
        else:
            serializer = UserProfileSerializer(userProfile, data=json.loads(body), partial=True)
            if serializer.is_valid():
                serializer.save()
                rizz(request)
                return Response({'message':'Rizz generated'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_200_OK)






