module KorelacjaOdleglosci
using Random
export dCor_Zhang, dCor_M_final, p_value_Székely, p_value_Zhang

function dCor_M_final(x,y)
    """
    dCor_M_final(x, y)

    Funkcja licząca estymator Szekely'ego korelacji odległości między zmiennymi/wektorami x i y
    
    Argumenty:
    x::Vector{<:Number}:Pierwszy wektor obserwacji
    y::Vector{<:Number}:Drugi wektor obserwacji o tej samej długości jak x

    Zwraca:
    dCor(x,y):Estymator korelacji odległości zmiennych x i y

    Przykład:
    x = rand(100)
    y = randn(100)

    dCor = dCor_M_final(x, y)
    """
    
    n = length(x)
    wektor_A = zeros(Float64, n)
    wektor_B = zeros(Float64, n)

    @inbounds for j in 2:n, i in 1:j-1
        a = abs(x[i] - x[j])
        b = abs(y[i] - y[j])
        wektor_A[i] += a
        wektor_A[j] += a
        wektor_B[i] += b
        wektor_B[j] += b
    end

    średnia_A = sum(wektor_A) / n^2
    średnia_B = sum(wektor_B) / n^2
    wektor_A ./= n
    wektor_B ./= n
    dcov_XY = 0.0
    dcov_XX = 0.0
    dcov_YY = 0.0

    @inbounds for j in 2:n, i in 1:j-1
        distA = abs(x[i] - x[j])
        distB = abs(y[i] - y[j]) 
        a = distA - wektor_A[i] - wektor_A[j] + średnia_A 
        b = distB - wektor_B[i] - wektor_B[j] + średnia_B
        dcov_XY += 2*a*b
        dcov_XX += 2*a^2
        dcov_YY += 2*b^2
    end
    @inbounds for k in 1:n
        a = średnia_A - 2*wektor_A[k]
        b = średnia_B - 2*wektor_B[k]
        dcov_XY += a*b
        dcov_XX += a^2
        dcov_YY += b^2
    end

    return dcov_XY / sqrt(dcov_XX * dcov_YY)
end

function tabela_K(bu,bn)
    T = zeros(Int, maximum(bu), maximum(bn))
    @inbounds for i in eachindex(bu, bn)
        T[bu[i], bn[i]] += 1
    end

    return T
end
function dCor_Zhang(x,y)
    nij = tabela_K(x,y)
    pij = nij ./ sum(nij) 
    pi = sum(pij,dims=2)
    pj = sum(pij,dims=1)
    pipj = (pi[i] * pj[j] for i in 1:length(pi), j in 1:length(pj))
    a = sum((e - o)^2 for (e,o) in zip(pij,pipj))
    b = sum(i -> i^2, pi) * (sum(i -> i^2, pi) + 1) - 2sum(i -> i^3, pi)
    c = sum(i -> i^2, pj) * (sum(i -> i^2, pj) + 1) - 2sum(i -> i^3, pj)
    return sqrt(a / sqrt(b*c))
end

function dCor_M_final!(x,y,wektor_A,średnia_A,wektor_B,n,dcov_XX)
    wektor_B .= 0.0
    @inbounds for j in 2:n
        @simd for i in 1:j-1
            b = abs(y[i] - y[j])
            wektor_B[i] += b
            wektor_B[j] += b
        end
    end

    średnia_B = sum(wektor_B) / n^2
    wektor_B ./= n
    dcov_XY = 0.0
    dcov_YY = 0.0

    @inbounds for j in 2:n
        @simd for i in 1:j-1
            distA = abs(x[i] - x[j])
            distB = abs(y[i] - y[j]) 
            a = distA - wektor_A[i] - wektor_A[j] + średnia_A 
            b = distB - wektor_B[i] - wektor_B[j] + średnia_B
            dcov_XY += 2*a*b
            dcov_YY += 2*b^2
        end
    end
    @inbounds for k in 1:n
        a = średnia_A - 2*wektor_A[k]
        b = średnia_B - 2*wektor_B[k]
        dcov_XY += a*b
        dcov_YY += b^2
    end

    return dcov_XY / sqrt(dcov_XX * dcov_YY)
end
function p_value_Székely(x,y,iter=1000)
    n = length(x)
    wektor_B = zeros(Float64, n)
    wektor_A = zeros(Float64, n)

    @inbounds for j in 2:n
        @simd for i in 1:j-1
            a = abs(x[i] - x[j])
            wektor_A[i] += a
            wektor_A[j] += a
        end
    end

    średnia_A = sum(wektor_A) / n^2
    wektor_A ./= n
    dcov_XX = 0.0
    
    @inbounds for j in 2:n
        @simd for i in 1:j-1 
            dcov_XX += 2*(abs(x[i] - x[j]) - wektor_A[i] - wektor_A[j] + średnia_A)^2
        end
    end
    @inbounds for k in 1:n
        dcov_XX += (średnia_A - 2*wektor_A[k])^2
    end

    stat = dCor_M_final!(x,y,wektor_A,średnia_A,wektor_B,n,dcov_XX)
    hits = 0
    kopia_y = copy(y)
    for _ in 1:iter
        hits += (dCor_M_final!(x,shuffle!(kopia_y),wektor_A,średnia_A,wektor_B,n,dcov_XX) > stat)
    end
    return hits / iter
end

function tabela_K!(T,bu,bn)
    T .= 0
    @inbounds for i in eachindex(bu, bn)
        T[bu[i], bn[i]] += 1
    end
    return T
end
function p_value_Zhang(x,y,iter=1000)
    T = zeros(Int64,maximum(x),maximum(y))
    nij = tabela_K!(T,x,y)
    n = sum(nij) 
    ni = sum(nij,dims=2)
    nj = sum(nij,dims=1)
    pipj = (ni[i] * nj[j] for i in 1:length(ni), j in 1:length(nj))
    stat = sum((e*n - o)^2 for (e,o) in zip(nij,pipj))
    hits = 0
    kopia_y = copy(y)
    for _ in 1:iter
        nij = tabela_K!(T,x,shuffle!(kopia_y))
        hits += sum((e*n - o)^2 for (e,o) in zip(nij,pipj))>stat
    end
    return hits / iter
end

end
