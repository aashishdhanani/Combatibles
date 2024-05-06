from django.shortcuts import render
from .models import Trophy
from .serializers import TrophySerializer
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.generics import GenericAPIView
from users.models import User

from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404

# Create your views here.
class TrophyList(generics.ListCreateAPIView):
    queryset = Trophy.objects.all()
    serializer_class = TrophySerializer

    def delete(self, request, *args, **kwargs):
        Trophy.objects.all().delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class TrophyRetrieveUpdateDestroy(generics.RetrieveUpdateDestroyAPIView):
    queryset = Trophy.objects.all()
    serializer_class = TrophySerializer
    lookup_field = 'pk'