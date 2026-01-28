# my version of `host.sh`
export CUDA_VISIBLE_DEVICES=0  # one of the 3 cards, same as retriever

model_name=Qwen/Qwen2.5-14B-Instruct-GPTQ-Int4
model_path=models/generator/$model_name  # local model path
cache_dir=cache/huggingface/hub  # custom cache dir

# Download models to project directory, with no pollution to ~/.cache
hf download $model_name --local-dir $model_path --cache-dir $cache_dir

python3 -m vllm.entrypoints.openai.api_server \
    --model $model_path \
    --port 8000 \
    --max-model-len 8192 \
    --tensor-parallel-size 1

    # --model Qwen/Qwen2.5-14B-Instruct-GPTQ-Int4 \
    # --model Qwen/Qwen2.5-7B-Instruct-GGUF\