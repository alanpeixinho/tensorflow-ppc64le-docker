from nvidia/cuda-ppc64le:10.0-cudnn7-devel-ubuntu18.04 as builder

maintainer Peixinho (alanpeixinho81@gmail.com)

run apt-get update -y && apt-get install -y openjdk-8-jdk python python-pip unzip libhdf5-serial-dev python-h5py wget unzip zip libprotobuf-dev protobuf-compiler && rm -rf /var/lib/apt/lists

run pip install numpy==1.16

#bazel 0.15 to compile tensorflow 1.12
run mkdir /opt/bazel && cd /opt/bazel/ && wget https://github.com/bazelbuild/bazel/releases/download/0.15.0/bazel-0.15.0-dist.zip && unzip bazel-0.15.0-dist.zip && env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh && mv output/bazel /usr/local/bin/ && cd /opt/ && rm -r bazel

#build tensorflow
run mkdir /opt/tensorflow/ && cd /opt/tensorflow/ && wget https://github.com/tensorflow/tensorflow/archive/v1.12.2.zip && unzip v1.12.2.zip && cd tensorflow-1.12.2/ env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" PYTHON_BIN_PATH="/usr/bin/python" PYTHON_LIB_PATH="/usr/local/lib/python2.7/dist-packages" CUDA_TOOLKIT_PATH="/usr/local/cuda-10.0/" bash ./compile.sh 

from nvidia/cuda-ppc64le:10.0-cudnn7-runtime-ubuntu18.04

copy --from=builder /tmp/* /tmp/

run apt-get update -y && apt-get install -y python python-pip libhdf5-serial-dev python-h5py protobuf-compiler && rm -rf /var/lib/apt/lists

