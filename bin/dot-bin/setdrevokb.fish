#!/usr/bin/env fish

begin
    command -v (which xinput) >/dev/null 2>&1 && \
    command -v (which lsusb) >/dev/null 2>&1
end

if test $status -ne 0
    echo "Please check xinput and lsusb" > /dev/stderr
    exit -1
end

set drevoUSBID 'b404:0101'
set drevoUSB (lsusb -d "$drevoUSBID")
string match -rq "$drevoUSBID"' (?<drevoModel>.*)$' "$drevoUSB"

xinput list | string match -r '.*'$drevoModel'\s+id=.*$' | while read -l line
    echo $line | string match -rq '.*id=(?<drevoXID>\d+).*$'
    setxkbmap -device $drevoXID usfr
end
