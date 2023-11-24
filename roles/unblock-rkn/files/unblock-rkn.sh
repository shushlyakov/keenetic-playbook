#!/opt/bin/sh
#
# Ansible managed
#

TAG="unblock-rkn"

while getopts i:t: flag
do
  case "${flag}" in
    i) IFACE=${OPTARG};;
    t) TABLE=${OPTARG};;
    *) echo "usage: $0 [-i] [-t]" >&2
       exit 1 ;;
  esac
done


if ! ip rule | grep "from all lookup $TABLE"
then
  logger -t $TAG "Add rule table $TABLE interface $IFACE"
  if ! ip rule add from all lookup "${TABLE}"
  then
    logger -t $TAG -p user.err "Error: Unable to add rule table $TABLE interface $IFACE"
    return 1
  fi
fi

logger -t $TAG "Flush route table $TABLE interface $IFACE"
if ! ip route flush table "${TABLE}"
then
  logger -t $TAG -p user.err "Error: Unable to flush rule table $TABLE interface $IFACE"
  return 1
fi

while IFS=$'\n' read -r line
do
  line=$(echo "$line" | sed -e 's/^[[:space:]]*//')
  [ -z "$line" ] && continue

  # ASN
  asn=$(echo "$line" | grep -Eo 'AS[0-9]+')
  if [ -n "$asn" ]
  then
    for ip in $(whois -h whois.radb.net "!g${asn}" | grep /)
    do
      address=$(echo "$ip" | grep -Eo '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}$')
      if [ -n "${address}" ]
      then
        logger -t $TAG "[$line] Add $address to route table $TABLE interface $IFACE"
        if ! ip route replace "$address" dev "$IFACE" table "$TABLE"
        then
          logger -t $TAG -p user.err "Error: [$line] Unable to add $address to route table $TABLE interface $IFACE"
          return 1
        fi
      fi
    done
    continue
  fi

  # DN
  for ip in $(dig +short "$line" @1.1.1.1)
  do
    address=$(echo "$ip" | grep -Eo '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$')
    if [ -n "$address" ]
    then
      logger -t $TAG "[$line] Add $address to route table $TABLE interface $IFACE"
      if ! ip route replace "$address" dev "$IFACE" table "$TABLE"
      then
        logger -t $TAG -p user.err "Error: [$line] Unable to add $address to route table $TABLE interface $IFACE"
        return 1
      fi
    fi
  done
done

logger -t $TAG "Done. $(ip route show table "$TABLE" | wc -l) ips added to route table $TABLE interface $IFACE"
