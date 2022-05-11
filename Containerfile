ARG ALPINE_VERSION=3.15.4
FROM alpine:$ALPINE_VERSION

LABEL version="2022-04-29"
LABEL source="https://github.com/gautada/alpine-container.git"
LABEL maintainer="Adam Gautier <adam@gautier.org>"
LABEL description="This container is a basic Alpine Linux distribution for use as the basis for other containers."

EXPOSE 22/tcp

ENV ENV="/etc/profile"

RUN /sbin/apk add --no-cache git iputils nano openssh sudo shadow tzdata
RUN /bin/cp -v /usr/share/zoneinfo/America/New_York /etc/localtime
RUN /bin/echo "America/New_York" > /etc/timezone

RUN /bin/echo "%wheel         ALL = (ALL) NOPASSWD: /usr/sbin/crond" >> /etc/sudoers \
 && /bin/echo "%wheel         ALL = (ALL) NOPASSWD: /usr/sbin/sshd" >> /etc/sudoers
# && echo "%wheel         ALL = (ALL) NOPASSWD: /usr/bin/ssh-keygen" >> /etc/sudoers
# can do bastion setup witb docker exec -u 0
 
VOLUME /opt/bastion
VOLUME /opt/ansible

COPY version /bin/version
COPY 00-profile.sh /etc/profile.d/00-profile.sh

COPY entrypoint /entrypoint
COPY 00-entrypoint.sh /etc/entrypoint.d/00-entrypoint.sh
COPY 10-entrypoint.sh /etc/entrypoint.d/10-entrypoint.sh
COPY 99-entrypoint.sh /etc/entrypoint.d/99-entrypoint.sh
ENTRYPOINT ["/entrypoint"]

COPY bastion-setup /usr/bin/bastion-setup

# AuthorizedKeysFile - Specifies the file that contains the public keys used for user authentication. Default is changed to /opt/bastion/ssh/authorized_keys
# HostKey Specifies a file containing a private host key used by SSH. The defaults are /etc/ssh/ssh_host_ecdsa_key, /etc/ssh/ssh_host_ed25519_key and /etc/ssh/ssh_host_rsa_key
# PermitRootLogin no
# PasswordAuthentication no
RUN /bin/cp /etc/ssh/sshd_config /etc/ssh/sshd_config~ \
 && /bin/echo "" >> /etc/ssh/sshd_config \
 && /bin/echo "" >> /etc/ssh/sshd_config \
 && /bin/echo "# ***** ALPINE CONTAINER - BASTION SERVICE *****" >> /etc/ssh/sshd_config \
 && /bin/echo "" >> /etc/ssh/sshd_config \
 && /bin/echo "" >> /etc/ssh/sshd_config \
 && /bin/sed -i -e "/AuthorizedKeysFile/s/^#*/# /" /etc/ssh/sshd_config \
 && /bin/echo "AuthorizedKeysFile       /opt/bastion/ssh/authorized_keys" >> /etc/ssh/sshd_config \
 && /bin/sed -i -e "/HostKey/s/^#*/# /" /etc/ssh/sshd_config \
 && /bin/echo "HostKey                  /opt/bastion/etc/ssh/ssh_host_rsa_key" >> /etc/ssh/sshd_config \
 && /bin/echo "HostKey                  /opt/bastion/etc/ssh/ssh_host_ecdsa_key" >> /etc/ssh/sshd_config \
 && /bin/echo "HostKey                  /opt/bastion/etc/ssh/ssh_host_ed25519_key" >> /etc/ssh/sshd_config \
 && /bin/echo "PermitRootLogin no" >> /etc/ssh/sshd_config \
 && /bin/echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

ARG USER=ansible
RUN /bin/mkdir -p /opt/$USER \
 && /usr/sbin/addgroup $USER \
 && /usr/sbin/adduser -D -s /bin/ash -G $USER $USER \
 && /usr/sbin/usermod -aG wheel $USER \
 && /bin/echo "$USER:$USER" | chpasswd \
 && /bin/chown $USER:$USER -R /opt/$USER
 
USER $USER
WORKDIR /home/$USER
