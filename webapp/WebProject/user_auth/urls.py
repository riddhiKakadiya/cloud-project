from django.urls import path, re_path

from . import views

urlpatterns = [
    re_path(r'^$', views.signin, name='signin'),
    re_path(r'^user/register/?$', views.registerPage, name='registerPage'),
    re_path(r'^note/?$', views.createOrGetNotes, name='createOrGetNotes'),
    re_path(r'^note/(?P<note_id>[0-9a-z-]+)$', views.noteFromId, name='noteFromId'),
    re_path(r'^note/(?P<note_id>[0-9a-z-]+)/attachments$', views.addAttachmentToNotes, name='addAttachmentToNotes')
    # re_path(r'^note/(?P<note_id>[0-9a-z-]+)/attachments/(?P<attachment_id>[0-9a-z-]+)$', views.updateOrDeleteAttachments, name='updateOrDeleteAttachments')
#get, update, delete
    ]
    
