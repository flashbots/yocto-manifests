FROM crops/poky@sha256:f51ae3279f98768514273061336421e686e13d0a42fdb056c0b88c9afeec8c56 as builder

USER root
RUN apt update && apt install -y repo=2.17.3-3 libssl-dev=3.0.2-0ubuntu1.18
RUN pip3 install signify==0.7.1

ADD build.sh /usr/bin/build
RUN chmod +x /usr/bin/build

ARG MANIFEST
ENV MANIFEST_FILE=${MANIFEST}

CMD /usr/bin/build
