from django.urls import path, re_path

from . import views

urlpatterns = [
    re_path(r'^$', views.signin, name='signin'),
    re_path(r'^user/register/?$', views.registerPage, name='registerPage'),
    re_path(r'^note$', views.createNotes, name='registerPage'),
    re_path(r'^note/(?P<note_id>[0-9a-z-]+)$', views.getNotes, name='registerPage')
#	 re_path(r'^note/(?P<note_id>[0-9a-z-]+)$', views.updateNotes, name='updateNote')
]