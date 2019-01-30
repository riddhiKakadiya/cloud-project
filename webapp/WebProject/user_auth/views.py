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
	if(len(password)==0):
		return("Password can't be blank")

	if(6>len(password) or len(password)>=12):
		message+= 'The password must be between 6 and 12 characters. : '
	password_strength = {}
	if re.search(r'[A-Z]', password):
		password_strength['has_upper'] = True
	else:
		message+= "Password must contain one upppercase : "
	if re.search(r'[a-z]', password):
		password_strength['has_lower'] = True
	else:
		message+= "Password must contain one lowercase : "

	if re.search(r'[0-9]', password):
		password_strength['has_num'] = True
	else:
		message+= "Password must contain one numeric "

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
	return HttpResponse("Hello")

@csrf_exempt
def registerPage(request):
	if request.method == 'POST':
		received_json_data = json.loads(request.body.decode("utf-8"))
		username = received_json_data['username']
		password = received_json_data['password']
		if (username==None or password == None):
			return JsonResponse({'message':'Username or password cant be empty'})
		username_status = validateUserName(username)
		password_status = validatePassword(password)


		if (username_status == True and password_status == True):
			email = username
			try:
				user = User.objects.create_user(username,username, password)
				user.is_staff= True
				user.save()
				return JsonResponse({"user created"})
			except:
				return JsonResponse({'Error' :  username + ' already exists'})
		else:
			if(password_status == True):
				return HttpResponse(username_status)	
			elif (username_status == True):
				return HttpResponse(password_status)
			else:
				return JsonResponse({'message':username_status + " " + password_status})
	return JsonResponse({'message':'Error : Please use a post method with parameters username and password to create user'})

