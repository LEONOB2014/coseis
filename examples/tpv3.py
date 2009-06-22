#!/usr/bin/env python
"""
TPV3 - SCEC validation problem version 3
"""
import sord

rundir = '~/run/tpv3'			# simulation directory 
np3 = 1, 1, 32				# number of processors in each dimension
nn = 351, 201, 128			# number of mesh nodes, nx ny nz
dx = 50.0, 50.0, 50.0			# spatial step size
nt = 3001				# number of time steps
dt = 0.004				# time step size

# Near side boundary conditions:
# PML absorbing boundaries for the x, y and z boundaries
bc1 = 10, 10, 10

# Far side boundary conditions:
# Anti-mirror symmetry for the x and z boundaries
# Mirror symmetry for the y boundary
bc2 = -2, 2, -2

# Material properties
fieldio = [
    ( '=',  'rho', [], 2670.0 ),	# density
    ( '=',  'vp',  [], 6000.0 ),	# P-wave speed
    ( '=',  'vs',  [], 3464.0 ),	# S-wave speed
    ( '=',  'gam', [], 0.2   ),		# viscosity
    ( '=c', 'gam', [], 0.02, (-15001., -7501., -4000.), (15001., 7501., 4000.) ),
]
hourglass = 1.0, 2.0

# Fault parameters
faultnormal = 3				# fault plane of constant z
ihypo = -1.5, -1.5, -1.5		# hypocenter indices
fixhypo = -1				# set origin at hypocenter
vrup = -1.0				# disable circular nucleation
fieldio += [
    ( '=',  'dc',  [], 0.4    ),	# slip weakening distance
    ( '=',  'mud', [], 0.525  ),	# coefficient of dynamic friction
    ( '=',  'mus', [], 1e4    ),	# coefficient of static friction
    ( '=c', 'mus', [], 0.677, (-15001., -7501., -1.), (15001., 7501., 1.) ),
    ( '=',  'tn',  [], -120e6 ),	# normal traction
    ( '=',  'ts',  [],   70e6 ),	# shear traction
    ( '=c', 'ts',  [], 81.6e6, (-1501., -1501., -1.), (1501., 1501., 1.) ),
]

# Write fault plane output
fieldio += [
    ( '=w', 'x1',   [(),(),-2,()], 'x1'   ),	# mesh coordinate X
    ( '=w', 'x2',   [(),(),-2,()], 'x2'   ),	# mesh coordinate Y
    ( '=w', 'su1',  [(),(),-2,-1], 'su1'  ),	# final horizontal slip
    ( '=w', 'su2',  [(),(),-2,-1], 'su2'  ),	# final vertical slip
    ( '=w', 'psv',  [(),(),-2,-1], 'psv'  ),	# peak slip velocity
    ( '=w', 'trup', [(),(),-2,-1], 'trup' ),	# rupture time
]

# Write slip, slip velocity, and shear traction time history
for f in 'su1', 'su2', 'sv1', 'sv2', 'ts1', 'ts2':
    fieldio += [
        ( '=wx', f, [], 'P1_' + f, (-7499., -1., 0.) ), # mode II point
        ( '=wx', f, [], 'P2_' + f, (-1., -5999., 0.) ), # mode III point
    ]

sord.run( locals() )

