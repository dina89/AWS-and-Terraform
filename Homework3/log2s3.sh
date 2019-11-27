#! /bin/bash -xv
/usr/local/bin/aws2 s3 cp /var/log/nginx/access.log s3://opsschool-dina-state-storage-s3/temp/