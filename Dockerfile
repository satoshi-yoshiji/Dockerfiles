FROM --platform=linux/amd64 ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="$HOME/local/bin:/root/miniconda3/bin:${PATH}"

WORKDIR /root

# Install essential and additional libraries
RUN apt update && \
    apt install -y build-essential python3-dev cmake git vim wget unzip openjdk-8-jre-headless libbz2-dev liblzma-dev zlib1g-dev libfontconfig1-dev libssl-dev libxml2-dev libcurl4-openssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    mkdir /root/.conda && \
    bash Miniconda3-latest-Linux-x86_64.sh -b && \
    rm -f Miniconda3-latest-Linux-x86_64.sh

# Verify conda installation
RUN conda --version

# Install conda packages
RUN conda install numpy scipy scikit-learn pyarrow bitarray conda-forge::tqdm

# Install Python packages with pip
RUN pip install pandas-plink

# how to push
# docker buildx build  -f Dockerfile --platform linux/amd64 -t sysgits/polyfun:latest --push .

