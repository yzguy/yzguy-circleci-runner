FROM circleci/runner:launch-agent

# Install packages
RUN sudo apt-get update; \
    sudo apt-get install --no-install-recommends -y \
    git \
    openssh-client \
    wget

# Install Task
RUN wget -q -O /tmp/task.deb https://github.com/go-task/task/releases/download/v3.7.3/task_linux_amd64.deb && \
    sudo dpkg -i /tmp/task.deb && rm -f /tmp/task.deb
