#importing Django libraries
from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.models import User
import json
import re

#--------------------------------------------------------------------------------
# Function definitions
#--------------------------------------------------------------------------------

#Validating passwords
def validatePassword(password):
	message =""
	specialCharacters = ['$', '#', '@', '!', '*','_','-','&','^','+','%']
	if(len(password)==0):
		return("Password can't be blank")

	if (6>len(password) or len(password)>=12):
		message+= 'The password must be between 6 and 12 characters. : '
	password_strength = {}
	if not re.search(r'[A-Z]', password):
		message+= "Password must contain one upppercase : "
	if not re.search(r'[a-z]', password):
		message+= "Password must contain one lowercase : "

	if not re.search(r'[0-9]', password):
		message+= "Password must contain one numeric : "

	if not any(c in specialCharacters for c in password):
		message+= "Password must contain one special character : "
	
	if (len(message)>0):
		return message
	else:
		return True

#Validing username
def validateUserName(username):
	valid = re.search(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$',username)
	if valid:
		return True
	return "* please enter valid email ID *"


#--------------------------------------------------------------------------------
# Views definitions
#--------------------------------------------------------------------------------	
@csrf_exempt
def index(request):
	return HttpResponse("Hello, world. You're at the polls index." + validatePassword("password"))

@csrf_exempt
def registerPage(request):
	if request.method == 'POST':
		received_json_data = json.loads(request.body.decode("utf-8"))
		print(received_json_data)
		username = received_json_data['username']
		password = received_json_data['password']
		if (username==None or password == None):
			return JsonResponse({'message':'Username or password cant be empty'})
		username_status = validateUserName(username)
		password_status = validatePassword(password)
		if (username_status == True and password_status == True):
			email = username
			if not User.objects.filter(username=username).exists():
				user = User.objects.create_user(username, email, password)
				print("User Details :" + str(user))
				user.is_staff= True
				user.save()
				return JsonResponse({"message" : "user created"})
			else:
				return JsonResponse({'Error' :  username + ' already exists'})
		else:
			if(password_status == True):
				return JsonResponse({"message" : username_status})	
			elif (username_status == True):
				return JsonResponse({"message" : password_status})
			else:
				return JsonResponse({'message':username_status + " " + password_status})
	return JsonResponse({'message':'Error : Please use a post method with parameters username and password to create user'})

