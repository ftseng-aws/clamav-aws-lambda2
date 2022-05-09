import random
import string
import pathlib
filepath = str(pathlib.Path().resolve())
virus_string1="X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*"

def filegen(filename,size):
    
    filename = filepath + "/" + filename
    chars = ''.join([random.choice(string.ascii_letters) for i in range(size)])
    with open(filename, 'w') as f:
        f.write(chars)
        f.close()

    return filename

def filegen_v(filename,size,virus_string):
    
    filename = filepath + "/" + filename
    chars = ''.join([random.choice(string.ascii_letters) for i in range(size)])
    chars = virus_string + chars
    with open(filename, 'w') as f:
        f.write(chars)
        f.close()

    return filename
    
def filegen1000(filename,size):
    divisor = 1000000
    sizecount =  size // divisor
    chars = ''.join([random.choice(string.ascii_letters) for i in range(divisor)])
    chars = sizecount * chars
    with open(filename, 'w') as f:
        f.write(chars)
        f.close()

    return filename    

def filegen1000_v(filename,size,virus_string):
    divisor = 1000000
    sizecount =  size // divisor
    chars = ''.join([random.choice(string.ascii_letters) for i in range(divisor)])
    chars = sizecount * chars
    chars = virus_string + chars
    with open(filename, 'w') as f:
        f.write(chars)
        f.close()

    return filename

