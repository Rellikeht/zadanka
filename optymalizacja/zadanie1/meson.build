project('zadanie', 'cpp')

foreach file : ['wersja0', 'wersja1']
  src = file+'.cpp'
  executable(file, src, cpp_args: [])
  executable(file+'prof', src, cpp_args: ['-pg'])
  executable(file+'O2', src, cpp_args: ['-O2'])
endforeach

