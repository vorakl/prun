#!/usr/bin/env roundup

describe "Tests for prun"

it_is_usage() {
   output=$(./prun help | grep Usage)
   test "${output}" = 'Usage: prun "dest1 ...|@file|- ..." "command args"'
}

it_is_destination_parser() {
   output=$(set +e; echo "" | DEBUG=1 ./prun "-" ":" 2>&1; :)
   test "${output}" = "DEBUG: Destination not found"
}
