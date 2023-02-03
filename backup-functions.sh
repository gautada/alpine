#!/bin/ash

gpg_passphrase() {
 FINGERPRINT="$1"
 PASSPHRASE="$(env | grep $FINGERPRINT | awk -F '=' '{print $2}')"
 if [ -z $PASSPHRASE ] ; then
   if [ -f "/mnt/volumes/container/$FINGERPRINT" ] ; then
    PASSPHRASE="$(/bin/cat /mnt/volumes/container/$FINGERPRINT)"
  fi
 fi
 echo $PASSPHRASE
}

load_gpg_key() {
 KEY_FILE="/etc/container/$1"
 if [ ! -f $KEY_FILE ] ; then
  echo "[ERROR] Unable to find the backup certificate($BACKUP_CERT)"
  return 1
 fi
 FINGERPRINT="$(/usr/bin/gpg --show-keys $KEY_FILE | sed -n '2p' | xargs)"
 PUSH="$(gpg_passphrase $FINGERPRINT)"
 echo $PUSH | /usr/bin/gpg --quiet --passphrase-fd 0 --batch --trusted-key $FINGERPRINT --import $KEY_FILE
 echo "$FINGERPRINT"
 return 0
}

generate_hashmap() {
 hashmap="$(/usr/bin/find $1 -type f -exec /usr/bin/sha256sum {} \; | /usr/bin/sort | /usr/bin/sha256sum |  awk '{print $1}')"
 echo $hashmap
}

default_container_backup() {
 echo "[ INFO] Current directory($(/bin/pwd))"
 echo "[ WARN] Default container backup function not customized for container"
 /bin/cp -rv /mnt/volumes/container/* /tmp/backup
 echo "$(date +%s)" > /tmp/backup/.date
 return $?
}

create_backup_source() {
 SOURCE="$1"
 # Collect backup material
 /bin/mkdir -p $SOURCE
 cd $SOURCE
 if [ -f /etc/container/backup ] ; then
  exec /etc/container/backup
 else
  default_container_backup # Call default backup function
 fi
 RTN=$?
 if [ $RTN -ne 0 ] ; then
  echo "[ERROR]: Function($RTN) did not work"
  return $RTN
 fi
 HASHMAP="$(generate_hashmap $SOURCE)"
 echo $HASHMAP >> $SOURCE/.hashmap
 cd /
}

clean_backup_source() {
 SOURCE="$1"
 echo "[ INFO]: Clean source folder $SOURCE"
 /bin/rm -frv $SOURCE/*
}
 
duplicity_clean() {
 SOURCE="$1"
 CACHE="$2"
 TARGET="$3"
 INFO="$(/usr/bin/duplicity remove-all-but-n-full 1 --force file:/$TARGET)"
 if [ -f "$TARGET/duplicity-full*.manifest.gpg" ] ; then
  MANIFEST="$CACHE/$(ls $TARGET/duplicity-full*.manifest.gpg | awk -F '/' '{print $5}' | sed 's/.\{4\}$//')"
  echo "$MANIFEST"
 else
  echo "$CACHE/duplicity-full*.manifest"
 fi
}

duplicity_backup() {
 TYPE="$1"
 NAME="$2"
 SOURCE="$3"
 CACHE="$4"
 TARGET="$5"
 
 echo "[ INFO]: ***** BACKUP($TYPE) *****"
 SIGNER_FINGERPRINT="$(load_gpg_key signer.key)"
 echo "[ INFO]: Signer=$SIGNER_FINGERPRINT"
 ENCRYPTER_FINGERPRINT="$(load_gpg_key encrypter.key)"
 echo "[ INFO]: Encrypter: $ENCRYPTER_FINGERPRINT"
 if [ $TYPE == "full" ] ; then
  echo "[ INFO]: Clean backup cache($CACHE)"
  /bin/rm -frv $CACHE
  echo "[ INFO]: Clean backup target($TARGET)"
  /bin/rm -frv /mnt/v olumes/backup/duplicity*
 fi
 env SIGN_PASSPHRASE="$(gpg_passphrase $SIGNER_FINGERPRINT)" /usr/bin/duplicity $TYPE --encrypt-key $ENCRYPTER_FINGERPRINT --sign-key $SIGNER_FINGERPRINT --name $NAME --archive-dir $ARCHIVE $SOURCE "file:/$TARGET"
}


