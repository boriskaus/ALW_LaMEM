# LaMEM tutorial as part of the 2024 ALW

This repository contains material and scripts for the mini tutorial on LaMEM as part of the 2024 Ada Lovelace workshop on Modelling Mantle and Lithosphere Dynamics.

### a. Required software
Participants will have to install the following software:
- [VSCode](https://code.visualstudio.com/download) This is the most widely used coding environment worldwide and provides support for julia. Also add the julia extension (click on the left side to add extensions).
- [Julia](https://julialang.org) We will use julia to create model setups and run LaMEM. The easiest way to install julia these days is through [juliaup](https://github.com/JuliaLang/juliaup). Once you did that, you can install the `LaMEM`, `GeophysicalModelGenerator` and `Plots` packages. We currently use julia 1.10
- [Paraview](https://www.paraview.org) - This is a very powerful visualisation tool. Any version will do.


### b. Topics
We will use the julia interface to LaMEM - called [LaMEM.jl](https://github.com/JuliaGeodynamics/LaMEM.jl) in this workshop as it is by far the easiest way to setup LaMEM models. 

#### 1. Julia intro
[Installing software and intro to julia](https://github.com/boriskaus/CHEESE2_GeodynamicsWorkshop/blob/main/Julia_intro/IntroJulia.md) - In case you need some more help on julia you can work through these exercises. Note that we will not discuss this in detail during the tutorial (for time reasons).

#### 2. Falling sphere example
[Falling Sphere](JuliaExamples/1_FallingSphere_3D/FallingSphere_3D.jl) - our first example is a 3D model of a dense sphere sinking through a less dense matrix. This involves a linear viscous material and multigrid solvers and gives you a first idea on how to setup and run simulations.

#### 3. Plume lithosphere interaction
[Plume Lithosphere example](JuliaExamples/2_PlumeLithosphere/PlumeLithosphere_2D.jl) - in the next 2D example we show how you can setup a model with temperature-dependent nonlinear viscosities, a free surface,  viscoelastic rheologies, shear and adiabatic heating along with passive tracers. 

#### 4. 3D subduction
[3D Subduction](JuliaExamples/3_Subduction3D/Subduction3D.jl) - in the next example we reproduce results of a paper by [Schellart and coworkers](https://www.nature.com/articles/nature05615) that looked at the effect of a slab width on the trench curvature.   

#### 5. Fold and thrust belt
[Fold  and Thrust](JuliaExamples/4_FoldThrust/fold_and_thrust.jl) - fold and thrust belts are a nice example of how brittle layers may slide overa  detachment horizon and cause both folding and faulting. In this example, we reproduce this using visco-elasto-viscoplastic rheologies and an (internal) free surface

### c. Additional help
You can find additional material by looking at the
- [documentation of LaMEM.jl](https://juliageodynamics.github.io/LaMEM.jl/dev/)
- [tests of LaMEM.jl](https://github.com/JuliaGeodynamics/LaMEM.jl/tree/main/test) - these tests are run every time a new commit is made to the LaMEM repository so are up to date.
- [main input file of LaMEM](https://github.com/UniMainzGeo/LaMEM/blob/master/input_models/input/lamem_input.dat) which lists all available options. We try to keep `LaMEM.jl` up to date with this.
- [CHEES2 workshop material](https://github.com/boriskaus/CHEESE2_GeodynamicsWorkshop/tree/main) this wqs a workshop held in spring 2024 and contains some usful material
- [Heidelberg LaMEM course](https://github.com/NicolasRiel/Heidelberg_LaMEM_course) - a shortcourse at the university of Heidelberg held by Nicolas Riel (for BSc students). Note that we have sligthly updated the names of some functions in GeophysicalModelGenerator since that time so you may have to make a few modifications to the scripts

Finally, if you find mistakes or errors, please don't be shy to leave in [issue](https://github.com/JuliaGeodynamics/LaMEM.jl/issues), or perhaps even fix it yourself and make a pull request. The code will only get better with everyone's help!
