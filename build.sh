rm -r build
mkdir build
docker build -t alpine-libs-builder .
PID=$(docker run -itd alpine-libs-builder)
docker cp "$PID:/home/lib/PNPSolver/build/camCalibNode" ./build
docker cp "$PID:/home/lib/PotreeConverter1.7/build/PotreeConverter/PotreeConverter" ./build/PotreeConverter1.7
docker cp "$PID:/home/lib/PotreeConverter2.1/build/PotreeConverter" ./build/PotreeConverter2.1
docker stop "$PID"
docker rm "$PID"