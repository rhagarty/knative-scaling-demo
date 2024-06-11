podman run -d --rm --cpus=1.0 -m=512m --network=slirp4netns -e JVM_ARGS='' -e MONGO_HOST="10.21.72.64" -e MONGO_PORT=27017 -e MONGO_DBNAME=acmeair -p 9080:9080 --name lib1 localhost/liberty-acmeair-ee8:23.0.0.6


podman run -d --rm --cpus=1.0 -m=512m --network=slirp4netns --cap-add=CHECKPOINT_RESTORE --cap-add=SETPCAP --security-opt seccomp=unconfined -e OPENJ9_RESTORE_JAVA_OPTIONS='-XX:+UseJITServer -XX:JITServerAddress=10.21.72.64'  -e MONGO_HOST="10.21.72.64" -e MONGO_PORT=27017 -e MONGO_DBNAME=acmeair -p 9081:9080 --name lib2 localhost/liberty-acmeair-ee8:23.0.0.6-instanton


