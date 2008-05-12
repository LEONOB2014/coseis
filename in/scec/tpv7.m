% TPV7
np       = [    1,   1,  16 ];
np       = [    1,   1,   2 ];
nn       = [  351, 176, 128 ];
n1expand = [    0,   0,   0 ];
n2expand = [    0,   0,   0 ];
bc1      = [   10,   0,  10 ];
bc2      = [   10,  10,  10 ];
ihypo    = [    0,  76,   0 ];
fixhypo  =     -1;
xhypo    = [   0.,  0.,  0. ];

nt  = 1500;
dx  = 100.;
dt  = 0.008;

rho = 2670.;
vp  = 5500.;  vp  = { 6000., 'zone', 1, 1, 1, -1, -1, 0 }; vp  = { 5000., 'zone', 1, 1, 0, -1, -1, -1 };
vs  = 3175.5; vs  = { 3464., 'zone', 1, 1, 1, -1, -1, 0 }; vs  = { 2887., 'zone', 1, 1, 0, -1, -1, -1 };
gam = 0.2;
gam = { 0.02, 'cube', -15001., -7501., -4000.,   15001., 7501., 4000. };
hourglass = [ 1., 2. ];

faultnormal = 3;
vrup = -1.;
dc  = 0.4;
mud = 0.525;
mus = 10000.;
mus = { 0.677,  'cube', -15001., -7501., -1.,  15001., 7501., 1. };
tn  = -120e6;
ts1 = 70e6;
ts1 = { 72.9e6, 'cube',  -1501., -1501., -1.,   1501., 1501., 1. };
ts1 = { 75.8e6, 'cube',  -1501., -1499., -1.,   1501., 1499., 1. };
ts1 = { 75.8e6, 'cube',  -1499., -1501., -1.,   1499., 1501., 1. };
ts1 = { 81.6e6, 'cube',  -1499., -1499., -1.,   1499., 1499., 1. };

out = { 'x',    1,   1, 1, 64,  0,   -1, -1, 64,  0 };
out = { 'tsm',  1,   1, 1,  0,  0,   -1, -1,  0,  0 };
out = { 'trup', 1,   1, 1,  0, -1,   -1, -1,  0, -1 };

out = { 'u',  1,    91, 1, 101, 0,    91, 1, 101, 1500 };
out = { 'v',  1,    91, 1, 101, 0,    91, 1, 101, 1500 };
out = { 'ts', 1,    91, 1, 101, 0,    91, 1, 101, 1500 };
out = { 'tn', 1,    91, 1, 101, 0,    91, 1, 101, 1500 };
out = { 'u',  1,     0, 1, 101, 0,     0, 1, 101, 1500 };
out = { 'v',  1,     0, 1, 101, 0,     0, 1, 101, 1500 };
out = { 'ts', 1,     0, 1, 101, 0,     0, 1, 101, 1500 };
out = { 'tn', 1,     0, 1, 101, 0,     0, 1, 101, 1500 };
out = { 'u',  1,   -91, 1, 101, 0,   -91, 1, 101, 1500 };
out = { 'v',  1,   -91, 1, 101, 0,   -91, 1, 101, 1500 };
out = { 'ts', 1,   -91, 1, 101, 0,   -91, 1, 101, 1500 };
out = { 'tn', 1,   -91, 1, 101, 0,   -91, 1, 101, 1500 };
out = { 'u',  1,    91, 0, 101, 0,    91, 0, 101, 1500 };
out = { 'v',  1,    91, 0, 101, 0,    91, 0, 101, 1500 };
out = { 'ts', 1,    91, 0, 101, 0,    91, 0, 101, 1500 };
out = { 'tn', 1,    91, 0, 101, 0,    91, 0, 101, 1500 };
out = { 'u',  1,   -91, 0, 101, 0,   -91, 0, 101, 1500 };
out = { 'v',  1,   -91, 0, 101, 0,   -91, 0, 101, 1500 };
out = { 'ts', 1,   -91, 0, 101, 0,   -91, 0, 101, 1500 };
out = { 'tn', 1,   -91, 0, 101, 0,   -91, 0, 101, 1500 };

out = { 'u',  1,    91, 1, 102, 0,    91, 1, 102, 1500 };
out = { 'v',  1,    91, 1, 102, 0,    91, 1, 102, 1500 };
out = { 'ts', 1,    91, 1, 102, 0,    91, 1, 102, 1500 };
out = { 'tn', 1,    91, 1, 102, 0,    91, 1, 102, 1500 };
out = { 'u',  1,     0, 1, 102, 0,     0, 1, 102, 1500 };
out = { 'v',  1,     0, 1, 102, 0,     0, 1, 102, 1500 };
out = { 'ts', 1,     0, 1, 102, 0,     0, 1, 102, 1500 };
out = { 'tn', 1,     0, 1, 102, 0,     0, 1, 102, 1500 };
out = { 'u',  1,   -91, 1, 102, 0,   -91, 1, 102, 1500 };
out = { 'v',  1,   -91, 1, 102, 0,   -91, 1, 102, 1500 };
out = { 'ts', 1,   -91, 1, 102, 0,   -91, 1, 102, 1500 };
out = { 'tn', 1,   -91, 1, 102, 0,   -91, 1, 102, 1500 };
out = { 'u',  1,    91, 0, 102, 0,    91, 0, 102, 1500 };
out = { 'v',  1,    91, 0, 102, 0,    91, 0, 102, 1500 };
out = { 'ts', 1,    91, 0, 102, 0,    91, 0, 102, 1500 };
out = { 'tn', 1,    91, 0, 102, 0,    91, 0, 102, 1500 };
out = { 'u',  1,   -91, 0, 102, 0,   -91, 0, 102, 1500 };
out = { 'v',  1,   -91, 0, 102, 0,   -91, 0, 102, 1500 };
out = { 'ts', 1,   -91, 0, 102, 0,   -91, 0, 102, 1500 };
out = { 'tn', 1,   -91, 0, 102, 0,   -91, 0, 102, 1500 };

