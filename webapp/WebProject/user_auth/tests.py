from django.test import TestCase
from django.contrib.auth.models import User
from django.test import Client
import base64
import datetime

from .views import validateUserName , validatePassword


class BasicAuthTest(TestCase):
	#creating user
	def setUp(self):
		print(validateUserName('rk@gmail.com'))
		self.username = 'rk@gmail.com'
		self.password = 'Riddhi@2911'
		self.user1 = User.objects.create_user(self.username, self.username, self.password)

	#testing root URL with basic auth
	def test_base_url(self):
		up = self.username+':'+self.password
		auth_headers = {'HTTP_AUTHORIZATION': 'Basic ' + base64.b64encode(up.encode('utf-8')).decode('utf-8'),}
		c = Client()
		response = c.get('/timestamp', **auth_headers)
		# response = c.get('', **auth_headers)
		self.assertEqual(response.status_code, 200)


	

	#deleting user
	def tearDown(self):
		self.user1.delete() 

	def testUserNameTrue(self):
		self.assertEqual(validateUserName('riddhikakadiya29@gmail.com'), True)
						
	def testUserNameFalse(self):
		self.assertEqual(validateUserName('riddhikakadiya29'), '* please enter valid email ID *')

	#passwordValidation
	def testPasswordTrue(self):
		self.assertEqual(validatePassword('Krapali@123'),True)

	def testPasswordFalse(self):
		self.assertEqual(validatePassword('K1e$e'), 'The password must be between 8 and 16 characters. : ')

