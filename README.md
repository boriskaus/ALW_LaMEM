# LaMEM tutorial as part of the 2024 ALW

This repository contains material and scripts for the mini tutorial on LaMEM as part of the 2024 Ada Lovelace workshop on Modelling Mantle and Lithosphere Dynamics.

### Required software
Participants will have to install the following software:
- [VSCode](https://code.visualstudio.com/download) This is the most widely used coding environment worldwide and provides support for julia. Also add the julia extension (click on the left side to add extensions).
- [Julia](https://julialang.org) We will use julia to create model setups and run LaMEM. The easiest way to install julia these days is through [juliaup](https://github.com/JuliaLang/juliaup). Once you did that, you can install the `LaMEM`, `GeophysicalModelGenerator` and `Plots` packages. We currently use julia 1.10
- [Paraview](https://www.paraview.org) - This is a very powerful visualisation tool. Any version will do.


### Topics
We will use the julia interface to LaMEM - called [LaMEM.jl](https://github.com/JuliaGeodynamics/LaMEM.jl) in this workshop as it is by far the easiest way to setup LaMEM models. 

#### 1. Julia intro
[Installing software and intro to julia](Julia_intro/IntroJulia.md) - In case you need some more help on julia you can work through these exercises. Note that we will not discuss this in detail during the tutorial (for time reasons).

#### 2. Falling sphere example
[Falling Sphere](JuliaExamples/1_FallingSphere_3D/FallingSphere_3D.jl) - our first example is a 3D model of a dense sphere sinking through a less dense matrix. This involves a linear viscous material and multigrid solvers and gives you a first idea on how to setup and run simulations.


   
