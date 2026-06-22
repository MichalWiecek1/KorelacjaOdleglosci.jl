# KorelacjaOdleglosci

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://MichalWiecek1.github.io/KorelacjaOdleglosci.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://MichalWiecek1.github.io/KorelacjaOdleglosci.jl/dev/)
[![Build Status](https://github.com/MichalWiecek1/KorelacjaOdleglosci.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/MichalWiecek1/KorelacjaOdleglosci.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/MichalWiecek1/KorelacjaOdleglosci.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/MichalWiecek1/KorelacjaOdleglosci.jl)

## Opis

Pakiet **KorelacjaOdleglosci.jl** zawiera implementację testu niezależności opartego na korelacji odległości (distance correlation).

Zaimplementowane są dwa estymatory korelacji odległości:
- estymator Szekely’ego (2007),
- estymator Zhanga (2019).

## Przykład użycia

using KorelacjaOdleglosci

x = rand(100)
y = x .^ 2

wynik = dCor_M_final(x, y)

