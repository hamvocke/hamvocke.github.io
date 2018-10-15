#! /usr/bin/env bash

set -e

echo "Transfer website to server"
rsync -rvz _site/ root@ham.codes:/tmp/blog

echo "Archive old website, activate current version"
ssh -T root@ham.codes << EOF
    rm -rf /data/archive/blog
    mkdir -p /data/archive && mv /data/blog/ /data/archive/blog/
    mv /tmp/blog/ /data/blog/
EOF

echo "Done"
