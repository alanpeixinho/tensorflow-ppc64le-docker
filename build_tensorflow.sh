CUDA_HOME="/usr/local/cuda-10.0"
CUDNN_VERSION="7"
NCCL_VERSION="2.2"

# Cuda parameters
export CUDA_TOOLKIT_PATH="$CUDA_HOME"
export CUDNN_INSTALL_PATH="$CUDA_HOME"
export TF_CUDA_VERSION="$CUDA_VERSION"
export TF_CUDNN_VERSION="$CUDNN_VERSION"
export TF_NEED_CUDA=1
export TF_NEED_TENSORRT=0
export TF_NCCL_VERSION=$NCCL_VERSION
export NCCL_INSTALL_PATH=$CUDA_HOME
export NCCL_INSTALL_PATH=$CUDA_HOME
# Those two lines are important for the linking step.
export LD_LIBRARY_PATH="$CUDA_TOOLKIT_PATH/lib64:${LD_LIBRARY_PATH}"
ldconfig

wget https://github.com/tensorflow/tensorflow/archive/v1.12.2.zip
unzip v1.12.2.zip
cd tensorflow-1.12.2/
./configure
bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh

#create pip package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

