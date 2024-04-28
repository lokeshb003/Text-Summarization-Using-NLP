FROM ubuntu:latest

# Set working directory
WORKDIR /app

# Update and install necessary packages
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv

# Copy requirements.txt separately to leverage Docker caching
COPY requirements.txt .

# Create a virtual environment, install dependencies, and download NLTK data
RUN python3 -m venv venv && \
    /bin/bash -c "source venv/bin/activate && \
    pip3 install -r requirements.txt && \
    pip3 install nltk && \
    python3 -c \"import nltk; nltk.download('punkt')\" && \
    python3 -c \"import nltk; nltk.download('stopwords')\""

# Copy the rest of the application code
COPY . .

# Expose port
EXPOSE 8080

# Command to run the application
CMD ["python3", "app.py"]
