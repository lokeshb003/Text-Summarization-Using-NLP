FROM ubuntu:latest

# Set working directory
WORKDIR /app

# Update and install necessary packages
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv

# Copy requirements.txt separately to leverage Docker caching
COPY requirements.txt .

# Create a virtual environment
RUN python3 -m venv venv

# Activate the virtual environment and install Python dependencies
RUN /bin/bash -c "source venv/bin/activate && pip3 install -r requirements.txt"

# Copy the rest of the application code
COPY . .

# Download NLTK data
RUN python3 -c "import nltk; nltk.download('punkt')"
RUN python3 -c "import nltk; nltk.download('stopwords')"

# Expose port
EXPOSE 8080

# Command to run the application
CMD ["python3", "app.py"]
