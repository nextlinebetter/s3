# my version of `precompute.sh`
# precompute the naïve RAG Cache for training

# preconstruct dataset without RAG Retrieval
bash scripts/dataset_construct/data_process_s3_pre_my.sh 

# prepare Naïve RAG Retrieval for Training and Test Set
bash scripts/baselines/run_retrieval_my.sh 

# run Generator with RAG Retrieval and save the RAG Cache
# [WARNING] This step takes REALLY REALLY long time, since we are using faiss-cpu, so we download the result instead!
bash scripts/evaluation/run_rag_cache_my.sh

# construct dataset with RAG Retrieval
bash scripts/dataset_construct/data_process_s3.sh