# FROM pytorch/pytorch:1.7.1-cuda11.0-cudnn8-devel
FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

# pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime has python version 3.10.9, system version Ubuntu 18.04.6 LTS

LABEL maintainer="Yibo Lin <yibolin@pku.edu.cn>"

# Rotates to the keys used by NVIDIA as of 27-APR-2022.
RUN rm /etc/apt/sources.list.d/cuda.list 2>/dev/null || true
RUN rm /etc/apt/sources.list.d/nvidia-ml.list 2>/dev/null || true

RUN apt-get update && apt-get install -y gnupg

RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub


# Installs system dependencies.
RUN apt-get update \
        && apt-get install -y \
            flex \
            libcairo2-dev \
            libboost-all-dev 


# Installs system dependencies from conda.
RUN conda install -y -c conda-forge bison

# Installs cmake.
ADD https://cmake.org/files/v3.21/cmake-3.21.0-linux-x86_64.sh /cmake-3.21.0-linux-x86_64.sh
RUN mkdir /opt/cmake \
        && sh /cmake-3.21.0-linux-x86_64.sh --prefix=/opt/cmake --skip-license \
        && ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake \
        && cmake --version

# Installs python dependencies. 
RUN pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
RUN pip install \
        pyunpack>=0.1.2 \
        patool>=1.12 \
        matplotlib>=2.2.2 \
        cairocffi>=0.9.0 \
        pkgconfig>=1.4.0 \
        setuptools>=39.1.0 \
        scipy>=1.1.0 \
        numpy>=1.15.4 \
        shapely>=1.7.0

# command to run this container
# docker run -it --gpus all -v $(pwd):/DREAMPlace wenh06/dreamplace:cuda
