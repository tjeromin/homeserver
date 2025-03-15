import subprocess
import sys
import time

disk = '/dev/sdb'
if len(sys.argv) > 1:
    disk = sys.argv[1]

time_in_min = 500
if len(sys.argv) > 2:
    time_in_min = int(sys.argv[2])

i = 0
while i < time_in_min:
    subprocess.run(['sudo', 'dd', 'if=' + disk, 'iflag=direct', 'count=1', 'of=/dev/null'])
    i += 1
    time.sleep(60)

