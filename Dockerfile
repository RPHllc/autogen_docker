# Use an official Python runtime as a parent image
FROM python:3.11.8-bullseye

# Update the image, install desired packages, clean-up
RUN apt update \
 && apt upgrade -y  \
 && apt install -y --no-install-recommends zsh wget \
 && apt autoremove -y \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
COPY .oh-my-zsh .

# Set up the application directory
WORKDIR /app
ENV AUTOGEN_DIR=/app

# Directly install autogenstudio
RUN pip install autogenstudio

# Expose the port that autogenstudio uses
EXPOSE 8081

# Command to run autogenstudio, host definition is needed to access the service from outside container
CMD ["autogenstudio", "ui", "--host", "0.0.0.0", "--port", "8081", "--appdir",  "/app"]

