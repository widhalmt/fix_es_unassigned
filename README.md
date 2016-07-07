# fix_es_unassigned
Fixing unassigned shards in Elasticsearch

This script searches for unassigned shards in your Elasticsearch cluster. One of the main reasons for status `red`. While there are many other reasons a cluster can turn `red`, unassigned shards are rather common and very easy to fix.

= How to use it =

Just run the script on one of your Elasticsearch. You don't have to change anything if you are using the default settings.

The script assumes you run it on a default or data node and the REST API is listening on port 9200 (the default).

= What it does =

The script simply queries the REST API for unassigned shards and assigns them to the host the script is run on. This may move many shards to this node but when all shards are assigned, Elasticsearch will rebalance the cluster automatically.
