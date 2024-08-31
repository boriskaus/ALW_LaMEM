# Plume-lithosphere interaction
#
# In this example we show how to use more realistic rheologies, as well as a precomputed phase diagram
# By Nicolas Riel & Boris Kaus

# load needed packages, GeophysicalModelGenerator is used to create shapes for the starting modelling conditions, GMT is used to import toppography, Plots is used to plot model before running the simulation
using LaMEM, GeophysicalModelGenerator, Plots

# Below we create a structure to define the modelling setup
model = Model(  
                # This is where you setup the size of your model (as km as set above) and the resolution. e.g., x = [minX, maxX] (...)
                Grid(               x               = [-500.0,500.0],
                                    z               = [-660.0,50.0],            # Here we change the maximum value of Z in order to account for "air"   
                                    nel             = (96,96) ),                # notice that only one element is given in the y-direction to effectively have a 2D simulation

                # sets the conditions at the walls of the modelled domain
                BoundaryConditions( temp_top        = 20.0,
                                    temp_bot        = 1590.0, 
                                    open_top_bound  = 1),                        # activate the internal freesurface
                                
                # set timestepping parameters
                Time(               time_end        = 20.0,                     # Time is always expressed in Myrs (input/output definition)
                                    dt              = 0.001,                    # Target timestep, here 10k years
                                    dt_min          = 0.000001,                 # Minimum dt allowed, this is useful for more complex simulations
                                    dt_max          = 0.1,                      # max dt, here 100k years
                                    nstep_max       = 200,                      # Number of wanted timesteps
                                    nstep_out       = 1 ),                      # save output every nstep_out

                PassiveTracers(     Passive_Tracer    = 1,
                                    PassiveTracer_Box = [-60,60,-1,1,-660,-540],
                                    PassiveTracer_Resolution = [64, 1, 64]),  
   
                # set solution parameters
                SolutionParams(     eta_min         = 1e19,
                                    eta_ref         = 1e20,
                                    eta_max         = 1e23, 
                                    act_temp_diff   = 1,                        # activate Temperature diffusion
                                    shear_heat_eff  = 1.0,                      # shear heating 
                                    Adiabatic_Heat  = 1.0,                      # adiabatic heating 
                                    FSSA            = 1.0 ),                    # activate Free Surface Stabilization Algorithm  

                FreeSurface(	    surf_use        = 1,                        # free surface activation flag 
                                    surf_corr_phase = 1,                        # air phase ratio correction flag (due to surface position) 
                                    surf_level      = 0.0,                      # initial level 
                                    surf_air_phase  = 0,                        # phase ID of sticky air layer 
                                    surf_max_angle  = 40.0                      # maximum angle with horizon (smoothed if larger)) 
                                ),         
                # what will be saved in the output of the simulation
                Output(             out_dir         =   "PlumeLithos",
                                    out_file_name   =   "PlumeLithos"),

                # here we define the options for the solver, it is advised to no fiddle with this (only comment "-da_refine_y 1" for 3D simulations)
                Solver(             SolverType          = "direct",
                                    DirectSolver  	    = "mumps",
                                    PETSc_options       = [ "-snes_rtol 1e-2"] )  
            )  

#=================== define phases (different materials) of the model ==========================#

Tair                    = 20.0;
Tmantle                 = 1280.0;
model.Grid.Temp        .= Tmantle;              # set mantle temperature (without adiabat at first)

# add single plate using add_box!

# Add lithosphere and mantle, including mantle adiabat
add_box!(model; xlim    = model.Grid.coord_x, 
                zlim    = (-660.0, 0.0),

                phase   = LithosphericPhases(       Layers=[30 90], 
                                                    Phases=[1 2 3] ),
                T       = HalfspaceCoolingTemp(     Tsurface    = Tair,
                                                    Tmantle     = Tmantle,
                                                    Age         = 100,
                                                    Adiabat     = 0.5      ))
# give mantle particles a different phase
model.Grid.Phases[model.Grid.Temp .> Tmantle ]  .= 3;

# set air to phase==9, and T==20 Celcius
model.Grid.Phases[Z.>0.0]                       .= 0;                        # if Z > 0 then we attribute the air phase value 0
model.Grid.Temp[Z.>0.0]                         .= 20.0;   

# here we define a plume by increasing the temperature of the mantle within a circle
center                  = [0.0,-600]
radius                  = 100.0
in_sphere               = findall( (X .- center[1]).^2 .+ (Z .- center[2]).^2 .<= radius^2 )
model.Grid.Temp[in_sphere]      .+= 100.0
model.Grid.Phases[in_sphere]    .= 4

#====================== define material properties of the phases ============================#
air = Phase(            Name            = "Air",
                        ID              = 0,
                        k               = 100,                      # large conductivity to keep low temperature air
                        Cp              = 1e6,                      # heat capacity   
                        rho             = 50,                       # prescribe a relatively low density for the air. Mind that realistic density for the air may lead to numerical instability
                        eta             = 1e20,                     # here we set the viscosity on the air as the minimum viscosity in our simulation, so the one of the mantle
                        G               = 5e10 )

crust = Phase(          Name            = "crust",                 # let's call phase 1 mantle
                        ID              = 1,                        # not that ID here points to phase 0 which is the background phase defined above
                        alpha           = 3e-5,
                        k               = 3,                        # conductivity 
                        Cp              = 1000,                     # heat capacity 
                        rho             = 3200,                     # set mantle density
                        disl_prof       = "Quarzite-Ranalli_1995",
                        G               = 5e10 );
              
mantle = Phase(         Name            = "Mantle",                 # let's call phase 0 mantle
                        ID              = 2,                        # not that ID here points to phase 0 which is the background phase defined above
                        alpha           = 3e-5,
                        k               = 3,                        # conductivity 
                        Cp              = 1000,                     # heat capacity 
                        rho             = 3300,                     # set mantle density
                        G               = 5e10,
                        disl_prof       = "Dry_Olivine_disl_creep-Hirth_Kohlstedt_2003",
                        diff_prof       = "Dry_Olivine_diff_creep-Hirth_Kohlstedt_2003" );

asthenosphere = copy_phase(     mantle,
                                Name    = "asthenosphere",
                                ID      = 3 );

plume = copy_phase(             mantle,
                                Name    = "plume",
                                rho     = 3280.0,
                                ID      = 4 );


add_phase!( model, air, crust, mantle, asthenosphere, plume )                          # this adds the phases to the model structure, oon't forget to add the air
#=============================== perform simulation ===========================================#

run_lamem(model, 1)

