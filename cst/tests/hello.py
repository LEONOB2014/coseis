#!/usr/bin/env python

def make():
    import os, subprocess
    import cst
    path = os.path.dirname(__file__)
    cwd = os.getcwd()
    os.chdir(path)
    cfg = cst.util.configure()
    if cfg['force'] or not os.path.exists('Makefile'):
        m = open('Makefile.in').read().format(**cfg)
        open('Makefile', 'w').write(m)
    subprocess.check_call(['make'])
    os.chdir(cwd)
    return

def test(argv=[]):
    import os, shutil
    import cst
    make()
    cwd = os.getcwd()
    d = os.paht.join(cwd, 'run', 'hello-c')
    os.makedirs(d)
    shutil.copy2('hello.c.x', d)
    os.chdir(d)
    cst.util.launch(
        run = 'exec',
        argv = argv,
        command = './hello.c.x',
        nthread = 2,
        nproc = 2,
        ppn_range = [2],
        minutes = 10,
    )
    d = os.paht.join(cwd, 'run', 'hello-f')
    os.makedirs(d)
    shutil.copy2('hello.f.x', d)
    os.chdir(d)
    cst.util.launch(
        run = 'exec',
        argv = argv,
        command = './hello.f.x',
        nthread = 2,
        nproc = 2,
        ppn_range = [2],
        minutes = 10,
    )
    return

# continue if command line
if __name__ == '__main__':
    import sys
    test(sys.argv[1:])

