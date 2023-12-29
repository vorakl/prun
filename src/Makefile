#
# Copyright (c) 2023 prun contributors
# SPDX-License-Identifier: MIT
#

SHELL := /bin/bash
LC_COLLATE := en_US.UTF-8

ECHO_BIN ?= echo
PWD_BIN ?= pwd
SED_BIN ?= sed
GIT_BIN ?= git
DATE_BIN ?= date
CHMOD_BIN ?= chmod
RM_BIN ?= rm
SORT_BIN ?= sort

CURR_DIR := $(shell ${PWD_BIN} -P)
CURR_VER := $(shell ${GIT_BIN} describe --long)
CURR_VER_DATE := $(shell ${GIT_BIN} log --pretty=format:"%ad" --date=format:"%Y-%m-%d" ${CURR_VER} -1)
CURR_DATE_LONG := $(shell ${DATE_BIN} --iso-8601=seconds)
LAST_COMMIT := $(shell ${GIT_BIN} log --pretty=format:"%h" -1)
LAST_COMMIT_DATE := $(shell ${GIT_BIN} log --pretty=format:"%aI" -1)
LAST_COMMIT_TAG := $(shell TZ="UTC" ${DATE_BIN} --date="${LAST_COMMIT_DATE}" '+%y.%j %k %M' | { read d h m; echo "$${d}.$$((h*60+m))"; })


.MAIN: usage

.PHONY: usage
usage:
	@${ECHO_BIN} "Usage:"
	@${ECHO_BIN} "	make [target [...]] "
	@${ECHO_BIN} ""
	@${ECHO_BIN} "Examples:"
	@${ECHO_BIN} "  make build"
	@${ECHO_BIN} "  make clean"
	@${ECHO_BIN} "  make setreltag"
	@${ECHO_BIN} "  make create_contributors"
	@${ECHO_BIN} "  make check_bins"
	@${ECHO_BIN} ""
	@${ECHO_BIN} "Description:"
	@${ECHO_BIN} "  build                Build the project"
	@${ECHO_BIN} "  clean                Remove built files"
	@${ECHO_BIN} "  set_rel_tag          Set a Release tag to the current commit"
	@${ECHO_BIN} "  create_contributors  Create a CONTRIBUTORS files"
	@${ECHO_BIN} "  check_bins           Check if all binaries exist"
	@${ECHO_BIN} ""

.PHONY: check_bins
check_bins:
	@${ECHO_BIN} -n "Checking if all required binaries exist..."
	@${SHELL} -c 'command -v ${PWD_BIN} >/dev/null || { ${ECHO_BIN} "${PWD_BIN} not found"; exit 1; }'
	@${SHELL} -c 'command -v ${SED_BIN} >/dev/null || { ${ECHO_BIN} "${SED_BIN} not found"; exit 1; }'
	@${SHELL} -c 'command -v ${GIT_BIN} >/dev/null || { ${ECHO_BIN} "${GIT_BIN} not found"; exit 1; }'
	@${SHELL} -c 'command -v ${DATE_BIN} >/dev/null || { ${ECHO_BIN} "${DATE_BIN} not found"; exit 1; }'
	@${SHELL} -c 'command -v ${CHMOD_BIN} >/dev/null || { ${ECHO_BIN} "${CHMOD_BIN} not found"; exit 1; }'
	@${SHELL} -c 'command -v ${RM_BIN} >/dev/null || { ${ECHO_BIN} "${RM_BIN} not found"; exit 1; }'
	@${SHELL} -c 'command -v ${SORT_BIN} >/dev/null || { ${ECHO_BIN} "${SORT_BIN} not found"; exit 1; }'
	@${ECHO_BIN} "Done"

.PHONY: build
build:
	@${ECHO_BIN} -n "Building version ${CURR_VER} from ${CURR_VER_DATE}..."
	@${SED_BIN} "s|{{date}}|${CURR_VER_DATE}|;s|{{version}}|${CURR_VER}|" ${CURR_DIR}/prun.bash \
		    > ${CURR_DIR}/../prun
	@${CHMOD_BIN} +x ${CURR_DIR}/../prun
	@${SED_BIN} 's|{{date}}|${CURR_VER_DATE}|;s|{{version}}|${CURR_VER}|' ${CURR_DIR}/prun.man1 \
		    > ${CURR_DIR}/../prun.1
	@${SED_BIN} 's|{{version}}|${CURR_VER}|' ${CURR_DIR}/prun-parse.bash \
		    > ${CURR_DIR}/../prun-parse
	@${CHMOD_BIN} +x ${CURR_DIR}/../prun-parse
	@${ECHO_BIN} "Done"

.PHONY: clean
clean:
	@${ECHO_BIN} -n "Removing built files..."
	@${RM_BIN} -f ${CURR_DIR}/../prun ${CURR_DIR}/../prun.1 ${CURR_DIR}/../prun-parse
	@${ECHO_BIN} "Done"

.PHONY: set_rel_tag
set_rel_tag:
	@${ECHO_BIN} "Setting a release tag r${LAST_COMMIT_TAG}..."
	@GIT_COMMITTER_DATE="${CURR_DATE_LONG}" ${GIT_BIN} tag -s r${LAST_COMMIT_TAG} ${LAST_COMMIT}
	@${ECHO_BIN} "Done"

.PHONY: create_contributors
create_contributors:
	@${ECHO_BIN} "Creating a CONTRIBUTORS file..."
	@${GIT_BIN} log --pretty=format:"%an" | sort -u > ${CURR_DIR}/../CONTRIBUTORS
	@${ECHO_BIN} "Done"

