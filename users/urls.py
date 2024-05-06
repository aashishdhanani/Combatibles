from django.urls import path
from . import views
from rest_framework.authtoken.views import obtain_auth_token
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.response import Response

class CustomAuthToken(ObtainAuthToken):

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data,
                                           context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        return Response({
            'token': token.key,
            'uid': user.pk,
            'email': user.email
        })

urlpatterns = [
    path("user/", views.UserList.as_view(), name="user-list-create"),
    path("user/<int:pk>", views.UserRetrieveUpdateDestroy.as_view(), name="user-detail"),
    path("user/token", CustomAuthToken.as_view()), #POST
    path("user/create", views.CreateUser.as_view(), name="user-create"), #POST
    path("user/update", views.UserUpdate.as_view(), name="user-update-info"), #PUT
    path("user/update-first_name", views.UserUpdateFirstName.as_view(), name="user-update-first_name"), #PUT
    path("user/update-last_name", views.UserUpdateLastName.as_view(), name="user-update-last_name"), #PUT
    path("user/update-date_of_birth", views.UserUpdateDateOfBirth.as_view(), name="user-update-date_of_birth"), #PUT
    path("user/update-photo_url", views.UserUpdatePhotoUrl.as_view(), name="user-update-photo_url"), #PUT
    path("user/update-location", views.UserUpdateLocation.as_view(), name="user-update-location"), #PUT
    path("user/update-add_friend", views.UserAddFriend.as_view(), name="user-update-add_friend"), #PUT
    path("user/delete", views.UserUpdate.as_view(), name="user-delete"), #DELETE
    path("user/get", views.UserUpdate.as_view(), name="user-get") #GET
]


urlpatterns += [
    path("user/profile/", views.ProfileDetailList.as_view(), name="user-profile-create"),
    path("user/profile/<int:pk>/", views.UserProfileRetrieveUpdateDestroy.as_view(), name="user-profile-detail"),
]

urlpatterns += [
    path("user/profileupdate", views.UserProfileUpdate.as_view(), name="profile-update") #PUT
]

urlpatterns += [
    path("user/age", views.UserProfileAgeUpdate.as_view(), name="age-update"), #PUT
    path("user/bio", views.UserProfileBioUpdate.as_view(), name="bio-update"), #PUT
    path("user/quote", views.UserProfileQuoteUpdate.as_view(), name="quote-update"), #PUT
    path("user/peeves", views.UserProfilePeevesUpdate.as_view(), name="petpeeves-update"), #PUT
    path("user/destination", views.UserProfileDestinationUpdate.as_view(), name="dreamdest-update"), #PUT
    path("user/meet", views.UserProfileMeetUpdate.as_view(), name="howwemet-update"), #PUT
    path("user/moment", views.UserProfileMomentsUpdate.as_view(), name="memorablemoment-update"), #PUT
    path("user/interests", views.UserProfileInterestsUpdate.as_view(), name="interests-update"), #PUT
    path("user/movie", views.UserProfileMovieUpdate.as_view(), name="favmovie-update"), #PUT
    path("user/book", views.UserProfileBookUpdate.as_view(), name="favbook-update"), #PUT
    path("user/food", views.UserProfileFoodUpdate.as_view(), name="favfood-update"), #PUT
    path("user/virtues", views.UserProfileVirtueUpdate.as_view(), name="virtues-update"), #PUT
    path("user/vices", views.UserProfileVicesUpdate.as_view(), name="vices-update"), #PUT
    path("user/anecdote", views.UserProfileAnecdoteUpdate.as_view(), name="anecdote-update"), #PUT
    path("user/personality", views.UserProfilePersonalityUpdate.as_view(), name="personality-update"), #PUT
    path("user/rizz", views.RizzView.as_view(), name="rizz-update")
]

