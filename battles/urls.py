from django.urls import path
from . import views

urlpatterns = [
    path("question/", views.QuestionList.as_view(), name="question-list-create"),
    path("question/<int:created_by>/", views.QuestionRetrieveUpdateDestroy.as_view(), name="question-detail"),
    path("usergameresult/", views.UserGameResultList.as_view(), name="user_game_result-list-create"),
    path("usergameresult/<int:pk>/", views.UserGameResultRetrieveUpdateDestroy.as_view(), name="user_game_result-detail"),
    path("battle/", views.BattleList.as_view(), name="battle-list-create"),
    path("battle/<int:pk>/", views.BattleRetrieveUpdateDestroy.as_view(), name="battle-detail"),
]
#For UserGameResult
urlpatterns += [
    path("usergameresult/get-usergameresult", views.UserGameResultManager.as_view(), name="user_game_result-create"), #GET
    path("usergameresult/create-usergameresult", views.UserGameResultManager.as_view(), name="user_game_result-create"), #POST
    path("usergameresult/delete-usergameresult", views.UserGameResultManager.as_view(), name="user_game_result-create"), #POST
]
#For Questions
urlpatterns += [
    path("question/user-get-question", views.QuestionManager.as_view(), name="question-get"), #GET
    path("question/user-create-question", views.QuestionManager.as_view(), name="question-create"), #POST
    path("question/user-update-question", views.QuestionManager.as_view(), name="question-update"), #PUT
    path("question/user-delete-question", views.QuestionManager.as_view(), name="question-delete"), #DELETE
    path("question/user-retrieve-random-questions", views.RetrieveRandomQuestionsUsingUserID.as_view(), name="question-random") #POST
]
#For Battle
urlpatterns += [
    path("battle/get-battle", views.BattleManager.as_view(), name="battle-get"), #GET
    path("battle/get-battle-of-user", views.BattleManagerForGet.as_view(), name='battle-get-for-user'), #GET
    path("battle/create-battle", views.BattleManager.as_view(), name="battle-create"), #POST
]