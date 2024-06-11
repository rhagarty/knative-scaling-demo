#podman run --rm -d --network=slirp4netns -p 38400:38400 -p 38500:38500 --cpus=4 -m=2G -e OPENJ9_JAVA_OPTIONS="-XX:+JITServerLogConnections -XX:+JITServerMetrics" --name jitserver localhost/liberty-acmeair-ee8:23.0.0.6 jitserver

podman run --rm -d --network=slirp4netns -p 38400:38400 -p 38500:38500 --cpus=4 -m=2G -e OPENJ9_JAVA_OPTIONS="-XX:+JITServerLogConnections -XX:+JITServerMetrics" --name jitserver localhost/liberty-acmeair-ee8:23.0.0.6 jitserver

