#! /usr/bin/env bash

set -e

echo "Upload website to S3"
aws s3 sync _site/ s3://devbox-bucket.ham.codes/blog/

echo "Transfer website to server"
rsync -rvz _site/ root@ham.codes:/tmp/blog

echo "Archive old website, activate current version"
ssh -T root@ham.codes << EOF
    rm -rf /data/archive/blog
    mkdir -p /data/archive && mv /data/blog/ /data/archive/blog/
    mv /tmp/blog/ /data/blog/
EOF

echo "Done"
