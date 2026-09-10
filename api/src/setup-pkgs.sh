#!/bin/bash
set -e

# Python 3.14.4 & 3.12.13
mkdir -p /pkgs/python/3.14.4 /pkgs/python/3.12.13
cat << 'PJSON' > /pkgs/python/3.14.4/pkg-info.json
{
    "language": "python",
    "version": "3.14.4",
    "aliases": ["py", "py3", "python", "python3", "python3.12", "python3.14"]
}
PJSON
cat << 'PRUN' > /pkgs/python/3.14.4/run
#!/bin/bash
exec /usr/bin/python3.12 "$@"
PRUN
chmod +x /pkgs/python/3.14.4/run
echo "PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:." > /pkgs/python/3.14.4/.env
echo "$(date +%s)000" > /pkgs/python/3.14.4/.package-installed

cp -r /pkgs/python/3.14.4/* /pkgs/python/3.12.13/
cat << 'PJSON' > /pkgs/python/3.12.13/pkg-info.json
{
    "language": "python",
    "version": "3.12.13",
    "aliases": ["py", "py3", "python", "python3", "python3.12"]
}
PJSON

mkdir -p /pkgs/python/3.14.4/bin /pkgs/python/3.12.13/bin
ln -sf /usr/bin/python3.12 /pkgs/python/3.14.4/bin/python3
ln -sf /usr/bin/python3.12 /pkgs/python/3.14.4/bin/python
ln -sf /usr/bin/python3.12 /pkgs/python/3.12.13/bin/python3
ln -sf /usr/bin/python3.12 /pkgs/python/3.12.13/bin/python

# Bash 5.2.0 & 5.2.15
mkdir -p /pkgs/bash/5.2.0 /pkgs/bash/5.2.15
cat << 'BJSON' > /pkgs/bash/5.2.0/pkg-info.json
{
    "language": "bash",
    "version": "5.2.0",
    "aliases": ["sh", "shell"]
}
BJSON
cat << 'BRUN' > /pkgs/bash/5.2.0/run
#!/bin/bash
exec /bin/bash "$@"
BRUN
chmod +x /pkgs/bash/5.2.0/run
echo "PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:." > /pkgs/bash/5.2.0/.env
echo "$(date +%s)000" > /pkgs/bash/5.2.0/.package-installed

cp -r /pkgs/bash/5.2.0/* /pkgs/bash/5.2.15/
cat << 'BJSON' > /pkgs/bash/5.2.15/pkg-info.json
{
    "language": "bash",
    "version": "5.2.15",
    "aliases": ["sh", "shell"]
}
BJSON

# Bun 1.3.14 & 1.4.2
mkdir -p /pkgs/bun/1.3.14 /pkgs/bun/1.4.2
cat << 'BUNJSON' > /pkgs/bun/1.3.14/pkg-info.json
{
    "language": "bun",
    "version": "1.3.14",
    "provides": [
        { "language": "typescript", "aliases": ["bun-ts", "ts"] },
        { "language": "javascript", "aliases": ["bun-js", "js"] }
    ]
}
BUNJSON
cat << 'BUNRUN' > /pkgs/bun/1.3.14/run
#!/bin/bash
exec /usr/local/bin/bun run "$@"
BUNRUN
chmod +x /pkgs/bun/1.3.14/run
echo "PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:." > /pkgs/bun/1.3.14/.env
echo "$(date +%s)000" > /pkgs/bun/1.3.14/.package-installed

cp -r /pkgs/bun/1.3.14/* /pkgs/bun/1.4.2/
cat << 'BUNJSON' > /pkgs/bun/1.4.2/pkg-info.json
{
    "language": "bun",
    "version": "1.4.2",
    "provides": [
        { "language": "typescript", "aliases": ["bun-ts", "ts"] },
        { "language": "javascript", "aliases": ["bun-js", "js"] }
    ]
}
BUNJSON

# Node 24.15.0 & 18.20.8
mkdir -p /pkgs/node/24.15.0 /pkgs/node/18.20.8
cat << 'NODEJSON' > /pkgs/node/24.15.0/pkg-info.json
{
    "language": "node",
    "version": "24.15.0",
    "aliases": ["nodejs", "node-js", "node-javascript", "js"]
}
NODEJSON
cat << 'NODERUN' > /pkgs/node/24.15.0/run
#!/bin/bash
exec /usr/bin/node "$@"
NODERUN
chmod +x /pkgs/node/24.15.0/run
echo "PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:." > /pkgs/node/24.15.0/.env
echo "$(date +%s)000" > /pkgs/node/24.15.0/.package-installed

cp -r /pkgs/node/24.15.0/* /pkgs/node/18.20.8/
cat << 'NODEJSON' > /pkgs/node/18.20.8/pkg-info.json
{
    "language": "node",
    "version": "18.20.8",
    "aliases": ["nodejs", "node-js", "node-javascript", "js"]
}
NODEJSON

echo "Package setup complete in /pkgs"
