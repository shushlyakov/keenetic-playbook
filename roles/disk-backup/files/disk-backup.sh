#!/opt/bin/sh
#
# Ansible managed
#

TAG="disk-backup"

while getopts s:d:b: flag; do
  case "${flag}" in
    s) SRC=${OPTARG};;
    d) DST=${OPTARG};;
    b) BKP=${OPTARG};;
    *) echo "usage: $0 [-s] [-d] [-b]" >&2
       exit 1 ;;
  esac
done

DATE=$(date +%d-%m-%Y)

logger -t $TAG "Creating backup";
if ! tar -czpf "${DST}/${DATE}.tar.gz" -C "${SRC}" .
then
  logger -t $TAG -p user.err "Error: Unable to create backup [$SRC]"
  return 1
fi

logger -t $TAG "Sync backup directory"
if ! rclone sync "${DST}" "${BKP}"
then
  logger -t $TAG -p user.err "Error: Unable to sync backup directory: [$DST] -> [$BKP]."
  return 1
fi

logger -t $TAG "Cleaning old backup files"
if ! find "${DST}" -mtime +1 -exec rm {} \;
then
  logger -t $TAG -p user.err "Error: Unable to cleaning old backup files: [$DST]."
  return 1
fi

logger -t $TAG "Done [$SRC] -> [$DST]."
