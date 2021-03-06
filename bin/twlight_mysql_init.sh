#!/usr/bin/env bash

if [ -n "${TWLIGHT_SECRETS_DIR+isset}" ]
then
  SECRETS_DIR=${TWLIGHT_SECRETS_DIR}
else
  SECRETS_DIR=/run/secrets
fi

if  [ -f ${SECRETS_DIR}/DJANGO_DB_NAME ]
then
    DJANGO_DB_NAME=$(cat ${SECRETS_DIR}/DJANGO_DB_NAME)
fi

if  [ -f ${SECRETS_DIR}/DJANGO_DB_USER ]
then
    DJANGO_DB_USER=$(cat ${SECRETS_DIR}/DJANGO_DB_USER)
fi

if  [ -f ${SECRETS_DIR}/DJANGO_DB_PASSWORD ]
then
    DJANGO_DB_PASSWORD=$(cat ${SECRETS_DIR}/DJANGO_DB_PASSWORD)
fi

if  [ -f ${SECRETS_DIR}/MYSQL_ROOT_PASSWORD ]
then
    MYSQL_ROOT_PASSWORD=$(cat ${SECRETS_DIR}/MYSQL_ROOT_PASSWORD)
fi

if  [ -n "${MYSQL_ROOT_PASSWORD+isset}" ]
then
    mysql_cmd="mysql -u root -p${MYSQL_ROOT_PASSWORD}"
else
    mysql_cmd="mysql"
fi

${mysql_cmd} <<EOF
CREATE DATABASE IF NOT EXISTS ${DJANGO_DB_NAME};
CREATE DATABASE IF NOT EXISTS test_${DJANGO_DB_NAME};
GRANT ALL PRIVILEGES on \`${DJANGO_DB_NAME}\`.* to ${DJANGO_DB_USER}@'%' IDENTIFIED BY '${DJANGO_DB_PASSWORD}';
GRANT ALL PRIVILEGES on \`test\_${DJANGO_DB_NAME}\`.* to ${DJANGO_DB_USER}@'%' IDENTIFIED BY '${DJANGO_DB_PASSWORD}';
GRANT ALL PRIVILEGES on \`test\_${DJANGO_DB_NAME}\_%\`.* to ${DJANGO_DB_USER}@'%' IDENTIFIED BY '${DJANGO_DB_PASSWORD}';
EOF
