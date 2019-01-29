from django.shortcuts import render
import re
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse
from django.contrib.auth.models import User


def validatePassword(password):
	print ('Enter a password\n\nThe password must be between 6 and 12 characters. : ')
	message =""
	if(len(password)==0):
		return("Password can't be blank")

	if(6>len(password) or len(password)>=12):
		message+= 'The password must be between 6 and 12 characters. : '

	password_scores = {0:'Horrible', 1:'Weak', 2:'Medium', 3:'Strong'}
	password_strength = dict.fromkeys(['has_upper', 'has_lower', 'has_num'], False)

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

	score = len([b for b in password_strength.values() if b])

	result= 'Password is %s' % password_scores[score]

	if (len(message)>0):
		return message
	else:
		return True

def validateUserName(username):
	valid = re.search(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$',username)
	if valid:
		return True
	return "* please enter valid email ID *"
		

def index(request):
	return HttpResponse("Hello, world. You're at the polls index." + password_check("testa"))

@csrf_exempt
def registerPage(request):
	username = request.POST.get('username')
	password = request.POST.get('password')
	username_status = validateUserName(username)
	password_status = validatePassword(password)

	if (username_status == True):
		if (password_status == True):
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
