# Quick start

* `docker build -t rezonanc/litecoin-vnc .`
* `docker run -u "$(id -u litecoin)" --net host -v /etc/passwd:/etc/passwd -v $(pwd)/password.txt:/password.txt -v $(pwd)/litecoin:/home/litecoin/data rezonanc/litecoin-vnc`
