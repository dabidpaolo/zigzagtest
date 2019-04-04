#!/bin/#!/usr/bin/env bash
# This is will deploy sinatra app

################################
# Variables
################################
REF=$1
IP=$2
USER=ubuntu
KEY=zigzag-test-stage.pem
BASE=sinatra_app.tar.gz
REPO="git@github.com:AssemblyPayments/simple-sinatra-app.git"

################################
# Clean up working directory
################################
if [ -d "simple-sinatra-app" ]; then
  rm -rf simple-sinatra-app;
  rm -rf $BASE;
  rm -rf .git;
fi

################################
# Clone app directory
################################
if [ -d .git ]; then
  echo "Directory is a storm trooper!"
  echo "Cloning storm trooper..."
  git clone $REPO
else
  echo "Creating storm troppers..."
  git init
  git clone $REPO
fi

################################
# Equipping storm troopers
################################
cd simple-sinatra-app
git checkout $1
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error"
    exit $retVal
else
    rm -vrf .git
    cd ..
    tar -czvf $BASE simple-sinatra-app

    ################################
    # Transfer to Instance and run
    ################################
    echo "Cleaning up old codebase"
    ssh -o StrictHostKeyChecking=no -i $KEY $USER@$IP "rm -rf *.zip;rm -rf simple*;"
    ssh -o StrictHostKeyChecking=no -i $KEY $USER@$IP "fuser -k 9292/tcp"
    echo "Transferring storm trooper"
    scp -o StrictHostKeyChecking=no -i $KEY $BASE $USER@$IP:~/
    echo "Cleaning up local build dir"
    rm -rf $BASE
    rm -rf simple-sinatra-app
    echo "Unpacking storm trooper"
    ssh -o StrictHostKeyChecking=no -i $KEY $USER@$IP "tar -xzvf sinatra_app.tar.gz; \
        cd simple-sinatra-app; \
        /home/ubuntu/.rbenv/shims/bundle install; \
        /home/ubuntu/.rbenv/shims/bundle exec rackup -o 0.0.0.0"
fi
