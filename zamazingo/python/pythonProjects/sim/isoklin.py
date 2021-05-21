from math import *
import matplotlib as mlp
import matplotlib.pyplot as plt

# dy=t+y
def ia(dy):
    st=degrees(atan(dy))
    print("Steigung: "+str(st)+"°")
    for i in range(-7, 8):
        a=dy-i
        print("t= "+ str(i) +"; y= "+str(a))

# dy=t**2-4t+4-y
def ib(dy):
    for i in range(-7, 8):
        a=-dy+i**2-4*i+4
        print("t= "+ str(i) +"; y= "+str(a))



