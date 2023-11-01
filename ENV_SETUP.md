# ENV SETUP
## ABCI
```
# local
ssh-add ~/.ssh/id_rsa
ssh -A -o ServerAliveInterval=1 abci
# ABCI
cd /scratch/$USER
git clone git@github.com:kenoharada/llama2-playground.git
cd llama2-playground
git clone git@github.com:facebookresearch/llama.git
qrsh -g $GROUP_ID -l rt_AF=1 -l h_rt=4:00:00 -l USE_SSH=1 -v SSH_PORT=2299
cd /scratch/$USER/llama2-playground
# 一度だけ実行すれば良い
module load singularitypro
singularity build -f llama2.sif llama2.def
# llama関係
cd llama
bash download.sh
singularity exec --bind /scratch/$USER/llama2-playground:/scratch/$USER/llama2-playground --pwd /scratch/$USER/llama2-playground/llama --nv /scratch/$USER/llama2-playground/llama2.sif torchrun --nproc_per_node 1 example_text_completion.py \
    --ckpt_dir llama-2-7b/ \
    --tokenizer_path tokenizer.model \
    --max_seq_len 128 --max_batch_size 4
```

## Docker
```
ssh-add ~/.ssh/id_rsa
ssh -A -o ServerAliveInterval=1 {server_name}
git clone git@github.com:kenoharada/llama2-playground.git
cd llama2-playground
docker build -t llama2-playground .
export PORT_NUM=8890
docker run -p $PORT_NUM:$PORT_NUM --mount type=bind,src=$PWD,dst=$PWD --workdir $PWD -it --ipc host --gpus all --rm --name `whoami`_llama2-playground llama2-playground jupyter lab --port $PORT_NUM --ip=0.0.0.0 --allow-root
# localの別terminalで, tokenを入力
ssh -NfL localhost:8890:localhost:8890 {server_name}; open http://localhost:8890/?token=
```

## Singularity