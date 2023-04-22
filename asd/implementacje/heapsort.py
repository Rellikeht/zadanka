def naive_heapify(arr, i, n):
    left = 2*i
    right = 2*i+1
    maxi = i

    if left < n and arr[maxi] < arr[left]:
        maxi = left
    if right < n and arr[maxi] < arr[right]:
        maxi = right

    if maxi != i:
        arr[i], arr[maxi] = arr[maxi], arr[i]
        naive_heapify(arr, maxi, n)


def heapify(arr, i, n):
    while True:
        left = 2*i
        right = 2*i+1
        maxi = i

        if left < n and arr[maxi] < arr[left]:
            maxi = left
        if right < n and arr[maxi] < arr[right]:
            maxi = right

        if maxi == i:
            break
        arr[i], arr[maxi] = arr[maxi], arr[i]
        i = maxi


def buildheap(arr):
    for i in range((len(arr)-1)//2, -1, -1):
        heapify(arr, i, len(arr))


def heapsort(arr):
    buildheap(arr)
    for i in range(len(arr)-1, -1, -1):
        arr[0], arr[i] = arr[i], arr[0]
        heapify(arr, 0, i)
