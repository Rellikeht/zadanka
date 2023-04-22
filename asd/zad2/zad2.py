# Autor: Michał Hemperek
# Złożoność: O(n)
# Na samym początku wybieramy z tablicy elementy większe
# niż jej długość, bo i tak zostałyby wybrane.
# Później spisujemy ilość elementów o poszczególnych wartościach
# do dodatkowej tablicy gdzie wartości elementu odpowiada indeks
# jej równy. Na końcu wybieramy największe elementy, które nie
# roztopią się, zanim do nich dotrzemy

from zad2testy import runtests


def snow(S):
    total = 0
    j = 0
    aux = [0 for i in range(len(S)+1)]

    for i in range(len(S)):
        if S[i] > len(S):
            total += S[i] - j
            j += 1
        else:
            aux[S[i]] += 1

    for i in range(len(S), -1, -1):
        while aux[i] > 0 and i-j > 0:
            total += i-j
            j += 1
            aux[i] -= 1
        if i < j:
            break

    return total


# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(snow, all_tests=True)
