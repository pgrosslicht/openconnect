#!/bin/sh
#
# Alex Wicks, 2021
# github.com/aw1cks
#

printf "\e[32m
    ___      ___      ___       __      ___      ___       __       __      ___      ___    __  ___ 
  //   ) ) //   ) ) //___) ) //   ) ) //   ) ) //   ) ) //   ) ) //   ) ) //___) ) //   ) )  / /    
 //   / / //___/ / //       //   / / //       //   / / //   / / //   / / //       //        / /     
((___/ / //       ((____   //   / / ((____   ((___/ / //   / / //   / / ((____   ((____    / /      
\e[0m\n"

# Test for presence of required vars
if [ -z "${URL}" ]
then
  printf "\e[31m\$URL is not set\n\e[0m" 
  exit 1
fi
printf "\e[33mURL:\e[0m %s \n" "${URL}"

if [ -z "${USER}" ]
then
  printf "\e[31m\$USER is not set\e[0m\n"
  exit 2
fi
printf "\e[33mUsername:\e[0m %s\n" "${USER}"

if [ -z "${PASS}" ]
then
  printf "\e[31m\$PASS is not set\e[0m\n"
  exit 3
fi
printf "\e[33mPassword:\e[0m [REDACTED]\n\n"

if [ -z "${HOSTNAMES}" ]
then
  printf "\e[31m\$HOSTNAMES is not set\e[0m\n"
  exit 2
fi
printf "\e[33mHostnames:\e[0m %s\n" "${HOSTNAMES}"

printf "\e[32mSetting mandatory arguments...\e[0m\n"
# Set user
OPENCONNECT_ARGS="--user=${USER} -i tun127 --passwd-on-stdin --non-inter"

# Test for auth group
printf "\e[32mChecking for authentication group parameter...\e[0m\n"
if [ -n "${AUTH_GROUP}" ]
then
  OPENCONNECT_ARGS="${OPENCONNECT_ARGS} --authgroup=${AUTH_GROUP}"
fi

# Add any additional arguments
printf "\e[32mChecking for additional arguments...\e[0m\n"
if [ -n "${EXTRA_ARGS}" ]
then
  OPENCONNECT_ARGS="${OPENCONNECT_ARGS} ${EXTRA_ARGS}"
fi

# URL needs to be the last argument
printf "\e[32mSetting URL...\e[0m\n"
OPENCONNECT_ARGS="${OPENCONNECT_ARGS} ${URL}"

printf "\e[32mStarting OpenConnect VPN...\e[0m\n"
OPENCONNECT_CMD="openconnect --script='vpn-slice ${HOSTNAMES}' ${OPENCONNECT_ARGS}"
printf "\e[33mArguments:\e[0m %s\n\n" "${OPENCONNECT_CMD}"
# shellcheck disable=SC2086
(echo "${PASS}"; [ -n "${OTP}" ] && echo "${OTP}") | eval ${OPENCONNECT_CMD}
