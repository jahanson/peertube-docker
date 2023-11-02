exec:
  docker run -it ghcr.io/jahanson/peertube-server:v5.2.1 /bin/bash
# Runs publish-containers workflow job
act:
  act -j publish-containers -b --secret-file .env
# Docker build
db:
  docker build . --no-cache -t ghcr.io/jahanson/peertube-server:v5.2.1
push:
  docker push ghcr.io/jahanson/peertube-server:v5.2.1
run: 
  docker run ghcr.io/jahanson/peertube-server:v5.2.1
