import shutil
import subprocess
import sys

if (len(sys.argv) < 3):
    raise ValueError("Usage: copy_disk.py path_copy_from path_copy_to")

# Define the path and the threshold (100 GB in bytes)
path_from = sys.argv[1]
path_to = sys.argv[2]
threshold_gb = 100 * (1024**3)

try:
    print("INFO: copy drive1 to drive2...")

    total, used, free = shutil.disk_usage(path_from)
    print("from:\ntotal: " + str(total) + " , used: " + str(used) + " , free: " + str(free))

    total_to, used_to, free_to = shutil.disk_usage(path_to)
    print("to:\ntotal: " + str(total_to) + " , used: " + str(used_to) + " , free: " + str(free_to))

    if used > threshold_gb and used + 10_000_000_000 > used_to:
        subprocess.run(["sudo", "rsync", "-a", "--delete", path_from, path_to], check=True)
    else:
        raise RuntimeError("less than {threshold_gb} bytes used or from has 10GB less than to. Disk_from probably not mounted.")
except FileNotFoundError:
    print(f"Error: {path_from} not found.")