project('zadanie', 'cpp')

foreach file : ['wersja0', 'wersja1']
  executable(file, file+'.cpp', cpp_args: [])
  executable(file+'prof', file+'.cpp', cpp_args: ['-pg'])
  executable(file+'O2', file+'.cpp', cpp_args: ['-O2'])
endforeach

