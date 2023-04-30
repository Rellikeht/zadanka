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
    l = left(i)+n
    r = right(i)+n
    m = len(arr)
  var maxi = i+n

  if l < m and comp(arr[l], arr[maxi]): maxi = l
  if r < m and comp(arr[r], arr[maxi]): maxi = r

  if maxi != i+n:
    swap(arr[i+n], arr[maxi])
    heapify(arr, comp, maxi-n, n)

proc heapify[T](arr: var openArray[T], comp: compf[T], i: int) =
  heapify(arr, comp, i, 0)

proc buildheap[T](arr: var openArray[T], comp: compf[T], n: int) =
  for i in countdown(parent(len(arr)-1), 0):
    heapify(arr, comp, i, n)

proc buildheap[T](arr: var openArray[T], comp: compf[T]) =
  buildheap(arr, comp, 0)

proc heapsort[T](arr: var openArray[T], comp: compf[T]) =
  buildheap(arr, comp)
  for i in 1..<len(arr):
#    printArrLine arr
    #heapify(arr, comp, 0, i) # nie działa
    buildheap(arr, comp, i) # chujowe

var nums = block:
  var result: seq[int]
  for l in stdin.lines():
    for p in l.splitWhitespace():
      add(result, parseInt(p))
  result

func lt(a, b: int): bool = a <= b
heapsort(nums, lt)
#echo ""
printArrLine nums
