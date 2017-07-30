# Quick start

* `docker build -t rezonanc/bitcoin-vnc .`
* `docker run -u "$(id -u bitcoin)" --net host -v /etc/passwd:/etc/passwd -v $(pwd)/password.txt:/password.txt -v $(pwd)/bitcoin:/home/bitcoin/data rezonanc/bitcoin-vnc`
