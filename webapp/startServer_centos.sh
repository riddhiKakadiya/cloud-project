#For CentOS
scl enable rh-python36 bash
sudo rm -rf djangoEnv
virtualenv -p python djangoEnv
source djangoEnv/bin/activate
cat requirements.txt | xargs -n 1 pip install
cd WebProject
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver