podman run -d --rm -p 8086:8086 \
      --network=slirp4netns \
      --name influxdb \
      quay.io/pirvum/influxdb:jmeter --reporting-disabled

