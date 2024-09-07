# Use the official Python image from the Alpine Linux distribution
FROM python:3.9-alpine3.13

# Set the maintainer label
LABEL maintainer="karimsoliman.com"

# Set environment variable to ensure Python output is not buffered
ENV PYTHONUNBUFFERED 1  

# Copy the requirements file to the /tmp directory in the container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt


# Copy the application code to the /app directory in the container
COPY ./app /app

# Set the working directory to /app
WORKDIR /app

# Expose port 8000 to allow communication to/from the container
EXPOSE 8000

ARG DEV=false
# Create a virtual environment, upgrade pip, install dependencies, clean up, and add a user
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Set the PATH environment variable to include the virtual environment's bin directory
ENV PATH="/py/bin:$PATH"

# Switch to the newly created user
USER django-user