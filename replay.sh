#!/bin/bash

for f in sys_http_recording/*
do
  url=`grep "GET " $f | cut -d " " -f 2 `
  wget -O /dev/null http://localhost:8890${url}
done