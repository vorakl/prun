# Copyright (c) 2023 vorakl
# SPDX-License-Identifier: MIT

SHELL := /bin/bash

DESTDIR ?= 
PREFIX ?= /usr/local
MANPREFIX ?= ${PREFIX}/share/man

ECHO_BIN ?= echo
MAKE_BIN ?= make
INSTALL_BIN ?= install
MKDIR_BIN ?= mkdir
RM_BIN ?= rm


.MAIN: usage

.PHONY: usage
usage:
	@${ECHO_BIN} "Usage:"
	@${ECHO_BIN} "  make [target [...]] "
	@${ECHO_BIN} ""
	@${ECHO_BIN} "Examples:"
	@${ECHO_BIN} "  make check_bins clean build"
	@${ECHO_BIN} "  sudo make install"
	@${ECHO_BIN} "  sudo make uninstall"
	@${ECHO_BIN} ""
	@${ECHO_BIN} "Description:"
	@${ECHO_BIN} "  build           Build the tool"
	@${ECHO_BIN} "  install         Install built files to the system (requiers root permissions)"
	@${ECHO_BIN} "  uninstall       Uninstall the tool from the system (requiers root permissions)"
	@${ECHO_BIN} "  clean           Remove built files"
	@${ECHO_BIN} "  set_rel_tag     Set a Release tag to the current commit"
	@${ECHO_BIN} "  check_bins      Check if all binaries exist"
	@${ECHO_BIN} ""

.PHONY: check_bins
check_bins:
	@${MAKE_BIN} -C src check_bins
	@${ECHO_BIN} -n "Checking if all required binaries exist..."
	@${SHELL} -c 'command -v ${MAKE_BIN} >/dev/null || { ${ECHO_BIN} "${MAKE_BIN} not found"; exit 1; }'
	@${SHELL} -c 'command -v ${INSTALL_BIN} >/dev/null || { echo "${INSTALL_BIN} not found"; exit 1; }'
	@${SHELL} -c 'command -v ${MKDIR_BIN} >/dev/null || { echo "${MKDIR_BIN} not found"; exit 1; }'
	@${SHELL} -c 'command -v ${RM_BIN} >/dev/null || { echo "${RM_BIN} not found"; exit 1; }'
	@${ECHO_BIN} "Done"

.PHONY: build
build:
	@${MAKE_BIN} -C src build

.PHONY: clean
clean:
	@${MAKE_BIN} -C src clean

.PHONY: set_rel_tag
set_rel_tag:
	@${MAKE_BIN} -C src set_rel_tag

.PHONY: install
install:
	@${ECHO_BIN} -n "Installing built files to the system..."
	@${MKDIR_BIN} -p ${DESTDIR}${PREFIX}/bin
	@${MKDIR_BIN} -p ${DESTDIR}${MANPREFIX}/man1
	@install -m 644 prun.1 ${DESTDIR}${MANPREFIX}/man1
	@install prun ${DESTDIR}${PREFIX}/bin
	@install prun-parse ${DESTDIR}${PREFIX}/bin
	@${ECHO_BIN} "Done"

.PHONY: uninstall
uninstall:
	@${ECHO_BIN} -n "Uninstalling the tool from the system..."
	@${RM_BIN} -f ${DESTDIR}${PREFIX}/bin/prun
	@${RM_BIN} -f ${DESTDIR}${PREFIX}/bin/prun-parse
	@${RM_BIN} -f ${DESTDIR}${MANPREFIX}/man1/prun.1
	@${ECHO_BIN} "Done"
