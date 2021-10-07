# udp2raw Build Dockerfile

[Docker](http://docker.com) container to build [Udp2raw-tunnel](https://github.com/wangyu-/udp2raw) as a static executable.


## Usage

You can build the `Udp2raw-tunnel` Docker container from source, during the container's build it will create the Udp2raw-tunnel binaries  executables. 

To create the Docker container from scratch and copy the binaries to the current working directory, run the commands below:

```
git clone https://github.com/wxlg1117/udp2raw-build-Dockerfile.git
cd udp2raw-build-Dockerfile
docker build -t udp2raw-build . 2>&1 | tee build.log
docker run -it --rm -v $(pwd):/workdir -w="/workdir" udp2raw-build sh -c "cp /usr/local/src/udp2raw-tunnel/udp2raw_*binaries.tar.gz /workdir"
```