#!/bin/bash

# This is a custom entrypoint for the Rancherized Cabot. Don't change it.
if echo "$ROLE" | grep frontend ; then
  # Role is frontend, exec the relevant command
  apt-get update
  apt-get install expect -y
  # Always run the prep script unconditionally as it does no harm but helps if something is broken
  bash bin/build-app
  python manage.py createsuperuser --username=admin --email=admin@noreply.com --noinput
  if [[ $? -eq 0 ]] ; then
    # User account did not exist, setting password from env var in Rancher
    expect password.exp ${PASSWORD}
  fi
  python manage.py syncdb
  python manage.py runserver 0.0.0.0:80
elif echo "$ROLE" | grep worker ; then
  # Role is frontend, exec the relevant command
  python manage.py celery worker -B -A cabot --loglevel=DEBUG --concurrency=16 -Ofair
else
  # Invalid role
  echo "Role error - no role specified or inavlid entry. Use frontend or worker. Exiting."
  exit 1
fi
