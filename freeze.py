import sys
import argparse

import tensorflow as tf


def main(_):
    meta_path = FLAGS.meta_path
    checkpoint_path = FLAGS.checkpoint_path
    output_path = FLAGS.output_path

    output_node_names = [FLAGS.output_tensor]
    with tf.Session() as sess:
        # Restore the graph
        saver = tf.train.import_meta_graph(meta_path)
        # Load weights
        saver.restore(sess, checkpoint_path)

        # Print debug
        [print(n.name) for n in tf.get_default_graph().as_graph_def().node]

        # Freeze the graph
        graph = tf.get_default_graph()
        # Convert variables to constants
        frozen_graph_def = tf.graph_util.convert_variables_to_constants(
            sess,
            graph.as_graph_def(),
            output_node_names)
        # Remove training nodes
        frozen_graph_def = tf.graph_util.remove_training_nodes(frozen_graph_def)

        # Save the frozen graph
        with open(output_path, 'wb') as f:
            f.write(frozen_graph_def.SerializeToString())
            print('Frozen file is {}'.format(output_path))


if __name__ == '__main__':
    default_meta_path = "./model/model.ckpt.meta"
    default_checkpoint_path = "./model/model.ckpt"
    default_output_path = "./frozen/model.pb"
    default_output_tensor = "logits"

    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--meta_path',
        default=default_meta_path,
        help='path to model meta')
    parser.add_argument(
        '--checkpoint_path',
        default=default_checkpoint_path,
        help='path to check point')
    parser.add_argument(
        '--output_path',
        default=default_output_path,
        help='path to output file')
    parser.add_argument(
        '--output_tensor',
        default=default_output_tensor,
        help='output tensor name')

    FLAGS, unparsed = parser.parse_known_args()
    tf.app.run(main=main, argv=[sys.argv[0]] + unparsed)
