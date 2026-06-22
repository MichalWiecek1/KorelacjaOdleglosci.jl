module KorelacjaOdleglosci
export dCor_Zhang dCor_M_final p_value_Székely  p_value_Zhangely

function tabela(x, y)
    ux = unique(x)
    uy = unique(y)
    map_x = Dict(val => i for (i, val) in enumerate(ux))
    map_y = Dict(val => i for (i, val) in enumerate(uy))
    tabela = zeros(Int, length(ux), length(uy))
    for (u, v) in zip(x, y)
        i = map_x[u]
        j = map_y[v]
        tabela[i, j] += 1
    end
    return tabela
end

function dCor_Zhang(x,y)
    nij = tabela(x,y)
    n = sum(nij)
    pij = nij ./ n 
    pi = sum(pij,dims=2)
    pj = sum(pij,dims=1)
    pipj = (pi[i] * pj[j] for i in 1:length(pi), j in 1:length(pj))
    a = sum((e - o)^2 for (e,o) in zip(pij,pipj))
    b = sum(i -> i^2, pi) * (sum(i -> i^2, pi) + 1) - 2sum(i -> i^3, pi)
    c = sum(i -> i^2, pj) * (sum(i -> i^2, pj) + 1) - 2sum(i -> i^3, pj)
    return sqrt(a / sqrt(b*c))
end
end
