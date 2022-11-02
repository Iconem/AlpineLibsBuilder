#!/bin/bash

# clean the build folder
rm -r build
mkdir build && cd build

# build alpine image containing the executables
docker build -t alpine-libs-builder ..

# launch a container containing the executables
PID=$(docker run -itd alpine-libs-builder)

# fetch the container's camCalibNode executable + opencv executables
mkdir PNPSolver
docker cp "$PID:/home/executables/PNPSolver/build/camCalibNode" ./PNPSolver
docker cp "$PID:/home/lib/opencv3.1.0/build/lib" ./PNPSolver

# fetch the container's PotreeConverter1.7 executable + LASzip executables
mkdir PotreeConverter1.7
docker cp "$PID:/home/executables/PotreeConverter1.7/build/PotreeConverter/PotreeConverter" ./PotreeConverter1.7
mkdir ./PotreeConverter1.7/lib
docker cp "$PID:/home/lib/LAStools/LASzip/dll" ./PotreeConverter1.7/lib
mv ./PotreeConverter1.7/lib/dll/* ./PotreeConverter1.7/lib
rm -r ./PotreeConverter1.7/lib/dll
docker cp "$PID:/home/lib/LAStools/LASzip/build/src/liblaszip.so" ./PotreeConverter1.7/lib


# fetch the container's PotreeConverter2.1 executable into build folder
mkdir PotreeConverter2.1
docker cp "$PID:/home/executables/PotreeConverter2.1/build/PotreeConverter" ./PotreeConverter2.1

# clean the container
docker stop "$PID"
docker rm "$PID"