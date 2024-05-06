FROM ubuntu:latest
WORKDIR .
# Install Python and system dependencies
RUN apt-get update && apt-get install -y python3 python3-pip python3.12-venv 
COPY . .
RUN python3 -m venv venv
RUN /bin/bash -c "source venv/bin/activate && pip3 install -r requirements.txt

EXPOSE 3000
CMD ["/bin/bash", "-c", "source venv/bin/activate && python3 app.py"]

