from nvidia/cuda-ppc64le:10.0-cudnn7-devel-ubuntu18.04 as builder

maintainer Peixinho (alanpeixinho81@gmail.com)

run apt-get update -y && apt-get install -y openjdk-8-jdk python python-pip unzip libhdf5-serial-dev python-h5py wget unzip zip libprotobuf-dev protobuf-compiler && rm -rf /var/lib/apt/lists

run pip install numpy==1.16

#bazel 0.15 to compile tensorflow 1.12
add build_bazel.sh /opt/bazel/
run cd /opt/bazel && ./build_bazel.sh

#build tensorflow
add build_tensorflow.sh /opt/tensorflow/
run cd /opt/tensorflow && ./build_tensorflow.sh


from nvidia/cuda-ppc64le:10.0-cudnn7-runtime-ubuntu18.04
copy --from=builder /tmp/* /tmp/

run apt-get update -y && apt-get install -y python python-pip libhdf5-serial-dev python-h5py protobuf-compiler && rm -rf /var/lib/apt/lists
