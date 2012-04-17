"""
SCEC Community Velocity Model - Magistrale version

http://www.data.scec.org/3Dvelocity/
"""
import os, sys, re, shutil, urllib, tarfile, subprocess, shlex
import numpy as np
from ..conf import launch

path = os.path.dirname(os.path.realpath(__file__))

input_template = """\
{nsample}
{file_lon}
{file_lat}
{file_dep}
{file_rho}
{file_vp}
{file_vs}
"""

def _build(mode=None, optimize=None, version=None):
    """
    Build CVM-S code.
    """
    import cst

    # configure
    cf = cst.conf.configure('cvms')[0]
    if not mode:
        mode = cf.mode
    if not mode:
        mode = 'asm'
    if not optimize:
        optimize = cf.optimize
    if not version:
        version = cf.version
    assert version in ('2.2', '3.0', '4.0')
    ver = 'cvms-' + version

    # download source code
    url = 'http://earth.usc.edu/~gely/cvm-data/%s.tgz' % ver
    tarball = os.path.join(cf.repo, os.path.basename(url))
    if not os.path.exists(tarball):
        if not os.path.exists(cf.repo):
            os.makedirs(cf.repo)
        print('Downloading %s' % url)
        urllib.urlretrieve(url, tarball)

    # build directory
    cwd = os.getcwd()
    bld = os.path.join(os.path.dirname(path), 'build', ver) + os.sep
    if not os.path.isdir(bld):
        os.makedirs(bld)
        os.chdir(bld)
        fh = tarfile.open(tarball, 'r:gz')
        fh.extractall(bld)
        f = os.path.join(path, ver + '.patch')
        subprocess.check_call(['patch', '-p1', '-i', f])
    os.chdir(bld)

    # compile ascii, binary, and MPI versions
    new = False
    if 'a' in mode:
        source = 'iotxt.f', 'version%s.f' % version
        for opt in optimize:
            compiler = [cf.fortran_serial] + shlex.split(cf.fortran_flags[opt]) + ['-o']
            object_ = 'cvms-a' + opt
            new |= cst.conf.make(compiler, object_, source)
    if 's' in mode:
        source = 'iobin.f', 'version%s.f' % version
        for opt in optimize:
            compiler = [cf.fortran_serial] + shlex.split(cf.fortran_flags[opt]) + ['-o']
            object_ = 'cvms-s' + opt
            new |= cst.conf.make(compiler, object_, source)
    if 'm' in mode and cf.fortran_mpi:
        source = 'iompi.f', 'version%s.f' % version
        for opt in optimize:
            compiler = [cf.fortran_mpi] + shlex.split(cf.fortran_flags[opt]) + ['-o']
            object_ = 'cvms-m' + opt
            new |= cst.conf.make(compiler, object_, source)
    os.chdir(cwd)
    return

def stage(inputs={}, **kwargs):
    """
    Stage job
    """
    import cst

    print('CVM-S setup')

    # update inputs
    inputs = inputs.copy()
    inputs.update(kwargs)

    # configure
    job, inputs = cst.conf.configure('cvms', **inputs)
    if inputs:
        sys.exit('Unknown parameter: %s' % inputs)
    if not job.mode:
        job.mode = 's'
        if job.nproc > 1:
            job.mode = 'm'
    job.command = os.path.join('.', 'cvms-' + job.mode + job.optimize)
    job = cst.conf.prepare(job)
    ver = 'cvms-' + job.version

    # build
    if not job.prepare:
        return job
    _build(job.mode, job.optimize, job.version)

    # check minimum processors needed for compiled memory size
    file = os.path.join(cst.path, 'build', ver, 'in.h')
    string = open(file).read()
    pattern = 'ibig *= *([0-9]*)'
    n = int(re.search(pattern, string).groups()[0])
    minproc = int(job.nsample / n)
    if job.nsample % n != 0:
        minproc += 1
    if minproc > job.nproc:
        sys.exit('Need at lease %s processors for this mesh size' % minproc)

    # create run directory
    if job.force == True and os.path.isdir(job.rundir):
        shutil.rmtree(job.rundir)
    if not os.path.exists(job.rundir):
        f = os.path.join(cst.path, 'build', ver)
        shutil.copytree(f, job.rundir)
    else:
        for f in (
            job.file_lon, job.file_lat, job.file_dep,
            job.file_rho, job.file_vp, job.file_vs,
        ) + job.stagein:
            ff = os.path.join(job.rundir, f)
            if os.path.isdir(ff):
                shutil.rmtree(ff)
            elif os.path.exists(ff):
                os.remove(ff)

    # process machine templates
    cst.conf.skeleton(job, stagein=job.stagein, new=False)

    # save input file and configuration
    f = os.path.join(job.rundir, 'cvms-input')
    open(f, 'w').write(input_template.format(**job.__dict__))
    f = os.path.join(job.rundir, 'conf.py')
    cst.util.save(f, job.__dict__)
    return job

def extract(lon, lat, dep, prop=['rho', 'vp', 'vs'], **kwargs):
    """
    Simple CVM-S extraction

    Parameters
    ----------
    lon, lat, dep: Coordinate arrays
    prop: 'rho', 'vp', or 'vs'
    nproc: Optional, number of processes
    rundir: Optional, job staging directory

    Returns
    -------
    rho, vp, vs: Material arrays
    """
    lon = np.asarray(lon, 'f')
    lat = np.asarray(lat, 'f')
    dep = np.asarray(dep, 'f')
    shape = dep.shape
    job = stage(nsample=dep.size, **kwargs)
    path = job.rundir + os.sep
    lon.tofile(path + job.file_lon)
    lat.tofile(path + job.file_lat)
    dep.tofile(path + job.file_dep)
    del(lon, lat, dep)
    launch(job, run='exec')
    out = []
    if type(prop) not in [list, tuple]:
        prop = [prop]
    for v in prop:
        f = {'rho': job.file_rho, 'vp': job.file_vp, 'vs': job.file_vs}[v]
        out += [np.fromfile(path + f, 'f').reshape(shape)]
    return np.array(out)

