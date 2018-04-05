#!/bin/bash -e

mounted_dir=/var/data
docker run --rm \
  -v ${PWD}:${mounted_dir} \
  tensorflow/tensorflow:1.4.1-devel \
  python /tensorflow/tensorflow/python/tools/freeze_graph.py \
    --input_graph="${mounted_dir}/model/graph.pb" \
    --input_checkpoint="${mounted_dir}/model/model.ckpt" \
    --output_graph="${mounted_dir}/frozen/frozen_graph.pb"
