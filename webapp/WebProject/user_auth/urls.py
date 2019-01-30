from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('test', views.testpage, name='index'),
    path('signin', views.signin, name='signin'),
    path('user/register', views.registerPage, name='registerPage'),
]