import os
import subprocess

ROOT = 'lattests/bad/'

bad_dir = os.fsencode(ROOT)

with open('tests.bad', 'a') as out:
    for file in os.listdir(bad_dir):
        name = os.fsdecode(file)
        path = ROOT + name
        if name.endswith('.lat'):
            print(path)
            test = subprocess.run(['./latc', path], 
                                  text=True, 
                                  capture_output=True)
            serr = test.stderr
            sout = test.stdout
            out.write(path + '\n')
            if serr:
                print(serr)
                out.write(serr)
            if sout:
                print(sout)
                out.write(sout)
            out.write('\n')
            

