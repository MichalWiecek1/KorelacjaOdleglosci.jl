function dCor_M_final_pre_calc!(x,y,wektor_A,średnia_A,wektor_B,n,dcov_XX)
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

function p_value_pre_calc(x,y,iter=1000)
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

    stat = dCor_M_final_pre_calc!(x,y,wektor_A,średnia_A,wektor_B,n,dcov_XX)
    hits = 0
    kopia_y = copy(y)
    for _ in 1:iter
        hits += (dCor_M_final_pre_calc!(x,shuffle!(kopia_y),wektor_A,średnia_A,wektor_B,n,dcov_XX) > stat)
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
    pipj = ((ni[i] * nj[j])/n for i in 1:length(ni), j in 1:length(nj))
    stat = sum((e - o)^2 for (e,o) in zip(nij,pipj))
    hits = 0
    kopia_y = copy(y)
    for _ in 1:iter
        nij = tabela_K!(T,x,shuffle!(kopia_y))
        hits += sum((e - o)^2 for (e,o) in zip(nij,pipj))>stat
    end
    return hits / iter
end
