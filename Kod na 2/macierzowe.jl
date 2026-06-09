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

function dCor_M_final(x,y)
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
