FROM debian

# Set the environment variable for non-interactive package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages for SSH, ngrok, and other utilities
RUN apt update && apt upgrade -y && apt install -y \
    ssh wget unzip vim curl python3 \
    && wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O /ngrok-stable-linux-amd64.zip \
    && unzip /ngrok-stable-linux-amd64.zip -d /usr/local/bin \
    && rm /ngrok-stable-linux-amd64.zip

# Expose necessary ports (e.g., HTTP, SSH, etc.)
EXPOSE 80 443 3306 4040 5432 5700 5701 5010 6800 6900 8080 8888 9000

# Copy the ngrok setup script into the container
COPY run-ngrok.sh /run-ngrok.sh
RUN chmod +x /run-ngrok.sh

# Add ngrok authtoken during the build (ensure NGROK_TOKEN is set correctly during the build process)
ARG NGROK_TOKEN
RUN ngrok config add-authtoken ${NGROK_TOKEN}

# Command to run ngrok and SSH service
CMD ["/run-ngrok.sh"]
