from zad1testy import runtests


def cpal(s):
    if len(s) % 2 == 0:
        return 0
    i = len(s)//2-1
    maxlen = 1
    while i >= 0:
        if s[i] != s[len(s)-1-i]:
            return maxlen
        maxlen += 2
    return maxlen


def ceasar(s):
    maxlen = 1
    for i in range(len(s)):
        for j in range(i+1, len(s)):
            plen = cpal(s[i:j])
            if plen > maxlen:
                maxlen = plen
    return maxlen


# zmien all_tests na True zeby uruchomic wszystkie testy
runtests(ceasar, all_tests=True)
