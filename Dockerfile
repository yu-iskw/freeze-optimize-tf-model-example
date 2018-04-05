FROM tensorflow/tensorflow:1.4.1-devel

WORKDIR /tensorflow

# build python tools
RUN bazel build tensorflow/python/tools:tools_pip

# build tools
RUN bazel build tensorflow/tools/graph_transforms:transform_graph \
  && bazel build tensorflow/tools/graph_transforms:summarize_graph


CMD ["/bin/bash"]
