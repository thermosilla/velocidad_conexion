from decouple import config

host = config('SSH_HOST')
user = config('SSH_USER')
key = config('SSH_KEY_PATH')
data_file = config('DATA_FILE')
