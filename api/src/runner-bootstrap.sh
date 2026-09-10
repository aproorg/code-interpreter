#!/bin/bash

# Try to raise open files limit if permitted
ulimit -Hn 65536 2>/dev/null || true
ulimit -Sn 65536 2>/dev/null || true

HARD_LIMIT=$(ulimit -Hn 2>/dev/null || echo 1024)
echo "=== System Limits ==="
echo "Hard nofile: $HARD_LIMIT"
echo "Soft nofile: $(ulimit -Sn 2>/dev/null || echo unknown)"

if [ "$HARD_LIMIT" = "unlimited" ]; then
    export SANDBOX_MAX_OPEN_FILES=1024
elif [ "$HARD_LIMIT" -ge 1024 ] 2>/dev/null; then
    export SANDBOX_MAX_OPEN_FILES=1024
elif [ "$HARD_LIMIT" -gt 0 ] 2>/dev/null; then
    export SANDBOX_MAX_OPEN_FILES="$HARD_LIMIT"
else
    export SANDBOX_MAX_OPEN_FILES=1024
fi
echo "SANDBOX_MAX_OPEN_FILES=$SANDBOX_MAX_OPEN_FILES"

# Remove any /proc submounts if possible
PROC_SUBMOUNTS=$(awk '$5 ~ /^\/proc\/./ {print $5}' /proc/self/mountinfo 2>/dev/null | sort -r)
for mnt in $PROC_SUBMOUNTS; do
    umount "$mnt" 2>/dev/null || true
done

# Ensure nobody user exists for nsjail
if ! timeout 2 getent passwd 65534 >/dev/null 2>&1; then
    useradd -M -u 65534 -s /usr/sbin/nologin nobody 2>/dev/null || true
fi

mkdir -p /tmp/sandbox
chmod 777 /tmp/sandbox

# Ensure python3 and python symlinks exist in /usr/bin
if [ -f /usr/bin/python3.12 ] && [ ! -e /usr/bin/python3 ]; then
    ln -sf /usr/bin/python3.12 /usr/bin/python3 2>/dev/null || true
    ln -sf /usr/bin/python3.12 /usr/bin/python 2>/dev/null || true
fi
if [ -f /usr/bin/pip3.12 ] && [ ! -e /usr/bin/pip3 ]; then
    ln -sf /usr/bin/pip3.12 /usr/bin/pip3 2>/dev/null || true
    ln -sf /usr/bin/pip3.12 /usr/bin/pip 2>/dev/null || true
fi

export PORT=8080
export SANDBOX_PACKAGES_DIRECTORY=/pkgs
export SANDBOX_SESSION_WORKSPACE_ENABLED=true
export SANDBOX_USE_CGROUPV2=false

exec /usr/local/bin/bun run /sandbox_api/.build/index.js
