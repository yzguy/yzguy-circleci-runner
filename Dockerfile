FROM ubuntu:20.04

COPY --from=circleci/runner:launch-agent /opt/circleci /opt/circleci

# Install packages
RUN apt-get update; \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    docker.io \
    git \
    openssh-client \
    wget

# Test

# Install Task
RUN wget -q -O /tmp/task.deb https://github.com/go-task/task/releases/download/v3.7.3/task_linux_amd64.deb && \
    dpkg -i /tmp/task.deb && rm -f /tmp/task.deb

CMD ["/opt/circleci/start.sh"]
