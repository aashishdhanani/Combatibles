FROM python:3.11

ENV PYTHONUNBUFFERED 1

WORKDIR /Swinger

# Copy only the requirements file to leverage Docker cache
COPY requirements.txt .

# Install project dependencies
RUN pip install -r requirements.txt

# Copy the rest of the project
COPY . .

# Delete existing migrations
RUN find . -path "*/migrations/*.py" -not -name "__init__.py" -delete \
    && find . -path "*/migrations/*.pyc" -delete

# Remove the old database file
RUN rm -f db.sqlite3

# Create new migrations
RUN python manage.py makemigrations

# Apply migrations to create the database
RUN python manage.py migrate

# Admin user credentials
ENV DJANGO_SUPERUSER_USERNAME=admin \
    DJANGO_SUPERUSER_EMAIL=admin@test.com \
    DJANGO_SUPERUSER_PASSWORD=admin

# Create super user
RUN python manage.py createsuperuser --no-input \
    --username="$DJANGO_SUPERUSER_USERNAME" \
    --email="$DJANGO_SUPERUSER_EMAIL"

# Set the deployment port
EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]