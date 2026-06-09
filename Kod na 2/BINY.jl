function bin_U(x)
    Bins = Vector{Int8}(undef, length(x)) 
    @inbounds @simd for i in eachindex(x) 
        Bins[i] = trunc(Int8, 5*x[i]) + 1 
    end 
    return Bins
end

function bin_N(x)
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

function tabela_K(bu::Vector{Int8}, bn::Vector{Int8},x,y)
    T = zeros(Int, x, y)

    @inbounds for i in eachindex(bu, bn)
        T[bu[i], bn[i]] += 1
    end

    return T
end
