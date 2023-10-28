# Runs publish-containers workflow job
act:
  act -j publish-containers -b --secret-file .github/workflows/.env
# Docker build
db:
  docker build . --no-cache
exec:
  docker run -it ghcr.io/jahanson/peertube-server:v5.2.1 /bin/sh
