"""
WSGI config for WebProject project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/2.1/howto/deployment/wsgi/
"""

import os

from django.core.wsgi import get_wsgi_application
try:
	if (os.environ['DEPLOYMENT_GROUP_NAME']=="csye6225-webapp-deployment"):
		os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'WebProject.settings_dev')
	else:
		os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'WebProject.settings_test')	
except:
	os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'WebProject.settings_default')

application = get_wsgi_application()
