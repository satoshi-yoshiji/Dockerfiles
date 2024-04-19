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

# install R
ARG R_VERSION=4.2.3
ARG OS_IDENTIFIER=ubuntu-2204

RUN \
  wget https://cdn.posit.co/r/${OS_IDENTIFIER}/pkgs/r-${R_VERSION}_1_amd64.deb && \
  apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -f -y ./r-${R_VERSION}_1_amd64.deb && \
  ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
  ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
  ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R && \
  rm r-${R_VERSION}_1_amd64.deb && \
  rm -rf /var/lib/apt/lists/*

# how to push
# docker buildx build  -f Dockerfile --platform linux/amd64 -t sysgits/polyfun:latest --push .

