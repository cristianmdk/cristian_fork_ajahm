#-------------------------------------------
# VARS DECLARATION
#-------------------------------------------
DOCKER_USER="caca"
DOCKER_REPOSITORY="midterm_docker_repository"


#-------------------------------------------
# VERSION
#-------------------------------------------
if [[ $1 = '' ]];
then
  echo "==========> YOU NEED A VERSION \n\n\n" && exit
else
  VERSION=$1
fi


#-------------------------------------------
# FULL NAME
#-------------------------------------------
FULL_IMAGE_NAME="$DOCKER_USER/$DOCKER_REPOSITORY:$VERSION"
echo "==========> FULL NAME: $FULL_IMAGE_NAME \n\n"


#-------------------------------------------
#git add .
#git commit -m $VERSION
#git push


#-------------------------------------------
# UPDATE GITHUB from dev team
#-------------------------------------------
echo "\n[1/8]==========> pull from dev team folder"
git pull
echo "[1/8]==========> pull – DONE \n\n"


#-------------------------------------------
# CONFIGURE package.json
#-------------------------------------------
echo "\n[2/8]==========> package.json configuration"
yarn install
yarn heroku-postbuild
echo "[2/8]==========> package.json configuration – DONE \n\n"


#-------------------------------------------
# DOCKER LOGOUT
#-------------------------------------------
echo "\n[3/8]==========> Log out of the docker"
docker logout
if [ $? -ne 0 ]; then
  echo "[3/8]==========> Log out of the docker – FAILED \n\n"
else
  echo "[3/8]==========> Log out of the docker – SUCCESSFUL \n\n"
fi


#-------------------------------------------
# BUILD DOCKER IMAGE
#-------------------------------------------
echo "\n[4/8]==========> Build docker image"
docker build -t $FULL_IMAGE_NAME .
if [ $? -ne 0 ]; then
  echo "[4/8]==========> Build docker image - FAILED \n\n" && exit
else
  echo "[4/8]==========> Build docker image - SUCCESSFUL \n\n"
fi


#-------------------------------------------
# USE THE DOCKER TOKEN TO LOGIN
#-------------------------------------------
echo "\n[5/8]==========> Build login"
cat .dockerpwd | docker login --username $DOCKER_USER --password-stdin
if [ $? -ne 0 ]; then
  echo "[5/8]==========> Docker login - FAILED \n\n" && exit
else
  echo "[5/8]==========> Docker login - SUCCESSFUL \n\n"
fi


#-------------------------------------------
# PUSH A NEW TAG TO DOCKER REPOSITORY
#-------------------------------------------
echo "\n[6/8]==========> Push the new tag to docker"
docker push $FULL_IMAGE_NAME
if [ $? -ne 0 ]; then
  echo "[6/8]==========> Push the new tag to docker - FAILED \n\n" && exit
else
  echo "[6/8]==========> Push the new tag to docker - SUCCESSFUL \n\n"
fi


# -------------------------------------------
# REMOVE OLD IMAGE
# -------------------------------------------
echo "\n[7/8]==========> Remove docker image"
#docker rmi $FULL_IMAGE_NAME
if [ $? -ne 0 ]; then
  echo "[7/8]==========> Remove docker image - FAILED \n\n"
else
  echo "[7/8]==========> Remove docker image - SUCCESSFUL \n\n"
fi


seconds_left=5
while [ $seconds_left -gt 0 ];do
  sleep 1
  seconds_left=$(($seconds_left - 1))
done


# -------------------------------------------
# CONNECT TO VM IN GCLOUD AND RUN update.sh
# -------------------------------------------
echo "\n[8/8]==========> Update GCloud VM"
ssh g6219701@34.122.49.94 /bin/bash /home/g6219701/update.sh "$DOCKER_USER/$DOCKER_REPOSITORY" $VERSION
if [ $? -ne 0 ]; then
  echo "[8/8]==========> Update GCloud VM - FAILED \n\n" && exit
else
  echo "[8/8]==========> Update GCloud VM - SUCCESSFUL \n\n"
fi








# upstream server_side{
#   server 127.0.0.1:5001;
#   server 127.0.0.1:5002;
#   server 127.0.0.1:5999 backup;
# }

# server {
#   listen 80 default_server;
#   listen [::]:80 default_server;

#   location / {
#     proxy_pass http://server_side;
#     proxy_set_header Host $host;
#     proxy_set_header X-Real-IP $remote_addr;
#     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#   }
# }
