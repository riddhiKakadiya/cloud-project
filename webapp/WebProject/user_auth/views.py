# importing Django libraries
from django.shortcuts import render
from django.contrib.auth import authenticate
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.models import User
from uuid import UUID
import json
import re
import base64
import time
import datetime
from .models import *

#--------------------------------------------------------------------------------
# Function definitions
# --------------------------------------------------------------------------------

# Verify signed in user
def validateSignin(meta):
    if 'HTTP_AUTHORIZATION' in meta:
        auth = meta['HTTP_AUTHORIZATION'].split()
        if len(auth) == 2:
            if auth[0].lower() == "basic":
                authstring = base64.b64decode(auth[1]).decode("utf-8")
                username, password = authstring.split(':', 1)
                if not username and not password:
                    return JsonResponse({'message': 'Error : User not logged, Please provide credentials'}, status=401)
                user = authenticate(username=username, password=password)
                if user is not None:
                    return user
    else:
        return False


# Validating passwords
def validatePassword(password):
    message = ""
    specialCharacters = ['$', '#', '@', '!', '*', '_', '-', '&', '^', '+', '%']
    if (len(password) == 0):
        return JsonResponse({'message': 'Password can\'t be blank'})

    if (8 > len(password) or len(password) >= 16):
        message += 'The password must be between 8 and 16 characters. : '
    password_strength = {}
    if not re.search(r'[A-Z]', password):
        message += "Password must contain one upppercase : "
    if not re.search(r'[a-z]', password):
        message += "Password must contain one lowercase : "

    if not re.search(r'[0-9]', password):
        message += "Password must contain one numeric : "

    if not any(c in specialCharacters for c in password):
        message += "Password must contain one special character : "

    if (len(message) > 0):
        return message
    else:
        return True


