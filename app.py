from ssh import SFTP
from dataprocessor import Data
from config import host,user,key,data_file
import pandas as pd

def main():
    sftp = SFTP(host,user,key)
    data = Data()

    with sftp.open(data_file) as file:
        for line in file:
            data.append(line)
    sftp.close()

    data.clean(['Read','closed']).format()
    df = pd.DataFrame(data.formatedList, columns=['Fecha', 'Velocidad', 'Unidad'])
    print(df)

if __name__ == '__main__':
    main()
