#!/bin/bash

network_status() {
    if nmcli networking | grep -q "enabled";
    then
        echo on
    else
        echo off
    fi
}

toggle_network() {
    if [[ $(network_status) == "on" ]];
    then
        nmcli networking off
    else
        nmcli networking on
    fi
}

case "$1" in
    status)
        network_status
        ;;
    toggle)
        toggle_network
        ;;
    *)
        echo "Usage: $0 {status|toggle}"
        exit 1
        ;;
esac
