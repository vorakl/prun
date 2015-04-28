# prun

## Version

v.2.1, 2012-2014

## Description

It executes in parallel mode commands on remote hosts
with watchdog controlling and making reports.

You can write common parameters into configuration file.
For example in /etc/prun.conf or /home/user/.prun.conf

Environment parameters which are set in advance have a precedence.

The directory with reports can be found at the and of the output.

## Usage
    prun "dest1 ...|@file|- ..." "command args"

## Examples

### Commands

    prun box113 uptime
    prun "a1 ds214 akz15" "ls -la"
    prun "@srv.list" id
    prun "srv1 srv2 @srv.list" "ip addr sh"
    prun "srv56 -" "ip rou sh < srv.list"

    cat srv.list | prun - "netstat -na | grep LISTEN"

    CONCURENT_PROC=4 prun "@srv.list" "sudo id"
    SSH_USER=root SSH_KEY=/home/user/.ssh/id_dsa SSH_PARAM=-nap12345 prun some.host who

### Configuration file

    DEBUG=0
    CONCURENT_PROC=50
    WATCHDOG_TIMER=60
    SHOW_REPORT=1
    SHOW_REPORT_TEXT=1
    SHOW_REPORT_FULLTEXT=0
    DEL_REPORT_DIR=1
    SSH_USER
    SSH_KEY
    SSH_PARAM="-na"
