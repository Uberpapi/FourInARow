import optparse
import numpy
import time
import ast
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report,confusion_matrix
from sklearn.externals import joblib
def convertToBoard(dataset):

    gameStates = dataset[0]
    target = dataset[1]
    count = 0
    if target == "a":
        y = 1
    elif target == "b":
        y = 2
    elif target == "c":
        y = 3
    elif target == "d":
        y = 4
    elif target == "e":
        y = 5
    elif target == "f":
        y = 6
    elif target == "g":
        y = 7

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
    print(len(lines_set), 'is the number of games')
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
    print(arraylength(dataset), 'is the number of elements after partition')
    return dataset

def arraylength(array):
    count = 0
    for o in range(1):
        for i in range(len(array[o])):
            for y in range(len(array[o][i])):
                count += 1
    return count + len(array[1])

def trainNeural(dataset):
    X = dataset[0]
    y = dataset[1]
    X_train, X_test, y_train, y_test = train_test_split(X, y)
    print(100 - (len(X_test)/len(dataset[0]))*100, '% of the games is being used as our train size and the rest is used for testing')
    scaler = StandardScaler()
    scaler.fit(X_train)
    X_train = scaler.transform(X_train)
    X_test = scaler.transform(X_test)

    mlp = MLPClassifier(hidden_layer_sizes=(50, 50, 50))
    mlp.fit(X_train,y_train)
    predictions = mlp.predict(X_test)

    print(predictions)
    print(confusion_matrix(y_test,predictions))
    print(classification_report(y_test,predictions))
    joblib.dump(mlp, 'memoryalex.pkl')

    return mlp
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
                #dataset_test = train_test_split(lineArray[0], lineArray[1])
                #datasetgoals = train_test_split(lineArray[1], test_size=0.3)
                trainNeural(lineArray)
                print(time.time() - start_time , " sec")

if __name__ == '__main__':
        main()
