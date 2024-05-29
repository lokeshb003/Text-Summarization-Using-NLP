FROM ubuntu:latest
WORKDIR .
RUN apt-get update && apt-get install -y python3 python3-pip python3.12-venv 
COPY . .
RUN python3 -m venv venv
ENV PATH="/app/venv/bin:$PATH"
RUN /bin/bash -c "source venv/bin/activate && pip3 install -r requirements.txt"
ENV NLTK_DATA="/app/venv/nltk_data"
RUN python3 -c "exec(\"import nltk\nnltk.download('punkt')\")"
RUN python3 -c "exec(\"import nltk\nnltk.download('stopwords')\")"
EXPOSE 3000
CMD ["/bin/bash", "-c", "source venv/bin/activate && python3 app.py"]

