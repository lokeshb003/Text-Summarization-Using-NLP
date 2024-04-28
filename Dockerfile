FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements file separately and install dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Copy application code
COPY . .

# Download NLTK data
RUN python3 -c "import nltk; nltk.download('punkt'); nltk.download('stopwords')"

# Expose port
EXPOSE 8080

# Run the application
CMD ["python3", "app.py"]
