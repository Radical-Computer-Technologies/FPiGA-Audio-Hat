#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GOWIN_HOME="${GOWIN_HOME:-/home/jvincent/gowin}"
GOWIN_BIN="${GOWIN_BIN:-${GOWIN_HOME}/IDE/bin}"
GW_SH="${GW_SH:-${GOWIN_BIN}/gw_sh}"
BUILD_DIR="${FPIGA_GOWIN_BUILD_DIR:-${SCRIPT_DIR}/build/gowin}"
PROJECT_NAME="fpiga_audio"

if [[ ! -x "${GW_SH}" ]]; then
    echo "Gowin gw_sh not found or not executable: ${GW_SH}" >&2
    exit 2
fi

export FPIGA_GOWIN_BUILD_DIR="${BUILD_DIR}"
export QT_QPA_PLATFORM="${QT_QPA_PLATFORM:-offscreen}"
export QT_XCB_GL_INTEGRATION="${QT_XCB_GL_INTEGRATION:-none}"
export LD_LIBRARY_PATH="${GOWIN_HOME}/IDE/lib:${LD_LIBRARY_PATH:-}"

"${GW_SH}" "${SCRIPT_DIR}/gowin/build_fpiga_audio.tcl"

FS_FILE="${BUILD_DIR}/${PROJECT_NAME}/impl/pnr/${PROJECT_NAME}.fs"
SYN_LOG="${BUILD_DIR}/${PROJECT_NAME}/impl/gwsynthesis/${PROJECT_NAME}.log"
PNR_LOG="${BUILD_DIR}/${PROJECT_NAME}/impl/pnr/${PROJECT_NAME}.log"

if [[ ! -s "${FS_FILE}" ]]; then
    echo "Gowin flow did not produce a non-empty bitstream: ${FS_FILE}" >&2
    exit 3
fi

if grep -Eiq "(^|[^A-Za-z])(error|failed|failure)([^A-Za-z]|$)" "${SYN_LOG}" "${PNR_LOG}"; then
    echo "Gowin logs contain error/failure text; inspect:" >&2
    echo "  ${SYN_LOG}" >&2
    echo "  ${PNR_LOG}" >&2
    exit 4
fi

echo "Gowin bitstream: ${FS_FILE}"
