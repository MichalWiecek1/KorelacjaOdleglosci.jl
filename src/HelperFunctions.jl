function bin_U(x)
    #Dyzkretyzacja rozkładu jednostajnego(0,1) na 5 grup
    Bins = Vector{Int8}(undef, length(x)) 
    @inbounds @simd for i in eachindex(x) 
        Bins[i] = trunc(Int8, 5*x[i]) + 1 
    end 
    return Bins
end

function bin_N(x)
    #Dyzkretyzacja rozkładu normalnego(0,1) na 6 grup
    Bins = Vector{Int8}(undef, length(x)) 

    @inbounds for i in eachindex(x)
        xi = x[i]

        if xi < 0
            if xi < -1
                if xi < -2
                    Bins[i] = 1
                else
                    Bins[i] = 2
                end
            else
                Bins[i] = 3
            end
        else
            if xi < 1
                Bins[i] = 4
            elseif xi < 2
                Bins[i] = 5
            else
                Bins[i] = 6
            end
        end
    end

    return Bins
end

function p_value(x,y,method,iter=1000)
    stat = method(x,y)
    hits = 0
    kopia_y = copy(y)
    for _ in 1:iter
        hits += (method(x,shuffle!(kopia_y)) > stat)
    end
    return hits / iter
end

function dCov_M_slow(x,y)
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

function dCor_M_slow(x,y)
    return dCov_M_slow(x,y) / sqrt(dCov_M_slow(x,x) * dCov_M_slow(y,y))
end

function dCor_M_fast(x,y)
    n = length(x)
    A = zeros(Float64,n,n)
    B = zeros(Float64,n,n)
    for i in 1:n, j in 1:n
        A[i,j] = abs(x[i] - x[j])
        B[i,j] = abs(y[i] - y[j])
    end
    A .= A .- mean(A,dims=1) .- mean(A,dims=2) .+ mean(A)
    B .= B .- mean(B,dims=1) .- mean(B,dims=2) .+ mean(B)
return mean(A .* B) / sqrt(mean(A .* A) * mean(B .* B))
end

function dCor_M_half(x,y)
    n = length(x)
    A = zeros(Int8, n, n)
    B = zeros(Int8, n, n)
    wektor_A = zeros(Float64, n)
    wektor_B = zeros(Float64, n)

    @inbounds for j in 2:n, i in 1:j-1
        a = abs(x[i] - x[j])
        b = abs(y[i] - y[j])
        A[i,j] = a
        B[i,j] = b
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
        a = A[i,j] - wektor_A[i] - wektor_A[j] + średnia_A
        b = B[i,j] - wektor_B[i] - wektor_B[j] + średnia_B 
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
