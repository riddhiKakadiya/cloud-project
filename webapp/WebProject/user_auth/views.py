from django.shortcuts import render

# Create your views here.

from django.http import HttpResponse


def password_check(given_password):
	if given_password == "test":
		return "test_1234567"
	else:
		return "Not working"
	return given_password

# def createUser():
# 	return 	

def index(request):
    return HttpResponse("Hello, world. You're at the polls index." + password_check("testa"))

# def registerPage(request):
#     return HttpResponse("register"+ createUser())

def testpage(request):
    return HttpResponse("testpage" + password_check("testa"))
