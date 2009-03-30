#!/usr/bin/env python
"""
Explosion test problem
"""

import sord

np3 = 1, 2, 1
nn = 71, 71, 61
dx = 100.0, 100.0, 100.0
dt = 0.008
nt = 200
nt = 10
fieldio = [
    ( '=', 'rho', [], 2670.0 ),
    ( '=', 'vp',  [], 6000.0 ),
    ( '=', 'vs',  [], 3464.0 ),
    ( '=', 'gam', [],    0.0 ),
]
rexpand = 1.06
n1expand =  0,  0,  0
n2expand = 20, 20, 20
source = 'moment'
tensor1 = 1e18, 1e18, 1e18
tensor2 =  0.0,  0.0,  0.0
tfunc = 'brune'
tsource = 0.1
bc2 = 0, 0, 0
fixhypo = -1 

for _f in 'x1', 'x2', 'x3', 'v1', 'v2', 'v3':
    fieldio += [
        ( '=wx', _f, [], 'p1_'+_f, (   0., 3999., -1.) ),
        ( '=wx', _f, [], 'p2_'+_f, (2999., 3999., -1.) ),
        ( '=wx', _f, [], 'p3_'+_f, (3999., 3999., -1.) ),
    ]

if 1:
    ihypo = 1.5, 1.5, 1.5
    bc1   = 2, 2, 2
else:
    ihypo = 1, 1, 1
    bc1   = 1, 1, 1

sord.run( locals() )

