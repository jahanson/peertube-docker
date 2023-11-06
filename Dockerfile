# Production stage
FROM node:20-bookworm-slim
LABEL org.opencontainers.image.source https://github.com/jahanson/peertube-docker
LABEL org.opencontainers.image.description PeerTube API Server no nginx, just node.

# Install dependencies
RUN apt update \
    && apt install -y --no-install-recommends openssl ffmpeg python3 ca-certificates gnupg gosu build-essential curl git \
    && gosu nobody true \
    && rm /var/lib/apt/lists/* -fR

# Add peertube user
RUN groupadd -r peertube \
    && useradd -r -g peertube -m peertube

# Install modules and dependencies
WORKDIR /app

COPY --chown=peertube:peertube peertube-*/ .

# RUN chown -R peertube:peertube .

RUN mkdir /app/data /app/config 
RUN chown -R peertube:peertube /app/data /app/config
COPY --chown=peertube:peertube peertube-*/config/default.yaml ./config/default.yaml

RUN yarn install --production --pure-lockfile --network-timeout 1200000
RUN yarn cache clean 

ENV NODE_ENV production
ENV NODE_CONFIG_DIR /app/config:/app/support/docker/production/config:/config
ENV PEERTUBE_LOCAL_CONFIG /config

VOLUME /app/data
VOLUME /app/config

COPY peertube-*/support/docker/production/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

# Expose API and RTMP
EXPOSE 9000 1935

USER peertube
# Run the application
CMD [ "/usr/local/bin/node", "dist/server" ]