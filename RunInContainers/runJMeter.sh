#!/bin/bash
# Output is written to  /output/acmeair.stats.0 inside the container
# -e JURL="/" -e JUSERBOTTOM=0 
podman run --rm -d --net=host  -e JTHREAD=10 -e JDURATION=300 -e JHOST="10.21.72.64" -e JPORT=9080  -e JUSERBOTTOM=0   -e JUSER=99  -e JRAMP=0 -e JINFLUXDBADDR="10.21.72.64" -e JINFLUXDBBUCKET=jmeter  --name jmeter1 localhost/jmeter-acmeair:5.5-influxdb
podman run --rm -d --net=host  -e JTHREAD=10 -e JDURATION=300 -e JHOST="10.21.72.64" -e JPORT=9081  -e JUSERBOTTOM=100 -e JUSER=199 -e JRAMP=0 -e JINFLUXDBADDR="10.21.72.64" -e JINFLUXDBBUCKET=jmeter2 --name jmeter2 localhost/jmeter-acmeair:5.5-influxdb
