% TeraShake 500m
  datadir = 'ts/0500/data';
  nt = 6000; itio = 400; itcheck = 0;
  nt = 3000; itio = 400; itcheck = 0;
  np = [ 1 38 4 ]; % DS 19, TG 76
  np = [ 1 76 4 ]; % DS 38, TG 152
  np = [ 1  8 4 ];
  np = [ 1  6 4 ];

  grid  = 'read';
  rho   = 'read';
  vp    = 'read'; vp1  = 1500.;
  vs    = 'read'; vs1  = 500.;
  vdamp = 400.;   gam2 = .8;
  bc1   = [ 10 10 10 ];
  bc2   = [ 10 10  0 ];
  fixhypo = 1; faultnormal = 2; slipvector = [ 1. 0. 0. ];
  mus = 1000.;
  mud = .5;
  dc  = .5;
  tn  = -20e6;
  ts1 = 'read';
  rcrit = 3000.; vrup = 2300.;

  dx = 500.; dt = .03; trelax = .3;
  nn    = [ 1201  602 161 ];
  ihypo = [  545  399 -11 ];
  ihypo = [  907  399 -11 ];
% mus = [ 1.06 'zone'   527   0 -33         925   0 -1       ];
  mus = [ 1.09 'zone'   527   0 -33         925   0 -1       ];
  out = { 'x'      1    527 399 -33    0    925 399 -1     0 };
  out = { 'rho'    1    527   0 -33    0    925   0 -1     0 };
  out = { 'vp'     1    527   0 -33    0    925   0 -1     0 };
  out = { 'vs'     1    527   0 -33    0    925   0 -1     0 };
  out = { 'gam'    1    527   0 -33    0    925   0 -1     0 };
  out = { 'tn'    10    527   0 -33    0    925   0 -1  3000 };
  out = { 'tsm'   10    527   0 -33    0    925   0 -1  3000 };
  out = { 'sl'    10    527   0 -33    0    925   0 -1  3000 };
  out = { 'svm'   10    527   0 -33    0    925   0 -1  3000 };
  out = { 'psv'   10    527   0 -33    0    925   0 -1  3000 };
  out = { 'trup'   1    527   0 -33 3000    925   0 -1  3000 };
  out = { 'x'      1      1   1  -1    0     -1  -1 -1     0 };
  out = { 'rho'    1      1   1  -2    0     -1  -1 -1     0 };
  out = { 'vp'     1      1   1  -2    0     -1  -1 -1     0 };
  out = { 'vs'     1      1   1  -2    0     -1  -1 -1     0 };
  out = { 'gam'    1      1   1  -2    0     -1  -1 -1     0 };
  out = { 'pv2' 3000      1   1  -1 3000     -1  -1 -1  6000 };
% out = { 'vm2'  100      1   1  -1    0     -1  -1 -1  6000 };
% out = { 'vm2'  100      1   1  -1   20     -1  -1 -1  6000 };
% out = { 'vm2'  100      1   1  -1   40     -1  -1 -1  6000 };
% out = { 'vm2'  100      1   1  -1   60     -1  -1 -1  6000 };
% out = { 'vm2'  100      1   1  -1   80     -1  -1 -1  6000 };
  timeseries = { 'v'  82188. 188340. 129. }; % Bakersfield
  timeseries = { 'v'  99691.  67008.  21. }; % Santa Barbara
  timeseries = { 'v' 152641.  77599.  16. }; % Oxnard
  timeseries = { 'v' 191871. 180946. 714. }; % Lancaster
  timeseries = { 'v' 216802. 109919.  92. }; % Westwood
  timeseries = { 'v' 229657. 119310. 107. }; % Los Angeles
  timeseries = { 'v' 242543. 123738.  63. }; % Montebello
  timeseries = { 'v' 253599.  98027.   7. }; % Long Beach
  timeseries = { 'v' 256108. 263112. 648. }; % Barstow
  timeseries = { 'v' 263052. 216515. 831. }; % Victorville
  timeseries = { 'v' 271108. 155039. 318. }; % Ontario
  timeseries = { 'v' 278097. 115102.  36. }; % Santa Ana
  timeseries = { 'v' 293537. 180173. 327. }; % San Bernardino
  timeseries = { 'v' 296996. 160683. 261. }; % Riverside
  timeseries = { 'v' 351928.  97135.  18. }; % Oceanside
  timeseries = { 'v' 366020. 200821. 140. }; % Palm Springs
  timeseries = { 'v' 403002. 210421. -18. }; % Coachella
  timeseries = { 'v' 402013.  69548.  23. }; % San Diego
  timeseries = { 'v' 501570.  31135.  24. }; % Ensenada
  timeseries = { 'v' 526989. 167029.   1. }; % Mexicali
  timeseries = { 'v' 581530. 224874.  40. }; % Yuma

