#!/usr/bin/env julia

using Pkg
Pkg.activate(".")
using Pluto
Pluto.run(
    auto_reload_from_file=true,
    launch_browser=false
)
