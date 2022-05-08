ARG ALPINE_VERSION=3.15.4
FROM alpine:$ALPINE_VERSION

LABEL version="2022-04-29"
LABEL source="https://github.com/gautada/alpine-container.git"
LABEL maintainer="Adam Gautier <adam@gautier.org>"
LABEL description="This container is a basic Alpine Linux distribution for use as the basis for other containers."

EXPOSE 22/tcp

ENV ENV="/etc/profile"

RUN apk add --no-cache nano openssh sudo shadow tzdata
RUN cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone

RUN echo "%wheel         ALL = (ALL) NOPASSWD: /usr/sbin/crond" >> /etc/sudoers \
 && echo "%wheel         ALL = (ALL) NOPASSWD: /usr/sbin/sshd" >> /etc/sudoers

# && echo "%wheel         ALL = (ALL) NOPASSWD: /usr/bin/ssh-keygen" >> /etc/sudoers
# can do bastion setup witb docker exec -u 0
 
VOLUME /opt/bastion
VOLUME /opt/container

COPY version /bin/version
COPY 00-profile.sh /etc/profile.d/00-profile.sh

COPY entrypoint /entrypoint
COPY 00-entrypoint.sh /etc/entrypoint.d/00-entrypoint.sh

ENTRYPOINT ["/entrypoint"]

# AuthorizedKeysFile - Specifies the file that contains the public keys used for user authentication. Default is changed to /opt/bastion/ssh/authorized_keys
# HostKey Specifies a file containing a private host key used by SSH. The defaults are /etc/ssh/ssh_host_ecdsa_key, /etc/ssh/ssh_host_ed25519_key and /etc/ssh/ssh_host_rsa_key

# PermitRootLogin no
RUN cp /etc/ssh/sshd_config /etc/ssh/sshd_config~ \
 && echo "" >> /etc/ssh/sshd_config \
 && echo "" >> /etc/ssh/sshd_config \
 && echo "# ***** ALPINE CONTAINER - BASTION SERVICE *****" >> /etc/ssh/sshd_config \
 && echo "" >> /etc/ssh/sshd_config \
 && echo "" >> /etc/ssh/sshd_config \
 && sed -i -e "/AuthorizedKeysFile/s/^#*/# /" /etc/ssh/sshd_config \
 && echo "AuthorizedKeysFile    /opt/bastion/ssh/authorized_keys" >> /etc/ssh/sshd_config \
 && sed -i -e "/HostKey/s/^#*/# /" /etc/ssh/sshd_config \
 && echo "HostKey    /opt/bastion/etc/ssh/ssh_host_rsa_key" >> /etc/ssh/sshd_config \
 && echo "HostKey    /opt/bastion/etc/ssh/ssh_host_ecdsa_key" >> /etc/ssh/sshd_config \
 && echo "HostKey    /opt/bastion/etc/ssh/ssh_host_ed25519_key" >> /etc/ssh/sshd_config \
 && echo "PermitRootLogin no" >> /etc/ssh/sshd_config \
 && echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
 
ARG USER=test
RUN addgroup $USER \
 && adduser -D -s /bin/ash -G $USER $USER \
 && usermod -aG wheel $USER \
 && echo "$USER:$USER" | chpasswd

USER $USER
WORKDIR /home/$USER
