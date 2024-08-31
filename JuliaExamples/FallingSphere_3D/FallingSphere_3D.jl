# First example of how to use LaMEM

# Load packages: 
using LaMEM, GeophysicalModelGenerator, Plots

model  = Model(
                # Define grid:
                Grid(nel=(16,16,16), x=[-1,1], y=[-1,1], z=[-1,1]), 

                # Set timesteps
                Time(nstep_max=20, dt_min=1e-3, dt=1, dt_max=10, time_end=100), 

                # USe a multigrid solver with 2 levels:
                Solver(SolverType="multigrid", MGLevels=2),

                # Output directory:
                Output(out_dir="example_1")
                )

# Specify material properties for matrix and sphere:
matrix = Phase(ID=0,Name="matrix",eta=1e20,rho=3000)
sphere = Phase(ID=1,Name="sphere",eta=1e23,rho=3200)

# Add them to the model setup:
add_phase!(model, sphere, matrix)

# Specify the initial model geometry
add_sphere!(model,cen=(0.0,0.0,0.0), radius=(0.5, ))  # this is a function from the GeophysicalModelGenerator package

# Run the simulation on 1 processor:
run_lamem(model,1)
