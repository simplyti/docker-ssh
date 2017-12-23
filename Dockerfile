FROM debian:stretch-slim

RUN apt-get update && apt-get install -y openssh-server sudo

ADD run.sh /run.sh
RUN chmod +x /run.sh

RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
  && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && echo "GatewayPorts yes" > /etc/ssh/sshd_config \
  && touch /root/.Xauthority \
  && true

RUN useradd docker \
        && passwd -d docker \
        && mkdir /home/docker \
        && chown docker:docker /home/docker \
        && addgroup docker staff \
        && addgroup docker sudo

EXPOSE 22
CMD ["/run.sh"]
