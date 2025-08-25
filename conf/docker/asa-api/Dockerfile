# Step : base
FROM python:slim AS base

# Update linux package manager
RUN apt-get update -y

# Update python package manager
RUN pip install --upgrade pip

# Install yaml parser tools
RUN pip install pyyaml

# Install python requirement
RUN pip install \
    numpy

# Step : Command line interface
FROM base AS cli
# Install CLI
ADD ./cli /usr/local/src/asa
RUN \
    echo "bash /usr/local/src/asa/cli.sh \${@}" | tee -a /bin/asa > /dev/null && \
    chmod 755 /bin/asa && \
    chmod +x /usr/local/src/asa/cli.sh

# Setting
WORKDIR /app
ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]

# Step : Python FastAPI
FROM cli AS api

# Install FastAPI
RUN pip install \
    fastapi \
    uvicorn[standard]

# Install API server
ADD ./api/docker-entrypoint.sh /docker-entrypoint.sh
ADD ./api/server /usr/local/fastapi
RUN chmod +rx /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apiserver"]
