from django.urls import path

from . import views

urlpatterns = [
    path('', views.signin, name='signin'),
    path('test', views.testpage, name='index'),
    path('user/register', views.registerPage, name='registerPage'),
]