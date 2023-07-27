#!/bin/sh
pg_dump -O abc.com | psql abc.com
