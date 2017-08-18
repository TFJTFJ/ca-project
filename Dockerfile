FROM ubuntu:latest

# Install python and pip
RUN apt-get update -y
RUN apt-get install -y python-pip python-dev build-essential

RUN mkdir -p /usr/src/app/
RUN mkdir -p /usr/src/app/app/

# Install Python modules needed by the Python app
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

# Copy files required for the app to run
COPY *.py /usr/src/app/
COPY *.sh /usr/src/app/
COPY app/ /usr/src/app/app/

# Declare the port number the container should expose
EXPOSE 5000

# Run the application
CMD ["/usr/src/app/run.sh"]

