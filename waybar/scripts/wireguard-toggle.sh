#!/bin/bash

INTERFACE="wg0"
WGQUICK="/usr/bin/wg-quick"
PKEXEC="/usr/bin/pkexec"

if ip addr show "$INTERFACE" 2>/dev/null | grep -q "inet "; then
  CMD="$WGQUICK down $INTERFACE"
else
  CMD="$WGQUICK up $INTERFACE"
fi

(
  $PKEXEC $CMD
) &