"""
Axisymmetric tokamak equilibrium in (R,Z,ϕ) coordinates.

Parameters:
    R₀: position of magnetic axis
    B₀: B-field at magnetic axis
    q₀: safety factor at magnetic axis
"""
struct AxisymmetricTokamakCylindrical{T <: Number} <: AnalyticEquilibrium
    name::String
    R₀::T
    B₀::T
    q₀::T

    function AxisymmetricTokamakCylindrical{T}(R₀::T, B₀::T, q₀::T) where T <: Number
        new("AxisymmetricTokamakCylindricalEquilibrium", R₀, B₀, q₀)
    end
end

AxisymmetricTokamakCylindrical(R₀::T=1.0, B₀::T=1.0, q₀::T=2.0) where T <: Number = AxisymmetricTokamakCylindrical{T}(R₀, B₀, q₀)


function Base.show(io::IO, equ::AxisymmetricTokamakCylindrical)
    print(io, "Axisymmetric Tokamak Equilibrium in (R,Z,ϕ) Coordinates with\n")
    print(io, "  R₀ = ", equ.R₀, "\n")
    print(io, "  B₀ = ", equ.B₀, "\n")
    print(io, "  q₀ = ", equ.q₀)
end


function X(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    R(x,equ) * cos(ϕ(x,equ))
end

function Y(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    R(x,equ) * sin(ϕ(x,equ))
end

function Z(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    x[2]
end

function R(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    x[1]
end

function r(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    sqrt(r²(x, equ))
end

function r²(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    (R(x,equ) - equ.R₀)^2 + Z(x,equ)^2
end

function θ(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    atan2(Z(x,equ), R(x,equ) - equ.R₀)
end

function ϕ(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    x[3]
end


function J(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    R(x,equ)
end


function periodicity(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    p = zero(x)
    p[3] = 2π
    return p
end


function A₁(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    + equ.B₀ * equ.R₀ * Z(x,equ) / R(x,equ) / 2
end

function A₂(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    - equ.B₀ * equ.R₀ * log(R(x,equ) / equ.R₀) / 2
end

function A₃(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    - equ.B₀ * r²(x,equ) / equ.q₀ / 2
end


function g₁₁(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    one(T)
end

function g₂₂(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    one(T)
end

function g₃₃(x::AbstractArray{T,1}, equ::AxisymmetricTokamakCylindrical) where {T <: Number}
    R(x, equ)^2
end


macro axisymmetric_tokamak_equilibrium_cylindrical(R₀, B₀, q₀)
    generate_equilibrium_code(AxisymmetricTokamakCylindrical(R₀, B₀, q₀); output=false)
end