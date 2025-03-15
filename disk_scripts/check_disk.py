import smtplib, ssl
import subprocess

output1 = subprocess.run(['df', '-h', '/mnt/drive1'], stdout=subprocess.PIPE, text=True)
output2 = subprocess.run(['df', '-h', '/mnt/drive2'], stdout=subprocess.PIPE, text=True)
output_rsync = subprocess.run(['sudo', 'rsync', '-avn', '--delete', '/mnt/drive1/', '/mnt/drive2'], stdout=subprocess.PIPE, text=True)
output_smartctl = subprocess.run(['sudo', 'smartctl', '-a', '/dev/sdb'], stdout=subprocess.PIPE, text=True)

port = 465  # For SSL
password = 'iujtlwdtqvlyphpu'
smtp_server = "smtp.gmail.com"
sender_email = "tinocloud.cloudns@gmail.com"  # Enter your address
receiver_email = "davidjer@hotmail.de"  # Enter receiver address
message = """\
Subject: tinocloud

Disk 1:
""" + output1.stdout + """

Disk 2:
""" + output2.stdout + """
rsync: 
""" + output_rsync.stdout + """


smartctl:
""" + output_smartctl.stdout

# Create a secure SSL context
context = ssl.create_default_context()

with smtplib.SMTP_SSL(smtp_server, port, context=context) as server:
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_email, message)

