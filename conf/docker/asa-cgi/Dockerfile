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

# Step : Common Gateway Interface
FROM cli AS cgi

# Install nginx
RUN apt-get install -y \
    nginx \
    fcgiwrap

# Install RPC
ENV NGINX_MAX_CGI_SOCK=5
ENV NGINX_MAX_CLIMQ_SOCK=5
ADD ./cgi/docker-entrypoint.sh /docker-entrypoint.sh
ADD ./cgi/docker-entrypoint.d /docker-entrypoint.d
ADD ./cgi/nginx/default.conf /etc/nginx/conf.d/default.conf
ADD ./cgi/nginx/html /usr/share/nginx/html
ADD ./cgi/nginx/cgi /usr/share/nginx/cgi
RUN chmod +rx /docker-entrypoint.sh

# Setting
WORKDIR /app
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
