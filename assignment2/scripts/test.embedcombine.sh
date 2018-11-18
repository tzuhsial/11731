#!/bin/sh

l1=$1
l2=$2
beam_size=$3

train_src="data/train.en-$l1+$l2.$l1+$l2.txt"
train_tgt="data/train.en-$l1+$l2.en.txt"
dev_src="data/dev.en-$l1.$l1.txt"
dev_tgt="data/dev.en-$l1.en.txt"
test_src="data/test.en-$l1.$l1.txt"
test_tgt="data/test.en-$l1.en.txt"

work_dir="work_dir.$l1+$l2-en.embed"

echo "For testing, we only test $l1"

echo decoding $dev_src ...
python embed_nmt.py \
    decode \
    --beam-size ${beam_size} \
    --max-decoding-time-step 100 \
    ${work_dir}/model.bin \
    ${dev_src} \
    ${work_dir}/decode.dev.beam$beam_size.txt

perl multi-bleu.perl ${dev_tgt} < ${work_dir}/decode.dev.beam$beam_size.txt

echo decoding $test_src ...
python embed_nmt.py \
    decode \
    --beam-size ${beam_size} \
    --max-decoding-time-step 100 \
    ${work_dir}/model.bin \
    ${test_src} \
    ${work_dir}/decode.test.beam$beam_size.txt

perl multi-bleu.perl ${test_tgt} < ${work_dir}/decode.test.beam$beam_size.txt

