#!/usr/bin/env python
import os
import numpy as np
import matplotlib.pyplot as plt
import cst.bin2npy

# simulation directory
d = cst.repo + 'SORD-Example'
os.chdir(d)
cst.bin2npy()

# read slices
vx = np.load('vx.npy')
vy = np.load('vy.npy')
vm = np.sqrt(vx * vx + vy * vy)

# plot figure
fig = plt.figure(figsize=(3, 3))
ax = plt.gca()
ax.imshow(vm, extent=(-3, 3, -3, 3), interpolation='nearest')
ax.axis('image')
fig.savefig('SORD-Example.svg', dpi=80)