# Validing username
def validateUserName(username):
    valid = re.search(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$', username)
    if valid:
        return True
    return "* please enter valid email ID *"

def is_valid_uuid(uuid_to_test, version=4):
    """
    Check if uuid_to_test is a valid UUID.

    Parameters
    ----------
    uuid_to_test : str
    version : {1, 2, 3, 4}

    Returns
    -------
    `True` if uuid_to_test is a valid UUID, otherwise `False`.

    Examples
    --------
    >>> is_valid_uuid('c9bf9e57-1685-4c89-bafb-ff5af830be8a')
    True
    >>> is_valid_uuid('c9bf9e58')
    False
    """
    try:
        uuid_obj = UUID(uuid_to_test, version=version)
    except:
        return False

    return str(uuid_obj) == uuid_to_test

# --------------------------------------------------------------------------------
# Views definitions
# --------------------------------------------------------------------------------


@csrf_exempt
def registerPage(request):
    # check if method is post
    if request.method == 'POST':
        # check if body is not empty
        if (request.body):
            received_json_data = json.loads(request.body.decode("utf-8"))
            try:
                username = received_json_data['username']
                password = received_json_data['password']
                if (username == "" or password == "" or username == None or password == None):
                    return JsonResponse({'message': 'Username or password cant be empty'})
                username_status = validateUserName(username)
                password_status = validatePassword(password)
                if (username_status == True and password_status == True):
                    email = username
                    if not User.objects.filter(username=username).exists():
                        user = User.objects.create_user(username, email, password)
                        user.is_staff = True
                        user.save()

                        return JsonResponse({"message": " : Useser created"})
                    else:
                        return JsonResponse({'Error': "User already exists"})

                else:
                    if (password_status == True):
                        return JsonResponse({"message": username_status})
                    elif (username_status == True):
                        return JsonResponse({"message": password_status})
                    else:
                        return JsonResponse({'message': username_status + " " + password_status})
            except:

                JsonResponse({'Error': 'Please use a post method with parameters username and password to create user'})

    # If all the cases fail then return error message
    return JsonResponse({'Error': 'Please use a post method with parameters username and password to create user'})


@csrf_exempt
def signin(request):
    # check if method is get
    if request.method == 'GET':
        if 'HTTP_AUTHORIZATION' in request.META:
            auth = request.META['HTTP_AUTHORIZATION'].split()
            if len(auth) == 2:
                if auth[0].lower() == "basic":
                    authstring = base64.b64decode(auth[1]).decode("utf-8")
                    username, password = authstring.split(':', 1)
                    if not username and not password:
                        return JsonResponse({'message': 'Error : User not logged, Please provide credentials'}, status=401)
                    user = authenticate(username=username, password=password)
                    if user is not None:
                        current_time = time.ctime()
                        return JsonResponse({"current time": current_time})
        # otherwise ask for authentification
        return JsonResponse({'message': 'Error : Incorrect user details'}, status=401)
    else:
        return JsonResponse({'Error': 'Please use a get method with user credentials'})

@csrf_exempt
def createOrGetNotes(request):
    if request.method == 'POST':
        if (request.body):
            received_json_data = json.loads(request.body.decode("utf-8"))
            title = received_json_data['title']
            content = received_json_data['content']
            time_now = datetime.datetime.now()
            user = validateSignin(request.META)
            if (user):
                note = NotesModel(title=title, content=content, created_on=time_now, last_updated_on=time_now,
                                  user=user)
                note.save()
                message = {}
                message['id'] = note.id
                message['title'] = title
                message['content'] = content
                message['created_on'] = time_now
                message['last_updated_on'] = time_now
                return JsonResponse(message, status=201)

    elif request.method == 'GET':
        user = validateSignin(request.META)
        if (user):
            notes = NotesModel.objects.filter(user=user)
            if (notes.exists()):
                message_list = []
                for note in notes:
                    message = {}
                    message['id'] = note.id
                    message['title'] = note.title
                    message['content'] = note.content
                    message['created_on'] = note.created_on
                    message['last_updated_on'] = note.last_updated_on
                    message_list.append(message)
                return JsonResponse(message_list, status=200, safe=False)
            else:
                return JsonResponse({'message': 'Error : Note List Empty'}, status=204)
        return JsonResponse({'message': 'Error : Incorrect user details'}, status=401)

#
#else
#	user = validateSignin(request.META)
#	if(user):
#		NotesModel.objects.filter(pk=id).update('title'=title, 'content'=content, 'last_updated_on'=last_updated_on)
#		message = "Note updated!""
#		return JsonResponse(message, status=201)

@csrf_exempt
def noteFromId(request, note_id=""):
	if request.method == 'GET':
		user = validateSignin(request.META)
		if (is_valid_uuid(note_id)):
			if (user):
				notes = NotesModel.objects.filter(id=note_id, user=user)
				if (notes.exists()):
					message = {}
					message['id'] = notes[0].id
					message['title'] = notes[0].title
					message['content'] = notes[0].content
					message['created_on'] = notes[0].created_on
					message['last_updated_on'] = notes[0].last_updated_on
					return JsonResponse(message, status=200)
				else:
					return JsonResponse({'message': 'Error : Invalid Note ID'}, status=400)
		else:
			return JsonResponse({'message': 'Error : Invalid Note ID'}, status=400)
#update
	elif request.method=='PUT':
		print(note_id)
		user = validateSignin(request.META)
		if (is_valid_uuid(note_id)):
			if(user):
				note = NotesModel.objects.get(pk=note_id)
				if(note.user==user):
					print(note.content)
					received_json_data = json.loads(request.body.decode("utf-8"))
					note.title = received_json_data['title']
					note.content = received_json_data['content']
					note.last_updated_on = datetime.datetime.now()		
					note.save()
					return JsonResponse({'message':'note updated!'}, status=202)
				else:
					return JsonResponse({'message': 'Error : Invalid note id'}, status=401)
			else:	
				return JsonResponse({'message': 'Error : Incorrect user details'}, status=401)
		else:	
			return JsonResponse({'message': 'Error : Invalid note id'}, status=404)		
