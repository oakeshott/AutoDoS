#!/usr/bin/env sh

######################################################################
# @author      : t-hara (t-hara@$HOSTNAME)
# @file        : make-dos-prompt
# @created     : Sunday Nov 09, 2025 23:16:55 JST
#
# @description : 
######################################################################

set -x
NUM_DATA=1000
INPUT_DIR=../chatdoctor/dos-prompt
mkdir -p $INPUT_DIR
# TRIALS=`seq 388 500`
# TRIALS=`seq 388 $NUM_DATA`
TRIALS="185 203 208 214 218 257 266 278 280 282 286 316 330 339 353 "
for i in $TRIALS
do
  DESCRIPT=`cat ../chatdoctor/prompt/${i}.json | jq -r '.[0]'`
  python professional_iterative_generation.py --attack-model Qwen2.5-1.5B --target-model Qwen2.5-1.5B --target-max-n-tokens 2048 --attack-max-n-tokens 2048 --prompt-file ${INPUT_DIR}/${i}.json --function-descript "${DESCRIPT}"
done


