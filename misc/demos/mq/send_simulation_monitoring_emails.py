import base64, email, os, sys, smtplib
from email.mime.text import MIMEText

from prodiguer import config, rt


# Simulation folder in which the messages are held.
_DIRPATH = sys.argv[1]
if not os.path.exists(_DIRPATH) or not os.path.isdir(_DIRPATH):
    raise ValueError("Path does not exist: {0}", _DIRPATH)


# Module vars.
files = []
mails = []
payloads = []


def _decode_b64(data):
    """Helper function: decodes base64  data."""
    try:
        return base64.b64decode(data)
    except Exception as err:
        return data, err


# Set files to be processed.
files = [os.path.join(_DIRPATH, f) for f in os.listdir(_DIRPATH) \
        if str.lower(f[-3:])=="eml"]

# Set mails to be processed.
mails = [email.message_from_file(open(f, 'r')) for f in files]

# Set mail payloads.
for mail in mails:
    if mail.is_multipart():
        payloads.append(mail.get_payload()[0].get_payload())
    else:
        payloads.append(mail.get_payload())

# Set mails to be dispatched.
mails_out = [MIMEText(p) for p in payloads]
for msg in mails_out:
    msg['Subject'] = "TEMPORARY AMPQ CHANNEL"
    msg['From'] = config.mail.smtp.addresses.prodiguer
    msg['To'] = config.mail.smtp.addresses.supervisor

# Connect to email server.
server = smtplib.SMTP()
# server.set_debuglevel(True)
server.connect(config.mail.smtp.host, config.mail.smtp.port)
server.ehlo()
server.starttls()
server.ehlo()
server.login(config.mail.smtp.username, config.mail.smtp.password)
server.ehlo()

# Dispatch emails.
for index, msg in enumerate(mails_out):
    rt.log_mq("Dispatching email: {0} of {1}".format(index + 1, len(mails_out)))
    server.sendmail(config.mail.smtp.addresses.prodiguer,
                    config.mail.smtp.addresses.supervisor,
                    msg.as_string())
