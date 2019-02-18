import uuid
from django.db import models
from django.contrib.auth.models import User

class NotesModel(models.Model):
	id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
	title = models.CharField(max_length=500)
	content = models.CharField(max_length=500)
	created_on = models.DateTimeField()
	last_updated_on = models.DateTimeField()
	user = models.ForeignKey(User, on_delete=models.DO_NOTHING)
	def __str__(self):
		return (str(self.id))

class Attachment(models.Model):
	id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
	url = models.CharField(max_length=1000)
	note = models.ForeignKey(NotesModel, on_delete=models.CASCADE)	
	def __str__(self):
		return (str(self.id))
