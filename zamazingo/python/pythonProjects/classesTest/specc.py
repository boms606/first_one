# 'specc.py' with class 'leclass'
# Dependencies: vgeneral.py (liobrary)
#               vvars.py (variables; imported in vgenerals.py)

from vgeneral import *

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




