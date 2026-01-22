# my version of `run_rag_cache.sh`
python scripts/evaluation/context.py \
    --input_file data/demo/nq_hotpotqa_train/train_e5_ug.parquet \
    --result_file data/demo/rag_cache/rag_cache.json \
    --context_dir data/demo/RAG_Retrieval/train \
    --num_workers 16 \
    --topk 3 \
    --model Qwen/Qwen2.5-14B-Instruct-GPTQ-Int4