FROM ubuntu:22.04

COPY --from=circleci/runner:launch-agent /opt/circleci /opt/circleci

# Install packages
RUN apt-get update; \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    docker.io \
    git \
    gpg \
    lsb-release \
    bind9utils \
    openssh-client \
    wget

# Install Task
RUN wget -q -O /tmp/task.deb https://github.com/go-task/task/releases/download/v3.31.0/task_linux_amd64.deb && \
    dpkg -i /tmp/task.deb && rm -f /tmp/task.deb

CMD ["/opt/circleci/start.sh"]
