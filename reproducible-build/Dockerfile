FROM crops/poky@sha256:f51ae3279f98768514273061336421e686e13d0a42fdb056c0b88c9afeec8c56 as builder

USER root
RUN apt update && apt install -y repo=2.17.3-3 libssl-dev=3.0.2-0ubuntu1.18 libssl3=3.0.2-0ubuntu1.18 distro-info-data=0.52ubuntu0.8 python3-kerberos=1.1.14-3.1build5
RUN pip3 install asn1crypto==1.5.1 certvalidator==0.11.1 mscerts==2024.5.29 oscrypto==1.3.0 typing-extensions==4.12.2 signify==0.7.1

ADD build.sh /usr/bin/build
RUN chmod +x /usr/bin/build

ARG MANIFEST
ENV MANIFEST_FILE=${MANIFEST}

CMD /usr/bin/build
