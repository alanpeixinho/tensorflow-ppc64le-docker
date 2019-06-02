
from nvidia/cuda-ppc64le:10.0-cudnn7-devel-ubuntu18.04 as builder

maintainer Peixinho (alanpeixinho81@gmail.com)

ENV HDF5_INCLUDE_PATH=/usr/include/hdf5/serial/
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

run apt-get update -y && apt-get install -y openjdk-8-jdk python3 python3-dev libpython3-dev python3-pip unzip libhdf5-dev libhdf5-serial-dev python-h5py wget unzip zip python python-dev python-pip expect && rm -rf /var/lib/apt/lists

env CPATH=$CPATH:/usr/include/hdf5/serial/
run ln -s /usr/lib/powerpc64le-linux-gnu/libhdf5_serial.so /usr/lib/powerpc64le-linux-gnu/libhdf5.so && ln -s /usr/lib/powerpc64le-linux-gnu/libhdf5_serial_hl.so /usr/lib/powerpc64le-linux-gnu/libhdf5_hl.so

#run find / -name "*libhdf5*.so"

run pip install numpy==1.16 protobuf==3.6.1 six wheel mock Keras-Applications==1.0.8 Keras-Preprocessing==1.1.0
run python -c "import keras_applications; print(keras_applications.__version__)"

#bazel 0.15 to compile tensorflow 1.12
add build_bazel.sh /opt/bazel/
run cd /opt/bazel && ./build_bazel.sh


#build tensorflow
add build_tensorflow.sh /opt/tensorflow/
add script.exp /opt/tensorflow/
run cd /opt/tensorflow && ./build_tensorflow.sh


from nvidia/cuda-ppc64le:10.0-cudnn7-runtime-ubuntu18.04
copy --from=builder /tmp/tensorflow_pkg /tmp/

run apt-get update -y &&  apt-get install -y unzip libhdf5-dev libhdf5-serial-dev python-h5py wget unzip zip python python-dev python-pip && rm -rf /var/lib/apt/lists
run pip install --upgrade pip
run pip install numpy==1.16 protobuf==3.6.1 six wheel mock Keras-Applications==1.0.8 Keras-Preprocessing==1.1.0
run pip install /tmp/tensorflow-1.12.2-cp27-cp27mu-linux_ppc64le.whl