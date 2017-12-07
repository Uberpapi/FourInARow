import optparse
import numpy
import time
import ast
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier

def convertToBoard(dataset):

    x = []
    y = []
    gameStates = dataset[0]
    target = dataset[1]
    count = 0
    for i in target:
        if i == "a":
            y. append([1,0,0,0,0,0,0])
        elif i == "b":
            y. append([0,1,0,0,0,0,0])
        elif i == "c":
            y. append([0,0,1,0,0,0,0])
        elif i == "d":
            y. append([0,0,0,1,0,0,0])
        elif i == "e":
            y. append([0,0,0,0,1,0,0])
        elif i == "f":
            y. append([0,0,0,0,0,1,0])
        elif i == "g":
            y. append([0,0,0,0,0,0,1])

    for moves in gameStates:
        boardstate = [0]*42
        aCount, bCount, cCount, dCount, eCount, fCount, gCount = 0,0,0,0,0,0,0
        playerturn = ("p1" == moves.pop(0))
        for move in moves:
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
        x.append(boardstate)
    return [x,y]


def partition(inputfile):
    goal = []
    boardstate = []
    lines=open(inputfile, 'r').readlines()
    lines_set = set(lines)
    print(len(lines_set))
    for line in lines_set:
        gamegoal = []
        gameboardstate = []
        x = ast.literal_eval(line)
        x.pop()
        count = 0
        while(len(x)-1 > 1):
            gamegoal.append(x.pop())
            gameboardstate.append(x[:])
            x.pop()
        goal.append(gamegoal)
        boardstate.append(gameboardstate)
        dataset = []
    for i in range(len(boardstate)):
        result = convertToBoard([boardstate[i],goal[i]])
        dataset.append(result)

#    for board in boardstate:
#        count = 0
#        for i in board:
#            print(i)
#            print(dataset[0][0][count])
#            count += 1
    #print(len(dataset))
    print(arraylength(dataset))
    return dataset

def arraylength(array):
    count = 0
    for o in range(len(array)):
        for i in range(len(array[o])):
            for y in range(len(array[o][i])):
                for x in range(len(array[o][i][y])):
                    count += 1
    return count
def trainNeural(dataset):
    clf = MLPClassifier(activation='logistic',solver='sgd', hidden_layer_sizes=(10, 15), random_state=1)
    clf.fit(dataset[0], dataset[1])
    return clf
def main():
        parser = optparse.OptionParser('usage %prog ' +\
                       '-i <inputfile>')
        parser.add_option('-i', dest='inputfile', type='string',
                        help='specify your input file')
        (options, args) = parser.parse_args()
        inputfile = options.inputfile

        if (inputfile == None):
                print (parser.usage)
                exit(1)
        else:
                start_time = time.time()
                lineArray = partition(inputfile)
                #dataset = train_test_split(lineArray, test_size=0.3)
                #trainNeural(dataset)
                print(time.time() - start_time , " sec")
if __name__ == '__main__':
        main()
