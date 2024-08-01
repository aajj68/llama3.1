# Utilize a imagem oficial do PyTorch como base
FROM pytorch/pytorch:1.9.0-cuda11.1-cudnn8-runtime

# Defina o diretório de trabalho
WORKDIR /app

# Instale as dependências necessárias
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libatlas-base-dev \
    libboost-all-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libhdf5-dev \
    liblmdb-dev \
    libopencv-dev \
    libprotobuf-dev \
    libsnappy-dev \
    libsqlite3-dev \
    libssl-dev \
    libtorch-dev \
    libyaml-cpp-dev \
    zlib1g-dev \
    wget \
    python3-pip

# Clone o repositório do LLaMA 3.1
RUN git clone https://github.com/facebookresearch/llama.git

# Clone o repositório do Open WebUI
RUN git clone https://github.com/openai/open-webui.git

# Copie o requirements.txt para o container
COPY requirements.txt /app/

# Instale as dependências do LLaMA 3.1
RUN cd llama && pip install -r /app/requirements.txt

# Instale as dependências do Open WebUI
RUN cd open-webui && pip install -r requirements.txt

# Baixe o modelo LLaMA 3.1-130b
RUN wget https://dl.fbaipublicfiles.com/llama/llama-3.1-130b.tar.gz && \
    tar -xvf llama-3.1-130b.tar.gz && \
    rm llama-3.1-130b.tar.gz

# Defina as variáveis de ambiente
ENV PYTORCH_CUDA_ARCH_LIST="8.6"  # NVIDIA GeForce RTX 2060
ENV PYTORCH_CUDA_HOME="/usr/local/cuda-11.1"
ENV CUDA_VISIBLE_DEVICES="0"  # Utilize a GPU 0

# Exponha as portas para o serviço do LLaMA 3.1 e a interface web
EXPOSE 9090 9095

# Defina o comando para executar o serviço do LLaMA 3.1 e o Open WebUI
CMD ["sh", "-c", "python -m llama.server --model llama-3.1-130b --port 9090 & python -m open_webui.server --port 9095"]
