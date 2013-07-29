"""
Coseis Configuration
"""

import os, sys, pwd, socket, multiprocessing
import numpy as np

# email address
try:
    import configobj
    f = os.path.join(os.path.expanduser('~'), '.gitconfig')
    email = configobj.ConfigObj(f)['user']['email']
    del(configobj, f)
except:
    email = pwd.getpwuid(os.geteuid())[0]

# job parameters
name = 'job'              # job name
rundir = 'run'            # name of the run directory
iodir = 'hold'            # name of directory for large io
nproc = 1                 # number of processes
nthread = 0               # number of threads per process
minutes = 0               # estimated run time
run = ''                  # 'exec': interactive, 'submit': batch queue
depend = ''               # job ID to wait for
command = ''              # executable command
pre = post = ''           # pre and post-processing commands
force = False             # overwrite existing
dtype = np.dtype('f').str # Numpy data type

# machine specific
python = 'python'
f2py_flags = ''
machine = ''
account = ''
host = os.uname()
host = ' '.join((
    host[0],
    host[4],
    host[1],
    socket.getfqdn(),
    #os.environ['HOSTNAME'],
))
host_opts = {}
queue = ''
queue_opts = []
ppn_range = []
maxnodes = 1
maxcores = multiprocessing.cpu_count()
maxram = 0
pmem = 0
maxtime = 0
rate = 1.0e6
nstripe = -2

# command line options
argv = sys.argv[1:]
options = [
    ('i', 'interactive', 'run',  'exec'),
    ('q', 'queue',       'run',  'submit'),
    ('f', 'force',       'force', True),
]

# default scheduler: PBS
#launch = '{command}'
launch = 'mpiexec -np {nproc} {command}'
notify_threshold = 4096
notify = '-m abe'
submit_flags = ''
submit_pattern = r'(?P<jobid>\d+\S*)\D*$'
submit = 'qsub {notify} {submit_flags} "{name}.sh"'
submit2 = 'qsub {notify} -W depend="afterok:{depend}" {submit_flags} "{name}.sh"'

# batch script
script = """\
#!/bin/sh
cd "{rundir}"
env >> {name}.env
echo "$( date ): {name} started" >> {name}.out
{pre} >> {name}.out
{launch} >> {name}.out
{post} >> {name}.out
echo "$( date ): {name} finished" >> {name}.out
"""

# detect machine from the hostname
for m, h in [
    ('ALCF-BGQ',    'vestalac1.ftd.alcf.anl.gov'),
    ('ALCF-BGQ',    'cetuslac1.fst.alcf.anl.gov'),
    ('ALCF-BGQ',    'miralac1.fst.alcf.anl.gov'),
    ('ALCF-BGP',    'surveyor.alcf.anl.gov'),
    ('ALCF-BGP',    'challenger.alcf.anl.gov'),
    ('ALCF-BGP',    'intreplid.alcf.anl.gov'),
    ('IBM-Wat2Q',   'grotius.watson.ibm.com'),
    ('NICS-Kraken', 'kraken'),
    ('USC-HPC',     'hpc-login1.usc.edu'),
    ('USC-HPC',     'hpc-login2-l.usc.edu'),
    ('Airy',        'airy'),
]:
    if h in host:
        machine = m
        break

# clean up the namespace
del(os, sys, pwd, socket, multiprocessing, np)
del(m, h)

