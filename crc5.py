def crc5_gen(byte):
    init = 0x1f
    gen = 0x05

    for i in range(11):
        highorderbit = (init >> 4) & 0x1
        incomingbit = (byte >> (10 - i)) & 0x1
        test = highorderbit ^ incomingbit
        temp = (init << 1) & 0x1f
        #print(bin(temp))
        if test == 1:
            init = temp ^ gen
        else:
            init = temp

    return init ^ 0x1f

def checker(val, crc):
    init = 0x1f
    gen = 0x05

    for i in range(11):
        highorderbit = (init >> 4) & 0x1
        incomingbit = (val >> (10 - i)) & 0x1
        test = highorderbit ^ incomingbit
        temp = (init << 1) & 0x1f
        # print(bin(temp))
        if test == 1:
            init = temp ^ gen
        else:
            init = temp

    for i in range(5):
        highorderbit = (init >> 4) & 0x1
        incomingbit = (crc >> (4 - i)) & 0x1
        test = highorderbit ^ incomingbit
        temp = (init << 1) & 0x1f
        #print(bin(temp))
        if test == 1:
            init = temp ^ gen
        else:
            init = temp

    return init

s = 0x0
crc = crc5_gen(s)
#s = "Hello Wirld!"
out = checker(s, crc)
print(hex(crc))
print(hex(out))
print('passed: ', out == 0xc)