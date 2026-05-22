module KorelacjaOdleglosci
export dCor8

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

end
