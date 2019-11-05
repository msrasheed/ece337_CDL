def crc16_gen(val):
    byts = bytes(val, 'utf-8')
    init = 0xffff
    gen = 0x8005

    for byte in byts:
        for i in range(8):
            highorderbit = (init >> 15) & 0x1
            incomingbit = (byte >> (7 - i)) & 0x1
            test = highorderbit ^ incomingbit
            temp = (init << 1) & 0xffff
            #print(bin(temp))
            if test == 1:
                init = temp ^ gen
            else:
                init = temp

    return init ^ 0xffff

def checker(val, crc):
    byts = bytes(val, 'utf-8')
    init = 0xffff
    gen = 0x8005

    for byte in byts:
        for i in range(8):
            highorderbit = (init >> 15) & 0x1
            incomingbit = (byte >> (7 - i)) & 0x1
            test = highorderbit ^ incomingbit
            temp = (init << 1) & 0xffff
            #print(bin(temp))
            if test == 1:
                init = temp ^ gen
            else:
                init = temp

    byts = [(crc >> 8), (crc & 0xff)]
    for byte in byts:
        for i in range(8):
            highorderbit = (init >> 15) & 0x1
            incomingbit = (byte >> (7 - i)) & 0x1
            test = highorderbit ^ incomingbit
            temp = (init << 1) & 0xffff
            #print(bin(temp))
            if test == 1:
                init = temp ^ gen
            else:
                init = temp

    return init

s = "i'm fucking livid why did this take me so long you piece of shit"
crc = crc16_gen(s)
#s = "i'm fucking libid why did this take me so long you piece of shit"
out = checker(s, crc)
print(hex(crc))
print(hex(out))