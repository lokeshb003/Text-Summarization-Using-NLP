FROM ubuntu:latest
WORKDIR .
RUN apt update && apt install python3 python3-pip -y
COPY . .
RUN pip3 install -r requirements.txt
RUN python3 -c "exec(\"import nltk\nnltk.download('punkt')\")"
RUN python3 -c "exec(\"import nltk\nnltk.download('stopwords')\")"
EXPOSE 8080
CMD ["python3","app.py"]