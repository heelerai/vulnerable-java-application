REGION ?= us-east-1
# heelerai-test-infrastructure
ACCOUNT_ID ?= 004492769043

.PHONY: all build push

all: build push

build:
	scripts/build-docker.sh

push:
	scripts/push-docker.sh


image:
	docker build --platform=linux/amd64 -t vulnerable-java-app .


run-image:
	docker run -p 8000:8000 -it vulnerable-java-app


publish-image:
	aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
	docker tag vulnerable-java-app:latest ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/insecure:vulnerable-java-app-latest
	docker push ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/insecure:vulnerable-java-app-latest
