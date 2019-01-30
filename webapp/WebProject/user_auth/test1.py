from django.test import TestCase
from django.contrib.auth.models import User
from django.test import Client
import base64
from .views import validateUserName 
 
#Testing if username is valid
#class TestingValidateUserName(TestCase):	
	# def TestUserNameTrue(self):
	# 	self.assertEqual(validateUserName('riddhikakadiya29@gmail.com'), True)
						
	# def TestUserNameFalse(self):
	# 	self.assertEqual(validateUserName('riddhikakadiya29'), '* please enter valid email ID *')