#/bin/bash

for username in $(cat ./username.txt)
do
for password in $(cat ./password.txt)
do
    python ./test.py username password
done
done
