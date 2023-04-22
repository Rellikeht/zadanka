#!/bin/env -S nim r -d:release --mm:arc --hints:off
import strutils

template printArr(arr: openArray) =
  for i in arr:
    echo i

template printArrLine(arr: openArray) =
  for i in arr:
    stdout.write($i&" ")
  stdout.writeLine("")

type compf[T] = proc(a, b: T): bool {.noSideEffect.}
proc left(i: int): int {.inline.} = 2*i
proc right(i: int): int {.inline.} = 2*i+1
proc parent(i: int): int {.inline.} = i div 2

proc heapify[T](arr: var openArray[T], comp: compf[T], i, n: int) =
  let
    l = left(i)
    r = right(i)
  var maxi = i

  if l < n and comp(arr[maxi], arr[l]): maxi = l
  if r < n and comp(arr[maxi], arr[r]): maxi = r

  if maxi != i:
    swap(arr[i], arr[maxi])
    heapify(arr, comp, maxi, n)

proc heapify[T](arr: var openArray[T], comp: compf[T], i: int) =
  heapify(arr, comp, i, len(arr))

proc buildheap[T](arr: var openArray[T], comp: compf[T]) =
  for i in countdown(parent(len(arr)-1), 0):
    heapify(arr, comp, i)

proc heapsort[T](arr: var openArray[T], comp: compf[T]) =
  buildheap(arr, comp)
  for i in countdown(len(arr)-1, 0):
    swap(arr[0], arr[i])
    heapify(arr, comp, 0, i)

var nums = block:
  var result: seq[int]
  for l in stdin.lines():
    for p in l.splitWhitespace():
      add(result, parseInt(p))
  result

func lt(a, b: int): bool = a <= b
printArrLine nums
echo ""
heapsort(nums, lt)
printArrLine nums
