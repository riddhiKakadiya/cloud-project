from django.shortcuts import render
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse
from django.contrib.auth.models import User
import re

def password_check(given_password):
	if given_password == "test":
		return "test_1234567"
	else:
		return "Not working"
	return given_password

def validateUserName(username):
	valid = re.search(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$',username)
	if valid:
		return True
	return "* please enter valid email ID *"

def validatePassword(password):
	valid = re.search(r'^(?=[^\d_].*?\d)\w(\w|[!@#$%]){7,20}',password)
	if valid:
		return True
	return "* password should be between 8-20 characters consisting aplhanumeric characters.The password can not start with a digit, underscore or special character and must contain at least one digit. *"		

def index(request):
	return HttpResponse("Hello, world. You're at the polls index." + password_check("testa"))

@csrf_exempt
def registerPage(request):
	username = request.POST.get('username')
	password = request.POST.get('password')
	username_status = validateUserName(username)
	password_status = validatePassword(password)

	if username_status:
		if password_status:
			email = username
			try:
				user = User.objects.create_user(username,username, password)
				user.is_staff= True
				user.save()
				return HttpResponse("user created")
			except:
				return HttpResponse('Duplicate user')
			
		else:
			return HttpResponse(password_status)
	else:		
		return HttpResponse(username_status)		


def testpage(request):
	return HttpResponse("testpage" + password_check("testa"))
