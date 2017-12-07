import optparse
import numpy
import time
import ast
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier

def convertToBoard(dataset):

    X = []
    y = []
    gameStates = dataset[0]
    target = dataset[1]

    moves.pop(0)
    for y in target:
        asd =1+2

    for moves in gameStates:
        boardstate = [0]*42
        aCount, bCount, cCount, dCount, eCount, fCount, gCount = 0,0,0,0,0,0,0
        playerturn = ("p1" == moves.pop(0))
        for move in moves:
            if(move == "a" and playerturn):
                boardstate[aCount] = 1
            elif(move == "b" and playerturn):
                boardstate[bCount] = 1
            elif(move == "c" and playerturn):
                boardstate[cCount] = 1
            elif(move == "d" and playerturn):
                boardstate[dCount] = 1
            elif(move == "e" and playerturn):
                boardstate[eCount] = 1
            elif(move == "f" and playerturn):
                boardstate[fCount] = 1
            elif(move == "g" and playerturn):
                boardstate[gCount] = 1
            if(move == "a" and playerturn != true):
                boardstate[aCount] = -1
            elif(move == "b" and playerturn != true):
                boardstate[bCount] = -1
            elif(move == "c" and playerturn != true):
                boardstate[cCount] = -1
            elif(move == "d" and playerturn != true):
                boardstate[dCount] = -1
            elif(move == "e" and playerturn != true):
                boardstate[eCount] = -1
            elif(move == "f" and playerturn != true):
                boardstate[fCount] = -1
            elif(move == "g" and playerturn != true):
                boardstate[gCount] = -1

    return [X,y]


def partition(inputfile):

        goal = []
        boardstate = []
        lines=open(inputfile, 'r').readlines()
        lines_set = set(lines)
        for line in lines_set:
            x = ast.literal_eval(line)
            while(len(x)-1 > 1):
                goal.append(x.pop())
                boardstate.append(x[:])
                x.pop()

        #convertToBoard(dataset)
        dataset = [boardstate, goal]
        print(dataset)
        return dataset

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
