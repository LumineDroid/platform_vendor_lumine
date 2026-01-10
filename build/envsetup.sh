CLANG_VERSION=$(${ANDROID_BUILD_TOP}/build/soong/scripts/get_clang_version.py)
export LLVM_AOSP_PREBUILTS_VERSION="${CLANG_VERSION}"

RUST_VERSION=$(grep 'RustDefaultVersion =' ${ANDROID_BUILD_TOP}/build/soong/rust/config/global.go | awk '{print $3}' | awk -F '"' '{print $2}')
export RUST_AOSP_PREBUILTS_VERSION="${RUST_VERSION}"

function brunch()
{
    breakfast $*
    if [ $? -eq 0 ]; then
        mka bacon
    else
        echo "No such item in brunch menu. Try 'breakfast'"
        return 1
    fi
    return $?
}

function breakfast()
{
    target=$1
    local variant=$2
    source ${ANDROID_BUILD_TOP}/vendor/lumine/vars/aosp_target_release

    if [ $# -eq 0 ]; then
        # No arguments, so let's have the full menu
        lunch
    else
        if [[ "$target" =~ -(user|userdebug|eng)$ ]]; then
            # A buildtype was specified, assume a full device name
            lunch $target
        else
            # This is probably just the LumineDroid model name
            if [ -z "$variant" ]; then
                variant="userdebug"
            fi

            lunch $target-$aosp_target_release-$variant
        fi
    fi
    return $?
}

alias bib=breakfast

function aospremote()
{
    local T=`git rev-parse --show-toplevel 2> /dev/null`
    if [ -z "$T" ]
    then
        echo "Git repository not found. Please run this from the directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm aosp 2> /dev/null

    if [ -f "$T/.gitupstream" ]; then
        local REMOTE=$(cat "$T/.gitupstream" | cut -d ' ' -f 1)
        git remote add aosp ${REMOTE}
    else
        local PROJECT=$(pwd -P | sed -e "s#$ANDROID_BUILD_TOP\/##; s#-caf.*##; s#\/default##")
        # Google moved the repo location in Oreo
        if [ $PROJECT = "build/make" ]
        then
            PROJECT="build"
        fi
        if (echo $PROJECT | grep -qv "^device")
        then
            local PFX="platform/"
        fi
        git remote add aosp https://android.googlesource.com/$PFX$PROJECT
    fi
    echo "Remote 'aosp' created"
}

function cloremote()
{
    local T=`git rev-parse --show-toplevel 2> /dev/null`
    if [ -z "$T" ]
    then
        echo "Git repository not found. Please run this from the directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm clo 2> /dev/null

    if [ -f "$T/.gitupstream" ]; then
        local REMOTE=$(cat "$T/.gitupstream" | cut -d ' ' -f 1)
        git remote add clo ${REMOTE}
    else
        local PROJECT=$(pwd -P | sed -e "s#$ANDROID_BUILD_TOP\/##; s#-caf.*##; s#\/default##")
        # Google moved the repo location in Oreo
        if [ $PROJECT = "build/make" ]
        then
            PROJECT="build_repo"
        fi
        if [[ $PROJECT =~ "qcom/opensource" ]];
        then
            PROJECT=$(echo $PROJECT | sed -e "s#qcom\/opensource#qcom-opensource#")
        fi
        if (echo $PROJECT | grep -qv "^device")
        then
            local PFX="platform/"
        fi
        git remote add clo https://git.codelinaro.org/clo/la/$PFX$PROJECT
    fi
    echo "Remote 'clo' created"
}

function githubremote()
{
    if ! git rev-parse --git-dir &> /dev/null
    then
        echo ".git directory not found. Please run this from the root directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm github 2> /dev/null
    local REMOTE=$(git config --get remote.aosp.projectname)

    if [ -z "$REMOTE" ]
    then
        REMOTE=$(git config --get remote.clo.projectname)
    fi

    local PROJECT=$(echo $REMOTE | sed -e "s#platform/#android/#g; s#/#_#g")

    git remote add github https://github.com/LumineDroid/$PROJECT
    echo "Remote 'github' created"
}

function privateremote()
{
    if ! git rev-parse --git-dir &> /dev/null
    then
        echo ".git directory not found. Please run this from the root directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm private 2> /dev/null
    local PROJECT=$(git config --get remote.github.projectname)

    git remote add private git@github.com:$PROJECT.git
    echo "Remote 'private' created"
}

function mka() {
    m "$@"
}

function cmka() {
    if [ ! -z "$1" ]; then
        for i in "$@"; do
            case $i in
                bacon|otapackage|systemimage)
                    mka installclean
                    mka $i
                    ;;
                *)
                    mka clean-$i
                    mka $i
                    ;;
            esac
        done
    else
        mka clean
        mka
    fi
}

function repolastsync() {
    RLSPATH="$ANDROID_BUILD_TOP/.repo/.repo_fetchtimes.json"
    RLSLOCAL=$(date -d "$(stat -c %z $RLSPATH)" +"%e %b %Y, %T %Z")
    RLSUTC=$(date -d "$(stat -c %z $RLSPATH)" -u +"%e %b %Y, %T %Z")
    echo "Last repo sync: $RLSLOCAL / $RLSUTC"
}

function reposync() {
    repo sync -j 4 "$@"
}

function repodiff() {
    if [ -z "$*" ]; then
        echo "Usage: repodiff <ref-from> [[ref-to] [--numstat]]"
        return
    fi
    diffopts=$* repo forall -c \
      'echo "$REPO_PATH ($REPO_REMOTE)"; git diff ${diffopts} 2>/dev/null ;'
}

function sort-blobs-list() {
    T=$(gettop)
    $T/tools/extract-utils/sort-blobs-list.py $@
}

function fixup_common_out_dir() {
    common_out_dir=$(_get_build_var_cached OUT_DIR)/target/common
    target_device=$(_get_build_var_cached TARGET_DEVICE)
    common_target_out=common-${target_device}
    if [ ! -z $LUMINE_FIXUP_COMMON_OUT ]; then
        if [ -d ${common_out_dir} ] && [ ! -L ${common_out_dir} ]; then
            mv ${common_out_dir} ${common_out_dir}-${target_device}
            ln -s ${common_target_out} ${common_out_dir}
        else
            [ -L ${common_out_dir} ] && rm ${common_out_dir}
            mkdir -p ${common_out_dir}-${target_device}
            ln -s ${common_target_out} ${common_out_dir}
        fi
    else
        [ -L ${common_out_dir} ] && rm ${common_out_dir}
        mkdir -p ${common_out_dir}
    fi
}

export SKIP_ABI_CHECKS=true

function generate_host_overrides() {
    export BUILD_USERNAME=android-build
    HEX=$(openssl rand -hex 8)
    ALPHA=$(cat /dev/urandom | tr -dc 'a-z0-9' | head -c 4)
    export BUILD_HOSTNAME="r-${HEX}-${ALPHA}"
    echo "BUILD_USERNAME=$BUILD_USERNAME"
    echo "BUILD_HOSTNAME=$BUILD_HOSTNAME"
}

generate_host_overrides
