#!/bin/bash

role=$1

if [ "$role" != "agent" ] && [ "$role" != "aggregator" ]; then
  echo "Invalid role. Please provide 'agent' or 'aggregator' as a parameter."
  exit 1
fi

new_dir="build-${role}"

mkdir -p "$new_dir"

rsync -a --exclude='build.sh' ./charts/vector "$new_dir"

sed -i '' '2s/vector/'${role}'/' "$new_dir/vector/Chart.yaml"

cp -f "./charts/vector/values-${role}.yaml" "$new_dir/vector/values.yaml"

helm package "$new_dir/vector"

rm -rf "$new_dir"