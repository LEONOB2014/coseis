#!/usr/bin/env python
"""
SCEC Code Validation Workshop, Test Problem 12
FIXME: prestress not correct
"""
import numpy as np
import cst

# number of processes
nproc3 = 1, 1, 2

# model dimensions
delta = 100.0, 100.0, 100.0, 100.0 / 12500.0
shape = (
    int(16500.0 / delta[0] +  21.5),
    int(16500.0 / delta[1] +  21.5),
    int(12000.0 / delta[2] + 120.5),
    int(    8.0 / delta[3] +   1.5),
)

# boundary conditions
bc1 = -1,  0, 0
bc2 = 10, 10, 0

# mesh
alpha_ = np.sin(np.pi / 3.0)
affine = (1.0, 0.0, 0.0), (0.0, alpha_, 0.0), (0.0, 0.5, 1.0)
n1expand = 0, 0, 50
n2expand = 0, 0, 50

# hypocenter
j = 1
k = 12000.0 / delta[1] + 1
l = shape[2] // 2 + 1
ihypo = j, k, l

# near-fault volume
j = 1.5, 15000.0 / delta[0] + 0.5
k = 1.5, 15000.0 / delta[1] + 0.5
l = 3000.0 / delta[2] + 0.5
l = ihypo[2] - l, ihypo[2] + l

# material properties
fieldio = [
    ('=', 'rho', [], 2700.0),
    ('=', 'vp',  [], 5716.0),
    ('=', 'vs',  [], 3300.0),
    ('=', 'gam', [], 0.2),
    ('=', 'gam', [j,k,l,0], 0.02),
]
hourglass = 1.0, 2.0

# fault parameters
faultnormal = 3
j = 1, 15000.0 / delta[0]
k = 1, 15000.0 / delta[1]
l = ihypo[2]
fieldio += [
    ('=',  'co',   [], 2e5),
    ('=',  'dc',   [], 0.5),
    ('=',  'mud',  [], 0.1),
    ('=',  'mus',  [], 1e4),
    ('=',  'mus',  [j,k,l,()], 0.7),
    ('=R', 's11',  [1,(),l,0], 's11.bin'),
    ('=R', 's22',  [1,(),l,0], 's22.bin'),
    ('=R', 's33',  [1,(),l,0], 's33.bin'),
    ('=w', 'trup', [j,k,l,()], 'trup.bin'),
]

# nucleation
i = 1500.0 / delta[0]
j, k, l = ihypo
fieldio += [
    ('=', 'mus',  [(1, j+i+1), (k-i-1, k+i+1), l, ()], 0.66),
    ('=', 'mus',  [(1, j+i),   (k-i-1, k+i+1), l, ()], 0.62),
    ('=', 'mus',  [(1, j+i+1), (k-i,   k+i),   l, ()], 0.62),
    ('=', 'mus',  [(1, j+i),   (k-i,   k+i),   l, ()], 0.54),
]

# slip, slip velocity, and shear traction time histories
l = ihypo[2]
for x, y in [
    (0, 0),
    (45, 0),
    (120, 0),
    (0, 15),
    (0, 30),
    (0, 45),
    (0, 75),
    (45, 75),
    (120, 75),
    (0, 120),
]:
    j = x * 100.0 / delta[0] + 1
    k = y * 100.0 / delta[1] + 1
    for f in 'su1', 'su2', 'su3', 'sv1', 'sv2', 'sv3', 'ts1', 'ts2', 'ts3', 'tnm':
        p = 'faultst%03ddp%03d-%s.bin' % (x, y, f)
        p = p.replace('fault-', 'fault-0')
        fieldio += [('=w', f, [j,k,l,()], p)]

# displacement and velocity time histories
for x, y, z in [
    (0, 0, -30),
    (0, 0, -20),
    (0, 0, -10),
    (0, 0, 10),
    (0, 0, 20),
    (0, 0, 30),
    (0, 3, -10),
    (0, 3, -5),
    (0, 3, 5),
    (0, 3, 10),
    (120, 0, -30),
    (120, 0, 30),
]:
    j = x * 100.0 / delta[0] + 1
    k = y * 100.0 / delta[1] / alpha_ + 1
    l = z * 100.0 / delta[2] + ihypo[2]
    for f in 'u1', 'u2', 'u3', 'v1', 'v2', 'v3':
        p = 'body%03dst%03ddp%03d-%s.bin' % (z, x, y, f)
        p = p.replace('body-', 'body-0')
        fieldio += [('=w', f, [j,k,l,()], p)]

# stage job
job = cst.sord.stage(locals())
dir = job.rundir

# pre-stress
d = np.arange(shape[1]) * alpha_ * delta[1]
x = d * 9.8 * -1147.16
y = d * 9.8 * -1700.0
z = d * 9.8 * -594.32
k = int(13800.0 / delta[1] + 1.5)
x[k:] = y[k:]
z[k:] = y[k:]
x.astype('f').tofile(dir + '/s11.bin')
y.astype('f').tofile(dir + '/s22.bin')
z.astype('f').tofile(dir + '/s33.bin')

# launch job
cst.sord.launch(job)
