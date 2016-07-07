#!/bin/bash

ESHOST=127.0.0.1
ESPORT=9200

TARGETHOST=$(curl -s -XGET http://${ESHOST}:${ESPORT} | grep \"name\" | cut -d: -f2)

for i in $(curl -s -XGET http://${ESHOST}:${ESPORT}/_cat/shards?pretty | awk '{print $1}' | sort | uniq ) ;
  do for j in $(curl -s -XGET http://${ESHOST}:${ESPORT}/_cat/shards?pretty | grep $i | grep UNASSIGNED | awk '{print $2}') ;
    do curl -s -XPOST 'http://${ESHOST}:${ESPORT}/_cluster/reroute' -d '{
      "commands" : [ {
        "allocate" : {
          "index" : "'"$i"'",
          "shard" : "'"$j"'",
          "node" : "'"${TARGETHOST}"'",
          "allow_primary" : true
        }
      } ]
    }'
    echo "moved shard $j of index $i to ${TARGETHOST}"
    sleep 5
  done
done

