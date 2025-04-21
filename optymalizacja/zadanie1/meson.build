project('zadanie', 'cpp')
CFLAGS = ['-Wall', '-Wextra']

foreach file : [
  'wersja1',
  'wersja2',
  'wersja3',
  'wersja4',
  'wersja5',
  'wersja6',
  'wersja7'
]
  src = file+'.cpp'
  executable(file, src, cpp_args: []+CFLAGS)
  executable(file+'prof', src, cpp_args: ['-pg'] + CFLAGS, link_args: ['-pg'])
  executable(file+'O2', src, cpp_args: ['-O2'] + CFLAGS)
endforeach
