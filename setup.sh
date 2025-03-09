#!/usr/bin/env bash

# Exit on fail
set -e

case "$1" in
  a1111)
    repo_url=https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
    repo_dir=stable-diffusion-webui
    ;;
  forge)
    repo_url=https://github.com/lllyasviel/stable-diffusion-webui-forge.git
    repo_dir=stable-diffusion-webui-forge
    ;;
  reforge)
    repo_url=https://github.com/Panchovix/stable-diffusion-webui-reForge.git
    repo_dir=stable-diffusion-webui-reForge
    ;;
  *) 
    echo Please specify a valid webui:
    echo
    echo " bash setup.sh a1111"
    echo " bash setup.sh forge"
    echo " bash setup.sh reforge"
    echo
    echo Setup aborted
    exit 1
    ;;
esac

cache_dir="$repo_dir/cache"
home_dir="$cache_dir/home"
tmp_dir="$repo_dir/tmp"

echo Configuring environment for \"$1\" webui.
echo ""

echo Making bash scripts user-executable.
chmod u+x *.sh
chmod u+x docker/webui/docker-entrypoint.sh

echo Writing user id to file \"user.env\" for docker file system binding.
echo UID=$(id -u) > user.env
echo CONTAINER_USER=ubuntu >> user.env

echo Updating parameter HOST_WEBUI_DIRECTORY in the \".env\" file to \"$repo_dir\".
sed -i "s/HOST_WEBUI_DIRECTORY=.*/HOST_WEBUI_DIRECTORY=$repo_dir/" .env

# Clone repo if not already checked out
if [ ! -d "$repo_dir" ]; then
  echo Checking out \"$repo_url\" into \"$repo_dir\"
  git clone $repo_url
else
  echo Skipping checkout, repo directory \"$repo_dir\" is already present.
fi

echo ""

if [ ! -d "$home_dir" ]; then
  echo Creating \"$home_dir\" user home cache directory.
  mkdir -p "$home_dir"
fi

if [ ! -d "$tmp_dir" ]; then
  echo Creating \"$tmp_dir\" temp directory.
  mkdir -p "$tmp_dir"
fi

echo ""

echo Setup complete
echo ""

echo "If this is your first run, you can now build the docker images by running:"
echo "./build-docker-images.sh"
