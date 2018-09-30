#!/bin/sh

vocab="data.debug/vocab.bin"
train_src="data.debug/train.de-en.de.wmixerprep"
train_tgt="data.debug/train.de-en.en.wmixerprep"
dev_src="data.debug/valid.de-en.de"
dev_tgt="data.debug/valid.de-en.en"
#test_src="data.debug/test.de-en.de"
#test_tgt="data.debug/test.de-en.en"
test_src=$train_src
test_tgt=$train_tgt

work_dir="work_dir.debug"

mkdir -p ${work_dir}
echo save results to ${work_dir}

python nmt.py \
    decode \
    --cuda \
    --beam-size 1 \
    --max-decoding-time-step 100 \
    ${work_dir}/model.bin \
    ${test_src} \
    ${work_dir}/decode.txt

perl multi-bleu.perl ${test_tgt} < ${work_dir}/decode.txt
