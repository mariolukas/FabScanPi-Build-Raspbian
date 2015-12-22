#!/bin/bash

WORKSPACE_DIR="/opt/build"

function RMSafe()
{
    rm --one-file-system --preserve-root $@
}

function GetWorkspace()
{
    local name="$@"

    mkdir -p "${WORKSPACE_DIR}"

    echo "${WORKSPACE_DIR}/${name}"
}

function ReleaseWorkspace()
{
    local name="$@"

    RMSafe -r "${WORKSPACE_DIR}/${name}"
}

function BannerEcho()
{
    echo "------------------------------------------------------------------"
    for arg in "$@"
    do
        echo "    $arg"
    done
    echo "------------------------------------------------------------------"
}

function PipInstall()
{
    local to_install="$1"
    if [ -n "$(pip install ${to_install})" ]
    then
        RMSafe -r $HOME/.cache/pip
        pip install ${to_install} || return 1
    fi

    return 0
}

function AptUpdate()
{
    apt-get update $@
}

function AptCleanup()
{
    apt-get clean $@
}

function AptInstall()
{
    apt-get install -y --force-yes $@
}

function AptInstallLater()
{
    ${FANCY_SAUCE_PATH}/install_later.sh "$1" "${INSTALL_LATER_PATH}" "${INSTALL_LATER_CACHE_PATH}"
}

function GetFile()
{
	local base_url=$1
	local filename=$2

	wget -N "${base_url}/${filename}"
}

function DirectoryOrderedExecute()
{
    local directory=$1
    local cfg
    local cfgs
    local cfgn

    cfgs=`ls -1 "${directory}"/[0-9]*`
    for cfg in $cfgs; do
        cd ${directory}
        cfgn=`basename ${cfg}`
        echo "Applying ${cfgn}..."
        source ${cfg}
    done
}

function CheckDownload()
{
    local uri="$1"
    local output_file="$2"
    local wget_args="--span-hosts --level=10 --no-check-certificate --restrict-file-names=nocontrol --retry-connrefused --content-disposition"

    if [ -f "${output_file}" ]
    then
        return 0
    fi

    wget ${wget_args} "${uri}" -O "${output_file}"
}

function ExtractTar()
{
    local src_tar="$1"
    local src_dir="$2"

    mkdir -p ${src_dir}
    tar -xaf "${src_tar}" -C "${src_dir}" --strip-components=1
}
