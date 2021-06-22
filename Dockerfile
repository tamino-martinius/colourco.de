FROM node:14.15-slim

# Set working directory
WORKDIR /home/node/app

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl https://install.meteor.com/ | sh

COPY --chown=1000:1000 . /home/node/app/
# Workaround to not expose node_module folders to the host
# and not have permissions issues when building after the first time.
RUN mkdir -p node_modules
RUN chown 1000:1000 node_modules

USER 1000:1000
RUN npm install

# Workaround to install meteor distribution in nodes home directory
RUN meteor help

EXPOSE 3000
CMD ["meteor"]
