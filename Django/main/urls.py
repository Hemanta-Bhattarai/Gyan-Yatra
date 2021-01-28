from django.urls import path
from . import views
urlpatterns= [
    path('diet_track/',views.dietConsumedUpdate,name='diet_track'),
    path('',views.home,name='main-home'),
    path('user_info/',views.userInfo,name='user_info'),
    path('diet_info/',views.dietInfo,name='diet_info'),
    path('diet_eaten/',views.dietEaten,name='diet_eaten'),
]
