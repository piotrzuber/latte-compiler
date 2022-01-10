import os
import subprocess
import difflib

ROOT = 'lattests/good/'
GREEN = '\033[2;32;40m'
RED = '\033[1;31;40m'
BLUE = '\033[1;33;40m'

good_dir = os.fsencode(ROOT)

failures = []
counter = 0

with open('tests.good', 'a') as out:
    for file in os.listdir(good_dir):
        name = os.fsdecode(file)
        path = ROOT + name
        if name.endswith('.lat'):
            counter += 1
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
                if serr.find('ERROR') > 0:
                    failures.append(path)
            if sout:
                print(sout)
                out.write(sout)
            out.write('\n')

            print('Diff outputs:')
            bin, _ = os.path.splitext(path)
            bin_run = subprocess.run([bin],
                                     text=True,
                                     capture_output=True)
            actual = bin_run.stdout
            expected_path = bin + '.output'
            with open(expected_path, 'r') as expected_f:
                expected = expected_f.read()
                diff = []
                for i, d in enumerate(difflib.ndiff(actual, expected)):
                    if d[0] != ' ':
                        diff.append(f'{i}: {d[0]} {d[-1]}')
                if len(diff) > 0:
                    print("DIFF ERROR: program output does not",
                        "match the expected output")
                    out.write('DIFF ERROR\n')
                    out.write('\n')
                    failures.append(path)
                    for d in diff:
                        print(d)
                        out.write(d + '\n')
                else:
                    print("DIFF SUCCEEDED")

print(f'{BLUE}Test summary:')
if len(failures) == 0:
    print(f'{GREEN}{counter} tests finished with no errors!')
else:
    print(f'{RED}{len(failures)}/{counter} tests finished with errors...')
    print(f'{RED}Failures: ')
    for fail in failures:
        print(f'{RED}\t{fail}')
