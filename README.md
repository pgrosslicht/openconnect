# OpenConnect Docker Container

![github](https://github.com/pgrosslicht/openconnect/actions/workflows/main.yml/badge.svg)
![gitlab](https://gitlab.com/pgrosslicht/openconnect/badges/master/pipeline.svg)

## Why?

OpenConnect doesn't ship with any init scripts or systemd units.
It's also not easy to non-interactively provide username, password and especially OTP.
Additionally, running in a docker container gives some extra flexibility with routing.

Additionally, this fork allows split-tunneling, that is only routing traffic through the VPN 
for specific hostnames or subnets using [vpn-splice](https://github.com/dlenski/vpn-slice).

## Where can I download it?

The image is built by GitHub Actions for amd64 & arm64 and pushed to the following repositories:

 - [GitHub Container Registry](https://github.com/users/pgrosslicht/packages/container/package/openconnect)

## How do I use it?

You can run the container using the specified arguments below.

### Basic container command

```shell
docker run -d \
--cap-add NET_ADMIN \
-e URL=https://my.vpn.com \
-e USER=myuser \
-e AUTH_GROUP=mygroup \
-e PASS=mypassword \
-e OTP=123456 \
-e SEARCH_DOMAINS="my.corporate-domain.com subdomain.my.corporate-domain.com" \
ghcr.io/pgrosslicht/openconnect'
```

### All container arguments

| Variable         | Explanation                                                                                                                                  | Example Value                                               |
|------------------|----------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| `URL`            | URL of AnyConnect VPN                                                                                                                        | `https://my.vpn.com`                                        |
| `USER`           | User to authenticate with                                                                                                                    | `myuser`                                                    |
| `AUTH_GROUP`     | Authentication Group to use when connecting to VPN (optional)                                                                                | `mygroup`                                                   |
| `PASS`           | Password to authenticate with                                                                                                                | `mypassword`                                                |
| `OTP`            | OTP/2FA code (optional)                                                                                                                      | `123456`                                                    |
| `SEARCH_DOMAINS` | Search domains to use. DNS for these domains will be routed via the VPN's DNS servers (optional). Separate with a space for multiple domains | `my.corporate-domain.com subdomain.my.corporate-domain.com` |
| `EXTRA_ARGS`     | Any additional arguments to be passed to the OpenConnect client (optional). Only use this if you need something specific                     | `--verbose`                                                 |
| `HOSTNAMES`      | Space separated list of hostnames that should be routed through the VPN.                                                                     | `server1.vpn.com server2.vpn.com`                           |

## Building the container yourself

The following build args are used:

 - `BUILD_DATE` (RFC3339 timestamp)
 - `COMMIT_SHA` (commit hash from which image was built)

```shell
docker build \
  --build-arg BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
  --build-arg COMMIT_SHA="$(git rev-parse HEAD 2>/dev/null || echo 'null')" \
  -t openconnect .
```

## Known issues

When running not in privileged mode, OpenConnect gives errors such as this:

`Cannot open "/proc/sys/net/ipv4/route/flush"`

This is normal and does not impact the operation of the VPN.

To suppress these errors, run with `--privileged`.

