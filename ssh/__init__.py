from paramiko import SSHClient, RSAKey, AutoAddPolicy

class SFTP:
    def __init__(self, host, user, key_path):
        self.host = host
        self.user = user
        self.key = RSAKey.from_private_key_file(key_path)

    def open(self, file_path):
        self.c = SSHClient()
        self.c.set_missing_host_key_policy(AutoAddPolicy())
        self.c.connect(hostname=self.host, username=self.user, pkey=self.key)

        self.sftp_client = self.c.open_sftp().open(file_path)
        
        return self.sftp_client

    def close(self):
        return self.c.close()


