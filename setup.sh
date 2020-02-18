#!/bin/bash

export ip_local='10.10.10.10'
export port_local=443
export port_remote=65300
export useRecommended=true

confirm() {
    if $useRecommended; then
        false
    else
        # call with a prompt string or use a default
        read -r -p "${1:-Are you sure? [y/N]} " response
        case "$response" in
            [yY][eE][sS]|[yY]) 
                true
                ;;
            *)
                false
                ;;
        esac
    fi
}
export -f confirm

header() {
    echo ""
    echo ""
    echo "=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*"
    echo "** $1"
    echo "=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*"
}
export -f header

banner() {
    echo ""
    echo ""
    echo "============================================"
    echo "-- $1"
    echo "============================================"
}
export -f banner


header "Cleanup tasks"
bash _setup/clean.sh

header "Environment setup"
bash _setup/setup_env.sh

header "Lists - Payloaf, fuzzing, and other lists"
bash _setup/setup_lists.sh

header "Exploits - Exploits usable to gain initial foothold & prevesc"
for i in _setup/setup_exploits_*.sh; do bash $i; done

header "Tools - Different tools used locally (in attacker's machine)"
bash _setup/setup_tools.sh
for i in _setup/setup_tools_*.sh; do bash $i; done

header "Payloads - Different attack payloads"
for i in _setup/setup_payloads_*.sh; do bash $i; done

header "Public - Scripts or tools that need to be accessed from victim host"
for i in _setup/setup_public_*.sh; do bash $i; done

