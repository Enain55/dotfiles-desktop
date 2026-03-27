#!/bin/bash

INTERFACE="wg0"

if ip addr show "$INTERFACE" 2>/dev/null | grep -q "inet "; then
  country=$(curl -s --max-time 1 ifconfig.co/country 2>/dev/null)
  [[ -z "$country" ]] && country="ON"
  echo "<span foreground='#a6e3a1'>[ФАНТОМ]: $country</span>"
else
  echo "<span foreground='#bf616a'>[ФАНТОМ]: DOWN</span>"
fi