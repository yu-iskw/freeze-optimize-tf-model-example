NAME := freeze-optimize-tf-model-example

create-conda:
	conda env create -f environment.yml -n $(NAME)

remove-conda:
	conda env remove -n $(NAME)
