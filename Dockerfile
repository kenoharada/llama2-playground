FROM nvcr.io/nvidia/pytorch:23.10-py3

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y
RUN pip install setuptools
RUN pip install install wandb tqdm tiktoken transformers deepspeed openai PyYAML accelerate datasets einops evaluate peft protobuf scikit-learn scipy sentencepiece fire mpi4py fairscale
# for JGLUE
RUN pip install bs4 zenhan mecab-python3 pyknp ipadic
RUN pip install bitsandbytes
CMD ["/bin/bash"]