import shutil
import subprocess

# Define the path and the threshold (100 GB in bytes)
path = "/mnt/drive1"
threshold_gb = 100 * (1024**3) 

try:
    print("INFO: copy drive1 to drive2...")

    total, used, free = shutil.disk_usage(path)
    print("total: " + str(total) + " , used: " + str(used) + " , free: " + str(free))

    if used > threshold_gb:
        subprocess.run(["sudo", "rsync", "-a", "--delete", "/mnt/drive1/", "/mnt/drive2/"], check=True)
except FileNotFoundError:
    print(f"Error: {path} not found.")