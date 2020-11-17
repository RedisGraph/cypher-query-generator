#!/bin/bash

while read line
do
  echo "$line"
  echo "$line" >> queries.log
  redis-cli GRAPH.QUERY G "$line"
done < "${1:-/dev/stdin}"