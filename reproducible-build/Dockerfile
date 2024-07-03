FROM crops/poky@sha256:f51ae3279f98768514273061336421e686e13d0a42fdb056c0b88c9afeec8c56

USER root
RUN apt install -y repo

ADD ./build.sh /usr/bin/build
RUN chmod +x /usr/bin/build

CMD /usr/bin/build
