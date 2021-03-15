from vvars import *
from vgeneral import *

#if __name__ == '__main__':

#vgeneral.writest(vvars.var1)
writest("Initialize using '[ObjectName] = leclass([attributes]')")
writest("Attributes can be:\n  'd' as string\n  'attr1' as string\n  'attr2' as integer")

class leclass:

    def __init__(self, lename="default", a2=0):
        global leclass
        self.lename = lename
        self.attr1 = "Universalattribut"
        self.attr2 = a2
        self.lecolor = "opaque"

    def getAll(self):
        writest("  Name: " +self.lename+ "\n Atrr1: " +self.attr1+ "\n Attr2: " +str(self.attr2)+ "\n Color: " +self.lecolor)

    def setColor(self, c):
        self.lecolor = (c)

