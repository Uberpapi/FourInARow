import optparse
import numpy as np
import time
import ast
import socket
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report,confusion_matrix
from sklearn.externals import joblib

def streamtime():
    clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    clientsocket.connect(('localhost', 4000))
    return clientsocket


def receive(mlp):
    stream = streamtime()
    print('We have now started ARNOLD')
    X = stream.recv(1024)
    print(X)
    scaler = StandardScaler()
    while(True):
        print(X)
        #X = ast.literal_eval(X)
        X = np.asmatrix(X)
        #print('after fit', X)
        Send = mlp.predict(X)
        stream.send(b(Send))
        X = stream.recv(1024)
        if not X:
            break

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

                #Loading NN-trained for 207 million games that lead to 533458 unique end states
                mlp = joblib.load('memory.pkl')
                receive(mlp)

                print(time.time() - start_time , " sec")

if __name__ == '__main__':
        main()
