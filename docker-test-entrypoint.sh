#!/bin/bash

umask 0000

bundle exec rspec "$@"
