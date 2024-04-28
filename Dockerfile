FROM ubuntu:latest

# Install Python and system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements file separately
COPY requirements.txt .

# Create a virtual environment and activate it
RUN python3 -m venv venv
ENV PATH="/app/venv/bin:$PATH"

# Install dependencies within the virtual environment
RUN pip install -r requirements.txt

# Set NLTK_DATA environment variable
ENV NLTK_DATA="/app/venv/nltk_data"

# Copy application code
COPY . .

# Download NLTK data
RUN python3 -c "import nltk; nltk.download('punkt'); nltk.download('stopwords')"

# Expose port
EXPOSE 8080

# Run the application
CMD ["python3", "app.py"]
