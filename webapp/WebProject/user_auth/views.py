from django.shortcuts import render
import re



# Create your views here.

from django.http import HttpResponse


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

def password_check(given_password):
	if given_password == "test":
		return "test_1234567"
	else:
		return "Not working"
	return given_password


def index(request):
	return HttpResponse(validatePassword('hifds'))



def testpage(request):
	return HttpResponse("testpage" + password_check("testa"))
