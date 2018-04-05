NAME := freeze-optimize-tf-model-example

TAG := 1.4.1-devel

DOCKER_REPO := yuiskw/tensorflow-tools

create-conda:
	conda env create -f environment.yml -n $(NAME)

remove-conda:
	conda env remove -n $(NAME)

build-docker: check-tag
	# ex) docker build --rm . -t yuiskw/tensorflow-python-tools:tf-1.4.1-devel -f ./docker/Dockerfile.1.4.1-devel
	docker build --rm . -t $(DOCKER_REPO):tf-$(TAG) -f ./docker/Dockerfile.$(TAG)

push-docker: check-tag
	docker push $(DOCKER_REPO):tf-$(TAG)

check-tag:
ifndef TAG
	echo "Error: TAG is not defined."
	exit 1
endif
