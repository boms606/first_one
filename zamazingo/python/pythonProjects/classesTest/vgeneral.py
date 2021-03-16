import datetime#### some library

def writest(w):
    a = print(w)
    return a

def updateMod():
    noww = datetime.datetime.now()
    nowww = f'{noww:%d.%m.%Y %H:%M:%S}'

    return nowww
    