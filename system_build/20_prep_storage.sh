#!/bin/bash

set -e
if [[ ! -z "$TRACE" ]]; then
  set -x
fi

READAHEAD="/sbin/blockdev --setra 16384 /dev/xvd[a-z]"

FSTAB_HEAD="# BEGIN GENERATED CONTENT"
FSTAB_TAIL="# END GENERATED CONTENT"

if [[ -z $DRIVE_PATTERN ]]; then
  DRIVE_PATTERN="/dev/xvd[b-z]"
fi

main() {
  echo Storage

  set_readahead

  calculate_volumes

  create_volumes
}

set_readahead() {
  $READAHEAD
  echo "$READAHEAD" >> /etc/rc.local
}

calculate_volumes() {
  DRIVES=($(ls $DRIVE_PATTERN))
  DRIVE_COUNT=${#DRIVES[@]}

  if [[ -z "${VOLUMES}" ]]; then
    if [[ $DRIVE_COUNT -lt 8 ]]; then
      VOLUMES=1
    elif [[ $DRIVE_COUNT -lt 12 ]]; then
      VOLUMES=2
    else
      VOLUMES=4
    fi
  fi

  if (( ${DRIVE_COUNT} % ${VOLUMES} != 0 )); then
    echo "Drive count (${DRIVE_COUNT}) not divisible by number of volumes (${VOLUMES}), using VOLUMES=1"
    VOLUMES=1
  fi
}

create_volumes() {
  FSTAB=()

  umount /dev/md[0-9]* || true

  umount ${DRIVES[*]} || true

  mdadm --stop /dev/md[0-9]* || true

  mdadm --zero-superblock ${DRIVES[*]}

  for VOLUME in $(seq $VOLUMES); do
    DPV=$(expr "$DRIVE_COUNT" "/" "$VOLUMES")
    DRIVE_SET=($(ls ${DRIVE_PATTERN} | head -n $(expr "$DPV" "*" "$VOLUME") | tail -n "$DPV"))

    mdadm --create /dev/md${VOLUME} --run --level 0 --chunk 256K --raid-devices=${#DRIVE_SET[@]} ${DRIVE_SET[*]}

    mkfs.xfs -f /dev/md${VOLUME}

    mkdir -p /data${VOLUME}

    FSTAB+="/dev/md${VOLUME}  /data${VOLUME}  xfs rw,noatime,inode64,allocsize=16m  0 0\n"
  done

  mdadm --detail --scan > /etc/mdadm.conf

  for DRIVE in ${DRIVES[*]}; do
    sed -i -r "s|^${DRIVE}.+$||" /etc/fstab
  done

  sed -i -e "/$FSTAB_HEAD/,/$FSTAB_TAIL/d" /etc/fstab
  echo "$FSTAB_HEAD" >> /etc/fstab
  echo -e "${FSTAB[@]}" >> /etc/fstab
  echo "$FSTAB_TAIL" >> /etc/fstab

  mount -a
}

main "$@"
