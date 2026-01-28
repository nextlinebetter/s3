# my version of `retrieval_launch.sh`
# export CUDA_VISIBLE_DEVICES=0,1,2  # all of the 3 cards, only in precompute rag_cache step
export CUDA_VISIBLE_DEVICES=0  # one of the 3 cards, same as generator
# export HF_ENDPOINT=https://hf-mirror.com  # alter: use clash instead

file_path=data/demo
index_file=$file_path/e5_Flat.index
corpus_file=$file_path/wiki-18.jsonl
retriever_name=e5
retriever_path=models/retriever/e5-base-v2  # local model path
cache_dir=cache/huggingface/hub

# Download models to project directory, with no pollution to ~/.cache
hf download intfloat/e5-base-v2 --local-dir $retriever_path --cache-dir $cache_dir

# We do not use faiss_gpu, for the index requires at least 60GB memory. Instead, we store it in CPU.
python s3/search/retrieval_server_my.py --index_path $index_file \
                                            --corpus_path $corpus_file \
                                            --topk 12 \
                                            --retriever_name $retriever_name \
                                            --retriever_model $retriever_path \
                                            --port 3000
                                            # --faiss_gpu  # enable faiss gpu, only in precompute rag_cache step
                                            # --port 7000
