from django.urls import path
from . import views


urlpatterns = [
    path("trophy/", views.TrophyList.as_view(), name="trophy-list-create"),
    path("trophy/<int:pk>/", views.TrophyRetrieveUpdateDestroy.as_view(), name="trophy-detail"),
]