ARG CODE_VERSION=develop
ARG CODE_REPO=js-payments
FROM securetrading1/${CODE_REPO}:${CODE_VERSION}
ARG CODE_REPO
COPY . /app/py-payments-testing
WORKDIR /app/py-payments-testing
RUN cp -r /app/${CODE_REPO}/dist/* /app/py-payments-testing/__files
EXPOSE 8443
#ENTRYPOINT ["make", "run_wiremock"]

FROM python:latest

# Get up to date
RUN apt-get update

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb

# Make JAVA_HOME available in docker
RUN apt-get install -y openjdk-11-jdk-headless && \
    rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME  /usr/lib/jvm/java-11-openjdk-amd64/

# Latest versions of python tools via pip
RUN pip install poetry
COPY pyproject.toml /app/
COPY poetry.lock /app/
WORKDIR /app
RUN poetry install

# Get framework into docker
COPY . /app
RUN chmod 755 /app/chromedriver
ENV PATH "$PATH:/app"
CMD poetry run behave features