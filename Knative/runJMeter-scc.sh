#!/bin/bash

# Replace [Your_initial] with your initials and replace [OCP server name] with the OCP server name. For example, if the URL used to access the console is 
# https://console-openshift-console.apps.ocp-663004rdfa-kgmt.cloud.techzone.ibm.com, then you can fill in the "OCP server name" as "ocp-663004rdfa-kgmt".

podman run --rm -d --net=host  -e JTHREAD=175 -e JDURATION=240 -e JHOST="acmeair-scc-scclab-rh10.apps.661ee9b513f52d001e6247ed.cloud.techzone.ibm.com"      -e JPORT=80  -e JUSERBOTTOM=0 -e JUSER=199 -e JRAMP=0 -e JINFLUXDBADDR="10.21.72.64" -e JINFLUXDBBUCKET=jmeter2 --name jmeter2 localhost/jmeter-acmeair:5.5-influxdb
