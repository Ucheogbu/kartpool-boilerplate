# syntax=docker/dockerfile:1
FROM python:3
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
EXPOSE 8000
RUN apt-get update
RUN mkdir code
RUN mkdir -p /etc/uwsgi/sites
COPY requirements.txt ./code
RUN pip install six
COPY app.ini /etc/uwsgi/sites/
WORKDIR /code
RUN pip install uwsgi
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN python manage.py makemigrations
RUN python manage.py migrate
CMD [ "uwsgi", "--http", "0.0.0.0:8000", \
               "--plugins", "python3", \
               "--module","kartpool" ]
