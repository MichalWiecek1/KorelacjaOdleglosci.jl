# KorelacjaOdleglosci

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://MichalWiecek1.github.io/KorelacjaOdleglosci.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://MichalWiecek1.github.io/KorelacjaOdleglosci.jl/dev/)
[![Build Status](https://github.com/MichalWiecek1/KorelacjaOdleglosci.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/MichalWiecek1/KorelacjaOdleglosci.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/MichalWiecek1/KorelacjaOdleglosci.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/MichalWiecek1/KorelacjaOdleglosci.jl)

## Pakiet implementujący test niezależności oparty na korelacji odległości

Pakiet zawiera implementację testu niezależności opartego na korelacji odległości.

Zaimplementowane są dwa estymatory korelacji odległości:
- estymator Szekely’ego (2007),
- estymator Zhanga (2019).

## Jak zainstalować
```julia

using Pkg
Pkg.add(url="https://github.com/MichalWiecek1/KorelacjaOdleglosci.jl")
## Przykłady użycia

using KorelacjaOdleglosci

x = rand(100)
y = x .^ 2

wynik = dCor_M_final(x, y)


## Źródła merytoryczne

- Székely, G. J., Rizzo, M. L., & Bakirov, N. K. (2007).  
  *Measuring and Testing Dependence by Correlation of Distances*. Annals of Statistics.    

- Zhang, Q. (2019).  
  *Independence test for large sparse contingency tables based on distance correlation*.  

