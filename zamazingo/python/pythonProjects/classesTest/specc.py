from vvars import *
from vgeneral import *

#if __name__ == '__main__':

#vgeneral.writest(vvars.var1)
writest("Initialize using '[ObjectName] = leclass([name]')")

class leclass:

    def __init__(self, lename="default"):
        global leclass

        self.keys = {'name': lename}
        self.crda = updateMod()
        self.modda = 'never'

    def setAttr(self, n, c):
        self.keys[n] = c
        self.modda = updateMod()

    def getAttr(self, n):
        writest(self.keys[n])

    def getInfo(self):
        writest('|          Name: ' + self.keys['name'])
        writest('|       Created: ' + self.crda)
        writest('| Last Modified: ' + self.modda)

    def getAll(self):
        #writest(self.keys)
        writest('\n'.join("%s: %s" % item for item in self.keys.items()))




