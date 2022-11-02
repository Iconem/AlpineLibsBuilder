FROM node:16.14.0-alpine3.15

# install dependencies
RUN apk update
RUN apk add \
  # utilities
  bash git wget curl tar findutils \
  # to compile PotreeConverter
  cmake g++ build-base libtbb-dev

WORKDIR /home/lib

# install opencv 3.1.0 (for PNP solver)
RUN mkdir opencv3.1.0 && cd opencv3.1.0 \
  && wget -O opencv.tar.gz https://github.com/opencv/opencv/archive/3.1.0.tar.gz \
  && tar -xf opencv.tar.gz --strip-components=1 \
  && mkdir build && cd build && \
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DENABLE_PRECOMPILED_HEADERS=OFF .. \
  && make -j7 \
  && make install

# download and build LASzip (for PotreeConverter v1.7)
RUN git clone https://github.com/m-schuetz/LAStools.git \
  && cd LAStools/LASzip && mkdir build && cd build \
  && cmake -DCMAKE_BUILD_TYPE=Release .. \
  && make


WORKDIR /home/executables
# download and build PotreeConverter v2.1
# "sed" command is here to ensure cmake uses the flag "-U_FORTIFY_SOURCE",
# otherwise PotreeConverter won't compile because of alpine default security flag : "-D_FORTIFY_SOURCE=2"
# see here : https://github.com/opencv/opencv/issues/15020#issuecomment-575932630
RUN mkdir PotreeConverter2.1 && cd PotreeConverter2.1 \
  && wget -O ./PotreeConverter.tar.gz https://github.com/potree/PotreeConverter/archive/refs/tags/2.1.tar.gz \
  && tar -xf ./PotreeConverter.tar.gz --strip-components=1 \
  && rm PotreeConverter.tar.gz \
  && sed -i '64i\\tSET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -U_FORTIFY_SOURCE")' CMakeLists.txt \
  && mkdir build && cd build && cmake .. && make \
  && chmod +x PotreeConverter \
  && chown -R node PotreeConverter


# download and build PotreeConverter v1.7
# * 1st "sed" command : use c++17 standard instead of c++14 
#   otherwise we get an error "‘filesystem’ is not a namespace-name"
#   see https://stackoverflow.com/a/48312534
# * 2nd "sed" command : include missing library 
#   otherwise we get an error "'memcpy' was not declared in this scope"
#   see https://github.com/potree/PotreeConverter/issues/327#issuecomment-623023375
# * other "sed" commands : fix a cast error
#   see https://github.com/potree/PotreeConverter/issues/382#issuecomment-559613216
RUN mkdir PotreeConverter1.7 && cd PotreeConverter1.7 && wget -O ./PotreeConverter.tar.gz https://github.com/potree/PotreeConverter/archive/refs/tags/1.7.tar.gz \
  && tar -xf ./PotreeConverter.tar.gz --strip-components=1 \
  && rm PotreeConverter.tar.gz \
  && sed -i -e "s/c++14/c++17/g" PotreeConverter/CMakeLists.txt \
  && sed -i '6i#include <cstring>' PotreeConverter/src/BINPointReader.cpp \
  && sed -i '298d' PotreeConverter/src/PotreeWriter.cpp \
  && sed -i '298i\\t\t\t\t\tPotree::Point point = reader->getPoint();' PotreeConverter/src/PotreeWriter.cpp \
  && sed -i '299i\\t\t\t\t\twriter->write(point);' PotreeConverter/src/PotreeWriter.cpp \
  && mkdir build && cd build \
  && cmake -DCMAKE_BUILD_TYPE=Release -DLASZIP_INCLUDE_DIRS=/home/lib/LAStools/LASzip/dll -DLASZIP_LIBRARY=/home/lib/LAStools/LASzip/build/src/liblaszip.so ..  \
  && make \
  && chmod +x PotreeConverter/PotreeConverter \
  && chown -R node PotreeConverter/PotreeConverter




COPY ./src/PNPSolver /home/executables/PNPSolver

# Build solver executable
RUN cd /home/executables/PNPSolver && cmake . && make

RUN chown -R node /home/lib