#!/bin/bash -e

mounted_dir='/tmp/tensorflow'

# Frozen graph
docker run --rm \
  -v $PWD:${mounted_dir} \
  yuiskw/tensorflow-tools:tf-1.4.1-devel \
  ./bazel-bin/tensorflow/python/tools/freeze_graph \
    --input_graph="${mounted_dir}/model/graph.pb" \
    --input_checkpoint="${mounted_dir}/model/model.ckpt" \
    --output_graph="${mounted_dir}/frozen/frozen_graph.pb" \
    --input_binary=true \
    --output_node_names=Softmax

# Optimize graph
docker run --rm \
  -v $PWD:${mounted_dir} \
  yuiskw/tensorflow-tools:tf-1.4.1-devel \
  ./bazel-bin/tensorflow/python/tools/optimize_for_inference \
    --input="${mounted_dir}/frozen/frozen_graph.pb" \
    --output="${mounted_dir}/frozen/optimized_graph.pb" \
    --frozen_graph=True \
    --input_names=image_input \
    --output_names=Softmax
