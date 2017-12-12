import optparse
import time
import ast
from neural import *

def writeitdown(inputfile, outputfile):
    dataset = partition(inputfile)
    out = open(outputfile, 'w')
    print('Lengths are')
    print(len(dataset[0]))
    print(len(dataset[1]))
    for i in range(len(dataset[0])):
        out.write(str(dataset[0][i])+ '\n')
        out.write(str(dataset[1][i])+ '\n')
        
def convertToBoard(dataset):

    gameStates = dataset[0]
    target = dataset[1]
    count = 0
    if target == "a":
        y = [1,0,0,0,0,0,0]
    elif target == "b":
        y = [0,1,0,0,0,0,0]
    elif target == "c":
        y = [0,0,1,0,0,0,0]
    elif target == "d":
        y = [0,0,0,1,0,0,0]
    elif target == "e":
        y = [0,0,0,0,1,0,0]
    elif target == "f":
        y = [0,0,0,0,0,1,0]
    elif target == "g":
        y = [0,0,0,0,0,0,1]

    playerturn = ("p1" == gameStates.pop(0))
    boardstate = [0]*42
    aCount, bCount, cCount, dCount, eCount, fCount, gCount = 0,0,0,0,0,0,0
    for move in gameStates:

        if(move == "a" and playerturn):
            boardstate[aCount] = 1
            aCount += 1
            playerturn = not playerturn
        elif(move == "b" and playerturn):
            boardstate[6 + bCount] = 1
            bCount += 1
            playerturn = not playerturn
        elif(move == "c" and playerturn):
            boardstate[12 + cCount] = 1
            cCount += 1
            playerturn = not playerturn
        elif(move == "d" and playerturn):
            boardstate[18 + dCount] = 1
            dCount += 1
            playerturn = not playerturn
        elif(move == "e" and playerturn):
            boardstate[24 + eCount] = 1
            eCount += 1
            playerturn = not playerturn
        elif(move == "f" and playerturn):
            boardstate[30 + fCount] = 1
            fCount += 1
            playerturn = not playerturn
        elif(move == "g" and playerturn):
            boardstate[36 + gCount] = 1
            gCount += 1
            playerturn = not playerturn
        elif(move == "a" and playerturn != True):
            boardstate[aCount] = -1
            aCount += 1
            playerturn = not playerturn
        elif(move == "b" and playerturn != True):
            boardstate[6 + bCount] = -1
            bCount += 1
            playerturn = not playerturn
        elif(move == "c" and playerturn != True):
            boardstate[12 + cCount] = -1
            cCount += 1
            playerturn = not playerturn
        elif(move == "d" and playerturn != True):
            boardstate[18 + dCount] = -1
            dCount += 1
            playerturn = not playerturn
        elif(move == "e" and playerturn != True):
            boardstate[24 + eCount] = -1
            eCount += 1
            playerturn = not playerturn
        elif(move == "f" and playerturn != True):
            boardstate[30 + fCount] = -1
            fCount += 1
            playerturn = not playerturn
        elif(move == "g" and playerturn != True):
            boardstate[36 + gCount] = -1
            gCount += 1
            playerturn = not playerturn
    return [boardstate,y]

def partition(inputfile):
    goal = []
    boardstate = []
    lines=open(inputfile, 'r').readlines()
    lines_set = set(lines)
    print(len(lines_set))
    for line in lines_set:
        x = ast.literal_eval(line)
        x.pop()
        count = 0
        while(len(x)-1 > 1):
            goal.append(x.pop())
            boardstate.append(x[:])
            x.pop()
    parsedgoal = []
    parsedboardstate = []
    for i in range(len(boardstate)):
        [x, y] = convertToBoard([boardstate[i],goal[i]])
        parsedboardstate.append(x)
        parsedgoal.append(y)
    dataset = [parsedboardstate, parsedgoal]
    #for i in range(len(parsedboardstate)):
    #        print(parsedboardstate[i])
    #        print(parsedgoal[i])
    print(arraylength(dataset))
    return dataset

def arraylength(array):
    count = 0
    for o in range(len(array)):
        for i in range(len(array[o])):
            for y in range(len(array[o][i])):
                count += 1
    return count

def main():
        parser = optparse.OptionParser('usage %prog ' +\
                        '-i <inputfile> -o <outputfile>')
        parser.add_option('-i', dest='inputfile', type='string',
                        help='specify your input file')
        parser.add_option('-o', dest='outputfile', type='string',
                        help='specify your output file')
        (options, args) = parser.parse_args()
        inputfile = options.inputfile
        outputfile = options.outputfile
        if (inputfile == None) or (outputfile == None):
                print (parser.usage)
                exit(1)
        else:
            start_time = time.time()
            writeitdown(inputfile, outputfile)
            print(time.time() - start_time , " sec")

if __name__ == '__main__':
        main()
