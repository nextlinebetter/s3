# my version of `data_process_s3_pre.sh`
LOCAL_DIR=data/demo/nq_hotpotqa_train
cache_dir=cache/huggingface/datasets

pwd

# Download datasets to local directory, with no pollution to ~/.cache
hf download --repo-type dataset RUC-NLPIR/FlashRAG_datasets --include "nq/*" --local-dir $LOCAL_DIR --cache-dir $cache_dir
hf download --repo-type dataset RUC-NLPIR/FlashRAG_datasets --include "hotpotqa/*" --local-dir $LOCAL_DIR --cache-dir $cache_dir
hf download --repo-type dataset RUC-NLPIR/FlashRAG_datasets --include "triviaqa/*" --local-dir $LOCAL_DIR --cache-dir $cache_dir
hf download --repo-type dataset RUC-NLPIR/FlashRAG_datasets --include "popqa/*" --local-dir $LOCAL_DIR --cache-dir $cache_dir
hf download --repo-type dataset RUC-NLPIR/FlashRAG_datasets --include "2wikimultihopqa/*" --local-dir $LOCAL_DIR --cache-dir $cache_dir
hf download --repo-type dataset RUC-NLPIR/FlashRAG_datasets --include "musique/*" --local-dir $LOCAL_DIR --cache-dir $cache_dir
hf download --repo-type dataset RUC-NLPIR/FlashRAG_datasets --include "bamboogle/*" --local-dir $LOCAL_DIR --cache-dir $cache_dir

## process multiple dataset search format train file
DATA=nq,hotpotqa
python scripts/data_process/train_ug_my.py --local_dir $LOCAL_DIR --data_sources $DATA --retriever e5

## process multiple dataset search format test file
DATA=nq,triviaqa,popqa,hotpotqa,2wikimultihopqa,musique,bamboogle
python scripts/data_process/test_ug_my.py --local_dir $LOCAL_DIR --data_sources $DATA --retriever e5
