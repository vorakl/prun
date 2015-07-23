#!/usr/bin/env roundup

describe "Tests for prun"

it_is_usage() {
   output=$(set +e; ./prun help | grep Usage 2>&1; : )
   test "${output}" = 'Usage: prun "dest1 ...|@file|- ..." "command args"'
}

it_is_destination_parser() {
   output=$(set +e; echo "" | DEBUG=1 ./prun "-" ":" 2>&1; : )
   test "${output}" = "DEBUG: Destination not found"
}
