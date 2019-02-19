sudo rm -rf djangoEnv
virtualenv -p python3 djangoEnv
source djangoEnv/bin/activate
#For CentOS
#cat requirements.txt | xargs -n 1 pip install
pip install -r requirements.txt
cd WebProject
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver