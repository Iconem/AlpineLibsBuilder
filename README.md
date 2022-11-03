# AlpineLibsBuilder

To build alpine-compatible versions of the following executables:
- PotreeConverter1.7
- PotreeConverter2.1
- camCalibNode (PNP solver)
(alpine version: **node:16.14.0-alpine3.15**) 

## Build the executables
You must launch the command with admin rights :
```
	sh build.sh
```
Executables (+ the needed dependencies) are generated in the `build` folder.

## Use the build

### PotreeConverter1.7
Add the following lines to your Dockerfile :
```
WORKDIR /home/lib
RUN mkdir PotreeConverter1.7 && cd PotreeConverter1.7 \
  && wget https://github.com/Iconem/AlpineLibsBuilder/releases/download/${version}/PotreeConverter1.7.tar \
  && tar -xf PotreeConverter1.7.tar \
  && cp lib/* /usr/local/lib/ \
  && rm PotreeConverter1.7.tar
```


### PotreeConverter2.1
Add the following lines to your Dockerfile :
```
RUN apk update && apk add libtbb
WORKDIR /home/lib
RUN mkdir PotreeConverter2.1 && cd PotreeConverter2.1 \
  && wget https://github.com/Iconem/AlpineLibsBuilder/releases/download/${version}/PotreeConverter2.1.tar \
  && tar -xf PotreeConverter2.1.tar \
  && rm PotreeConverter2.1.tar
```

### camCalibNode
Add the following lines to your Dockerfile :
```
WORKDIR /home/lib
RUN mkdir PNPSolver && cd PNPSolver \
  && wget https://github.com/Iconem/AlpineLibsBuilder/releases/download/${version}/PNPSolver.tar \
  && tar -xf PNPSolver.tar \
  && cp lib/* /usr/local/lib/ \
  && rm PNPSolver.tar
```
