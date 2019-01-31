from django.urls import path, re_path

from . import views

urlpatterns = [
    re_path(r'^$', views.signin, name='signin'),
    re_path(r'^user/register/?$', views.registerPage, name='registerPage'),
]