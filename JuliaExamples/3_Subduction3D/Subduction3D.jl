#=
# 3D Subduction example

This is a 3D subduction example for `LaMEM.jl` that illustrates how to use the julia interface.
This is very similar to the setup described by Schellart and coworkers in a [2007 nature paper](https://www.nature.com/articles/nature05615) in which they demonstrate that toroidal flow changes the slab curvature during subduction as a function of slab width.  
=#

# 1. Generate main model setup
# We first load the packages:
using LaMEM, GeophysicalModelGenerator

# Next, we generate the main model setup, specifying the resolution and grid dimensions.
# Note that a range of default values will be set, depending on the parameters you specify.
model = Model(  
                ## Define the grid
                Grid(   #nel=(128,32,64),       # higher resolution
                        nel=(64,32,64),         # medium resolution
                        x=[-3960, 500], y=[0,2640], z=[-660 ,0]), 
                
                ## No slip lower boundary; the rest is free slip
                BoundaryConditions(noslip = [0, 0, 0, 0, 1, 0]), 
                
                ## We use a multigrid solver with 4 levels:
                Solver(SolverType="multigrid", MGLevels=3, MGCoarseSolver="mumps",  
                        PETSc_options=[ "-snes_type ksponly", 
                                        "-js_ksp_rtol 1e-3", 
                                        "-js_ksp_atol 1e-4", 
                                        "-js_ksp_monitor"]),

                ## Output filename
                Output(out_file_name="Subduction_3D", out_dir="Subduction_3D"),        

                ## Timestepping etc
                Time(   nstep_max=200, nstep_rdb=1000,
                        nstep_out=5, time_end=100, dt_min=1e-5),           

                ## Scaling:
                Scaling(GEO_units(length=1km, stress=1e9Pa) )       
            ) 


# 2. Define geometry
# We start with the horizontal part of the slab. The function `add_box!` allows you to specify a layered lithosphere; here we have a crust and mantle. It also allows specifying a thermal structure. 
# Since the current setup is only mechanical, we don't specify that here. 
add_box!(model, xlim=(-3000,-1000), ylim=(0,1000), zlim=(-80,0), phase=LithosphericPhases(Layers=[20,60], Phases=[1,2]))

# The inclined part of the slab is generate by giving it a dip:
add_box!(model, xlim=(-1000,-810), ylim=(0,1000), zlim=(-80,0), phase=LithosphericPhases(Layers=[20,60], Phases=[1,2]), DipAngle=16)

# 3. Add material properties:
# We can specify material properties by using the `Phase` function
mantle = Phase(Name="mantle",ID=0,eta=1e21,rho=3200)
crust  = Phase(Name="crust", ID=1,eta=1e21,rho=3280)
slab   = Phase(Name="slab",  ID=2,eta=2e23,rho=3280)

# and we can add them to the model with:
add_phase!(model, mantle, slab, crust)

# 4. Run the simulation 
run_lamem(model, 4)       # run on 8 cores (if possible)            