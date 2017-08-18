#!/bin/sh 
python /usr/src/app/create_db.py
python /usr/src/app/migrate_db.py
python /usr/src/app/run.py
