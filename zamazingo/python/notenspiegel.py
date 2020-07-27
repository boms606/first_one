#arra ->    array mit % und ects als gewichtung
#           [[58,8],[70,5]]
#           58% mit 8 ects und 70% mit 5 ects 
#           ->  (arra[0][0]*arra[0][1]+arra[1][0]*arra[1][1])/(arra[0][1]+arra[1][1])
#               -> Durchschnittsnote mit (58*8+70*5)/(8+5)

"""
NUTZUNG:

from spiegel import*
arr(note,ects,faktor)  #für jede note.. faktor leer lassen wenn faktor=1
..
..
..
durchs()
"""

"""
Notenspiegel für Modulnoten:

≥ 95 bis 100 1,0 
≥ 90 bis < 95 1,3 
≥ 85 bis < 90 1,7  
≥ 80 bis < 85 2,0
≥ 75 bis < 80 2,3
≥ 70 bis < 75 2,7  
≥ 65 bis < 70 3,0
≥ 60 bis < 65 3,3
≥ 55 bis < 60 3,7   
≥ 50 bis < 55 4,0
< 50 5,0


Mathematischer Wert (ohne Schlüssel) für Durchschnittsnoten
((noteInProzent-50)/(100-50))*(1-4)+4
---
noteInProzent-50/100-50 = Schulnote-4/1-4
--- 

"""

arra = []

def schulnote(p):
    if(p<=100 and p>=95):
        n=1.0
    elif(p<95 and p>=90):
        n=1.3
    elif(p<90 and p>=85):
        n=1.7
    elif(p<85 and p>=80):
        n=2.0
    elif(p<80 and p>=75):
        n=2.3
    elif(p<75 and p>=70):
        n=2.7
    elif(p<70 and p>=65):
        n=3.0
    elif(p<65 and p>=60):
        n=3.3
    elif(p<60 and p>=55):
        n=3.7
    elif(p<55 and p>=50):
        n=4.0
    elif(p<50):
        n=5.0
    return n

def mathnote(p):
    n = ((p-50)/(100-50))*(1-4)+4
    if(n>4):
        n=5
    return n

def durchs(arra = arra):                                                                   
    a=0             #ects
    n=0             #nenner
    p=0             #zähler (punkte)
    m = len(arra)
    ma = m-1
    for i in arra:
        a+=i[1]             #counter für gesamt-ects
        n+=(i[1]*i[2])      #nenner (ects mit faktor)
        p+=i[0]*i[1]*i[2]   #zähler (prozente mit faktor)
    print('gesamt ects: ' + str(a))
    ans=p/n
    print('Durchschnitt: ' + str(ans) + ' %')
    print(' Durchschn. Modulschulnote: ' + str(schulnote(ans)))
    print('Durchschn. math. Schulnote: ' + str(mathnote(ans)))

    #return ans

def arr(note, ects, faktor = 1):
    global arra
    arra +=  [[note,ects,faktor]]
    #print(arra)
    return arra
