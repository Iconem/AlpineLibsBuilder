# clean the build folder
rm -r build
mkdir build

# build alpine image containing the executables
docker build -t alpine-libs-builder .

# launch a container containing the executables
PID=$(docker run -itd alpine-libs-builder)

# fetch the container's executables into build folder
docker cp "$PID:/home/lib/PNPSolver/build/camCalibNode" ./build
docker cp "$PID:/home/lib/PotreeConverter1.7/build/PotreeConverter/PotreeConverter" ./build/PotreeConverter1.7
docker cp "$PID:/home/lib/PotreeConverter2.1/build/PotreeConverter" ./build/PotreeConverter2.1

# clean the container
docker stop "$PID"
docker rm "$PID"