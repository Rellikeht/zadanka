#!/bin/env -S nim e --hints:off

func ceasar(s: string): int =
  result = 1
  var i = 1
  while i <= len(s) - (1 + result) div 2:
    var
      j = 1
      clen = 1
    while i-j >= 0 and i+j < len(s):
      if s[i-j] != s[i+j]:
        if clen > result:
          result = clen
        break
      j += 1
      clen += 2
    if clen > result:
      result = clen
    i += 1

echo ceasar(stdin.readLine())
