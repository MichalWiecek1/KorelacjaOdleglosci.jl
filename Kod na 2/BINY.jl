function BIN_U(x)
    Bins = Vector{UInt8}(undef, length(x)) 
    @inbounds @simd for i in eachindex(x) 
        Bins[i] = trunc(UInt8, 5*x[i]) + 1 
    end 
    return Bins
end

function BIN_N(x)
    Bins = zeros(UInt8, 6)

    @inbounds for i in eachindex(x)
        xi = x[i]

        if xi < 0
            if xi < -1
                if xi < -2
                    Bins[xi] = 1
                else
                    Bins[xi] = 2
                end
            else
                Bins[xi] = 3
            end
        else
            if xi < 1
                Bins[xi] = 4
            elseif xi < 2
                Bins[xi] = 5
            else
                Bins[xi] = 6
            end
        end
    end

    return Bins
end