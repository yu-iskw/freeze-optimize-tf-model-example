NAME := freeze-optimize-tf-model-example

create-conda:
	conda env create -f environment.yml -n $(NAME)

remove-conda:
	conda env remove -n $(NAME)

build-docker:
	docker build --rm . -t yuiskw/tensorflow-python-tools:tf-1.4.1-dev -f ./docker/Dockerfile.1.4.1-devel
