from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('user/register', views.registerPage, name='registerPage'),
    path('test', views.testpage, name='index'),
]