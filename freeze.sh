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

# Quantize graph
docker run --rm \
  -v $PWD:${mounted_dir} \
  yuiskw/tensorflow-tools:tf-1.4.1-devel \
  ./bazel-bin/tensorflow/tools/graph_transforms/transform_graph \
  --in_graph="${mounted_dir}/frozen/optimized_graph.pb" \
  --out_graph="${mounted_dir}/frozen/eightbit_graph.pb" \
  --inputs=image_input \
  --outputs=Softmax \
  --transforms='
add_default_attributes
remove_nodes(op=Identity, op=CheckNumerics)
fold_constants(ignore_errors=true)
fold_batch_norms
fold_old_batch_norms
fuse_resize_and_conv
quantize_weights
quantize_nodes
strip_unused_nodes
sort_by_execution_order'
