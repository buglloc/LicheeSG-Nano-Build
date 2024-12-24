#!/bin/bash -e

echo "apply patches..."
for dir in $(ls -d ./patches/*/) ; do
  toplevel="$(basename $dir)"
  for patch in $(ls $dir/*.patch); do
    echo "apply patch to $toplevel: $(basename $patch)"
    patch_path=$(realpath $patch)
    (cd $toplevel && patch -p1 < $patch_path)
  done
done

echo "build..."
./build-nanokvm.sh

echo "reverse patches..."
for dir in $(ls -dr ./patches/*/) ; do
  toplevel="$(basename $dir)"
  for patch in $(ls -r $dir/*.patch); do
    echo "apply patch to $toplevel: $(basename $patch)"
    patch_path=$(realpath $patch)
    (cd $toplevel && patch -R -p1 < $patch_path)
  done
done
