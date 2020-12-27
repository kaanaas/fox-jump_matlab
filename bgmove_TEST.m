mainfake1 = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
mainfake = [mainfake1
            mainfake1 + 15
            mainfake1 + 30
            mainfake1 + 45
            mainfake1 + 60
            mainfake1 + 75
            mainfake1 + 90]

 n = 3;
 
mainfake = bgmoveud(mainfake,n)
