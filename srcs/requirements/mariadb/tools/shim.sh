#! /bin/bash

source ./init_database.sh
main
exec "$@"
