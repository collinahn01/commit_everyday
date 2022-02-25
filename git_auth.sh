#!/bin/bash

eval $(ssh-agent)

ssh-add ~/.ssh/git_rsa

git push origin main
