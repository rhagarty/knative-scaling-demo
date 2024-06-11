podman run --rm -d --name mongodb --network=slirp4netns -p 27017:27017 localhost/mongo-acmeair:5.0.17 --nojournal
sleep 1
./mongoRestore.sh
