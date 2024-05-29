FROM ubuntu:latest

# Set the working directory
WORKDIR /app

# Install Python and system dependencies
RUN apt-get update && apt-get install -y python3 python3-pip python3.12-venv

# Copy the current directory contents into the container at /app
COPY . .

# Create a virtual environment
RUN python3 -m venv venv

# Ensure the virtual environment is used
ENV PATH="/app/venv/bin:$PATH"

# Install the required Python packages
RUN /bin/bash -c "source venv/bin/activate && pip3 install -r requirements.txt"

# Set NLTK data path
ENV NLTK_DATA="/app/venv/nltk_data"

# Download NLTK data
RUN /bin/bash -c "source venv/bin/activate && python3 -c \"import nltk; nltk.download('punkt'); nltk.download('stopwords')\""

# Expose the application port
EXPOSE 3000

# Define the command to run the application
CMD ["/bin/bash", "-c", "source venv/bin/activate && python3 app.py"]
