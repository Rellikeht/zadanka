project('zadanie', ['cpp', 'c'])
add_global_link_arguments('-lm', '-lpapi', language : ['c', 'cpp'])
CFLAGS = ['-Wall', '-Wextra']

executable('papi_test', 'papi_test.c')
foreach file : [
  'wersja0',
  'wersja1'
]
  src = file+'.cpp'
  executable(file, src, cpp_args: []+CFLAGS)
  executable(file+'prof', src, cpp_args: ['-pg'] + CFLAGS, link_args: ['-pg'])
  executable(file+'O2', src, cpp_args: ['-O2'] + CFLAGS)
endforeach
