#!/usr/bin/env sh

######################################################################
# @author      : t-hara (t-hara@$HOSTNAME)
# @file        : test-chatdoctor
# @created     : Sunday Nov 09, 2025 03:26:47 JST
#
# @description : 
######################################################################
set -x
rm -rf log/*
VLLM_PID=1319742
NUM_DATA=10000
for j in `seq 1 1`
do
  TYPE=benign-${j}
  mkdir -p ../chatdoctor/log/${TYPE}
  INPUT_DIR=../chatdoctor/prompt
  TRIALS=`seq 423 $NUM_DATA`
  for i in $TRIALS
  do
    RESDIR=../chatdoctor/log/${TYPE}/${i}/
    mkdir -p ${RESDIR}
    sudo ../libbpf-bootstrap/examples/tracing/nvml_trace > ${RESDIR}/nvml.csv &
    sudo ../libbpf-bootstrap/examples/tracing/cuda_trace --pid $VLLM_PID > ${RESDIR}/cuda.csv &
    sudo ../libbpf-bootstrap/examples/tracing/cpu_trace --pid $VLLM_PID > ${RESDIR}/cpu.csv &
    /home/is/t-hara/llm-dos/.venv/bin/python professional_iterative_generation.py --attack-model Qwen2.5-1.5B --target-model Qwen2.5-1.5B --target-max-n-tokens 2048 --attack-max-n-tokens 2048 --prompt-file ${INPUT_DIR}/${i}.json
    sleep 1
    sudo pkill -9 cuda_trace
    sudo pkill -9 cpu_trace
    sudo pkill -9 nvml_trace
    mv log/* ${RESDIR}/log.json
    sleep 5
  done
done

# for j in `seq 1 10`
# do
#   TYPE=dos-${j}
#   mkdir -p ../chatdoctor/log/${TYPE}
#   INPUT_DIR=../chatdoctor/dos-prompt
#   TRIALS=`seq 1 $NUM_DATA`
#   for i in $TRIALS
#   do
#     RESDIR=../chatdoctor/log/${TYPE}/${i}/
#     mkdir -p ${RESDIR}
#     sudo ../libbpf-bootstrap/examples/tracing/nvml_trace > ${RESDIR}/nvml.csv &
#     sudo ../libbpf-bootstrap/examples/tracing/cuda_trace --pid $VLLM_PID > ${RESDIR}/cuda.csv &
#     sudo ../libbpf-bootstrap/examples/tracing/cpu_trace --pid $VLLM_PID > ${RESDIR}/cpu.csv &
#     /home/is/t-hara/llm-dos/.venv/bin/python professional_iterative_generation.py --attack-model Qwen2.5-1.5B --target-model Qwen2.5-1.5B --target-max-n-tokens 2048 --attack-max-n-tokens 2048 --prompt-file ${INPUT_DIR}/${i}.json
#     sleep 1
#     sudo pkill -9 cuda_trace
#     sudo pkill -9 cpu_trace
#     sudo pkill -9 nvml_trace
#     mv log/* ${RESDIR}/log.json
#     sleep 5
#   done
# done
