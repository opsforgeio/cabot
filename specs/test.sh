echo "Initiating tests..."
chmod -R 0777 ./
echo ">>> Docker Lints:"
./specs/opsbox.spec.sh
if [ $? -eq 0 ]; then
  echo ">>> Docker Lints concluded and none failed."
else
  echo ">>> Tests failed."
  exit 1
fi
echo "Initiating DockerHub builds..."
curl --data build=true -X POST 'https://registry.hub.docker.com/u/opsforge/cabot-docker/trigger/ae919064-8284-443a-a333-22ca4b682863/'
echo "DockerHub build triggered..."
