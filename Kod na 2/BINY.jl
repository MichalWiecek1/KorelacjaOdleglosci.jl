function bin_U(x)
    Bins = Vector{UInt8}(undef, length(x)) 
    @inbounds @simd for i in eachindex(x) 
        Bins[i] = trunc(UInt8, 5*x[i]) + 1 
    end 
    return Bins
end

function bin_N(x)
    Bins = zeros(UInt8, length(x))

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

function tabela_K(bu::Vector{UInt8}, bn::Vector{UInt8})
    T = zeros(Int, 5, 6)

    @inbounds @simd for i in eachindex(bu, bn)
        T[bu[i], bn[i]] += 1
    end

    return T
end
