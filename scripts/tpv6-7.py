#!/usr/bin/env python
"""
TPV6 - SCEC validation problem versions 6 & 7
"""
import sord

version_ = 6
np3 = 1, 1, 32
dx = 50.0, 50.0, 50.0
dt = dx[0] / 12500.
nn = (
    int( 33000.0 / dx[0] + 41.001 ),
    int( 18000.0 / dx[1] + 41.001 ),
    int( 12000.0 / dx[2] + 40.001 ),
)
nt = int( 12.0 / dt + 1.5 )
bc1 = 10,  0, 10
bc2 = 10, 10, 10
hourglass = 1.0, 2.0

faultnormal = 3	
vrup = -1.

if version- == 6:
    rho_ = 2670.0, 2225.0
    vp_  = 6000.0, 3750.0
    vs_  = 3464.0, 2165.0
else:
    rho_ = 2670.0, 2670.0
    vp_  = 6000.0, 5000.0
    vs_  = 3464.0, 2887.0

FIXME
ihypo = 0, 0, 
l = nn[2] / 2
j = nn[0] / 2
k      = int(  7500.0 / dx[1] + 1.001 )
_1500  = int(  1500.0 / dx[0] + 0.001 )
_4500  = int(  4500.0 / dx[0] + 0.001 )
_15000 = int( 15000.0 / dx[0] + 0.001 )
j0_ = j - _15000,     j + _15000
j1_ = j - _1500,      j + _1500
j2_ = j - _1500 + 1,  j + _1500 - 1
k0_ = 1,              1 + _15000
k1_ = k - _1500,      k + _1500
k2_ = k - _1500 + 1,  k + _1500 - 1
l0_ = l - _4500,      l + _4500
l1_ = 1,              l
l2_ = l + 1,         -1
fieldio = [
    ( '=',  'rho',  [], 0.5 * ( rho_[0] + rho_[1] ) ),
    ( '=',  'vp',   [], 0.5 * ( vp_[0]  + vp_[1]  ) ),
    ( '=',  'vs',   [], 0.5 * ( vs_[0]  + vs_[1]  ) ),
    ( '=',  'rho',  [ (), (), l1_, () ], rho_[0] ),
    ( '=',  'vp',   [ (), (), l1_, () ], vp_[0]  ),
    ( '=',  'vs',   [ (), (), l1_, () ], vs_[0]  ),
    ( '=',  'rho',  [ (), (), l2_, () ], rho_[1] ),
    ( '=',  'vp',   [ (), (), l2_, () ], vp_[1]  ),
    ( '=',  'vs',   [ (), (), l2_, () ], vs_[1]  ),
    ( '=',  'gam',  [],                    0.2   ),
    ( '=',  'gam',  [ j0_, k0_, l0_, () ], 0.02  ),
    ( '=',  'dc',   [],                    0.4   ),
    ( '=',  'mud',  [],                    0.525 ),
    ( '=',  'mus',  [],                    1e4   ),
    ( '=',  'mus',  [ j0_, k0_, (), () ],  0.677 ),
    ( '=',  'tn',   [],                   -120e6 ),
    ( '=',  'ts',   [],                     70e6 ),
    ( '=',  'ts',   [ j1_, k1_, (), () ], 72.9e6 ),
    ( '=',  'ts',   [ j1_, k2_, (), () ], 75.8e6 ),
    ( '=',  'ts',   [ j2_, k1_, (), () ], 75.8e6 ),
    ( '=',  'ts',   [ j2_, k2_, (), () ], 81.6e6 ),
    ( '=w', 'trup', [ j0_, k0_, (), -1 ], 'trup' ),
]

_12000 = int( 12000.0 / dx[0] + 0.5 )
j1_, j2_ = j - _12000,  j + _12000
l1_, l2_ = l,  l + 1
for f in 'u1', 'u2', 'u3', 'v1', 'v2', 'v3', 'ts1', 'ts2', 'tnm':
    fieldio += [
        ( '=w', f, [j,   1, l1_, ()], 'nearst000dp000'  + f ),
        ( '=w', f, [j1_, 1, l1_, ()], 'nearst-120dp000' + f ),
        ( '=w', f, [j1_, k, l1_, ()], 'nearst-120dp075' + f ),
        ( '=w', f, [j2_, 1, l1_, ()], 'nearst120dp000'  + f ),
        ( '=w', f, [j2_, k, l1_, ()], 'nearst120dp075'  + f ),
        ( '=w', f, [j,   1, l2_, ()], 'farst000dp000'   + f ),
        ( '=w', f, [j1_, 1, l2_, ()], 'farst-120dp000'  + f ),
        ( '=w', f, [j1_, k, l2_, ()], 'farst-120dp075'  + f ),
        ( '=w', f, [j2_, 1, l2_, ()], 'farst120dp000'   + f ),
        ( '=w', f, [j2_, k, l2_, ()], 'farst120dp075'   + f ),
    ]

rundir = '~/run/tpv%s' % version_
sord.run( locals() )

