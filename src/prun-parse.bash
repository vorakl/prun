#!/usr/bin/env bash
#
# Copyright (c) 2023 vorakl and the prun contributors
# SPDX-License-Identifier: Apache-2.0
#
# An example of how to parse the prun's final report
# Version: {{version}}
#
# Usage:
#   prun 'sleep 2; exit 2' 'sleep 1' | prun-parse
#

while IFS= read -r str
do 
    [[ $str =~ ^commands=(.*)$ ]] && { IFS=$'\t' read -a cmds <<< "${BASH_REMATCH[1]}"; }
    [[ $str =~ ^exit_codes=(.*)$ ]] && { IFS=$'\t' read -a codes <<< "${BASH_REMATCH[1]}"; }
done

declare -p codes cmds
echo
for i in "${!cmds[@]}"
do
    echo -e "$i: command '${cmds[$i]}' exited with '${codes[$i]}'"
done
