# prun

## Version

v.2.1 2012-2014

## Description

It executes in parallel mode commands on remote hosts
with watchdog controlling and making reports.

You can set common parameters in configuration file.
For example in /etc/prun.conf or /home/user/.prun.conf

Environment parameters which are set in advance have a precedence.

The directory with reports can be found at the and of the output.

## Examples

    prun box113 uptime
    prun "a1 ds214 akz15" "ls -la"
    prun "@srv.list" id
    prun "srv1 srv2 @srv.list" "ip addr sh"
    prun "srv56 -" "ip rou sh" < srv.list"

    cat srv.list | prun - "netstat -na | grep LISTEN"

    CONCURENT_PROC=4 prun "@srv.list" "sudo id"
    SSH_USER=root SSH_KEY=/home/user/.ssh/id_dsa SSH_PARAM=-nap12345 ./prun some.host who
