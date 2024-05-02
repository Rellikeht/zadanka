#!/usr/bin/env -S julia -g0 -O3 -t auto --banner=no

using Pkg
Pkg.activate(".")
using Pluto
Pluto.run(
    auto_reload_from_file=true,
    launch_browser=false
)
