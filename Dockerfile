# Use a lighter base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Update and install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements.txt separately to leverage Docker caching
COPY requirements.txt .

# Create a virtual environment, install dependencies, and download NLTK data
RUN python3 -m venv venv && \
    /bin/bash -c "source venv/bin/activate && \
    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir nltk && \
    python3 -c \"import nltk; nltk.download('punkt')\" && \
    python3 -c \"import nltk; nltk.download('stopwords')\""

# Copy the rest of the application code
COPY . .

# Expose port
EXPOSE 8080

# Command to run the application
CMD ["python3", "app.py"]
