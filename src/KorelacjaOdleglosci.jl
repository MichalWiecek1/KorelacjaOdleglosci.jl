module KorelacjaOdleglosci
export dCor8, dCor7, dCor_Zhang, dCov_Székely

function dCor8(X,Y)
    sum_x=sum(X)
    sum_y=sum(Y)
    n=sum_x+sum_y
    nj0 = sum_x / n
    nj1 = sum_y / n
    ni=(X+Y)/n
    n2=sum(x -> x^2,ni)
    return sqrt(sum((X / n - ni * nj0) .^ 2 + (Y / n - ni * nj1) .^ 2))/(
    (n2 * (n2 + 1) - 2sum(x -> x^3,ni)) *
    ((nj0^2+nj1^2) * (nj0^2+nj1^2 + 1) -2(nj0^3+nj1^3) ))^0.25
end

function dCor7(x,y)
    sum_x = sum(x)
    sum_y = sum(y)
    n = sum_x + sum_y
    nj₁ = sum_x / n
    nj₂ = sum_y / n
    z = (x .+ y) ./ n
    z2 = sum(i -> i^2, z)
    a = sum(i -> (i[1]/n - i[3]*nj₁)^2 + (i[2]/n - i[3]*nj₂)^2, zip(x,y,z))
    b = z2 * (z2 + 1) - 2sum(i -> i^3, z)
    c = (nj₁^2 + nj₂^2) * (nj₁^2 + nj₂^2 + 1) - 2(nj₁^3 + nj₂^3)
    return sqrt(a / sqrt(b*c))
end

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

function dCov_Székely(x,y)
    n = length(x)
    A = zeros(Float64,n,n)
    B = zeros(Float64,n,n)
    for i in 1:n, j in 1:n
        A[i,j] = abs(x[i] - x[j])
        B[i,j] = abs(y[i] - y[j])
    end
    A = A .- mean(A,dims=1) .- mean(A,dims=2) .+ mean(A)
    B = B .- mean(B,dims=1) .- mean(B,dims=2) .+ mean(B)
    return mean(A .* B)
end

function dCor_Székely(x,y)
    return dCov_Székely(x,y) / sqrt(dCov_Székely(x,x) * dCov_Székely(y,y))
end

end
