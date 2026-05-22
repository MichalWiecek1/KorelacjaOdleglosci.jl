using KorelacjaOdleglosci
using Documenter

DocMeta.setdocmeta!(KorelacjaOdleglosci, :DocTestSetup, :(using KorelacjaOdleglosci); recursive=true)

makedocs(;
    modules=[KorelacjaOdleglosci],
    authors="Michał Więcek, Igor Ciesielski, Kamil Burnecki, PWr",
    sitename="KorelacjaOdleglosci.jl",
    format=Documenter.HTML(;
        canonical="https://MichalWiecek1.github.io/KorelacjaOdleglosci.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/MichalWiecek1/KorelacjaOdleglosci.jl",
    devbranch="master",
)
