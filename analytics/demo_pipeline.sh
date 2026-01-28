# 1) Download Corpus and Index
# use mirror site
# export HF_ENDPOINT=https://hf-mirror.com  # alter: use clash instead

# download and post-process corpus and index
save_path=data/demo
python scripts/download.py --save_path $save_path
cat $save_path/part_* > $save_path/e5_Flat.index
gzip -d $save_path/wiki-18.jsonl.gz


# 2) Precompute Naïve RAG Initialization
# deploy retriever
# env: (ret)
bash scripts/deploy_retriever/retrieval_launch_my.sh  # or scripts/deploy_retriever/retrieval_launch_mirage.sh for MedCorp corpus.

# deploy generator
# env: (s3)
bash generator_llms/host_my.sh  # modify tensor-parallel-size to the number of GPUs you use

# run precompute
# env: (s3)
# [WARNING] This step takes REALLY REALLY long time, since we are using faiss-cpu, so we download the result instead!
bash scripts/precompute_my.sh  # this step will take a while, as it will precompute the naïve RAG Cache for training

# alter: download precomputed cache instead of running the above step
hf download --repo-type dataset pat-jj/s3_processed_data --include "*e5_s3.parquet" --local-dir data/demo/nq_hotpotqa_train --cache-dir cache/huggingface/datasets
hf download --repo-type dataset pat-jj/s3_processed_data --include "rag_cache.json" --local-dir data/demo/rag_cache --cache-dir cache/huggingface/datasets

# 3) Run Training
# deploy retriever
# env: (ret)
bash scripts/deploy_retriever/retrieval_launch_my.sh

# deploy generator
# env: (s3)
bash generator_llms/host_my.sh

# run training
# env: (s3)
bash scripts/train/train_s3_my.sh