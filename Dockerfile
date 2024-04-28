FROM ubuntu:latest

# Set working directory
WORKDIR /app

# Update and install necessary packages
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv

# Copy requirements.txt separately to leverage Docker caching
COPY requirements.txt .

# Create and activate a virtual environment
RUN python3 -m venv venv
RUN /bin/bash -c "source venv/bin/activate"

# Install Python dependencies within the virtual environment
RUN pip3 install -r requirements.txt

# Copy the rest of the application code
COPY . .

# Download NLTK data
RUN python3 -c "import nltk; nltk.download('punkt')"
RUN python3 -c "import nltk; nltk.download('stopwords')"

# Expose port
EXPOSE 8080

# Command to run the application
CMD ["python3", "app.py"]
