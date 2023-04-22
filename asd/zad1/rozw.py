# Autor: Michał Hemperek
# Złożoność: O(n^2)
# Program dla każdego znaku sprawdza jak długiego palindromu jest środkiem
# i zwraca długość najdłuższego z nich

from zad1testy import runtests

def ceasar(s):
    maxlen = 1
     # sprawdzanie pierwszego i ostatniego znaku i tak zwróci 1
    i = 1
    while i <= len(s) - (1+maxlen)//2:
        j = 1
        clen = 1
        while i-j >= 0 and i+j < len(s):
            if s[i-j] != s[i+j]:
                if clen > maxlen:
                    maxlen = clen
                break
            j += 1
            clen += 2
        else:
            if clen > maxlen:
                maxlen = clen
        i += 1
    return maxlen

runtests(ceasar, all_tests=True)
