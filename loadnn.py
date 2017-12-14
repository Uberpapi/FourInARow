import optparse
import numpy as np
import time
import ast
import socket
import sys
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report,confusion_matrix
from sklearn.externals import joblib

def receive(mlp):

    serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    serversocket.bind(('localhost', 4000))
    serversocket.listen(5) # become a server socket, maximum 5 connections
    while True:
        connection, address = serversocket.accept()
        print('Connection initiated, reading data...')
        buf = connection.recv(2048)
        if len(buf) > 0 :
            print ("RECIEVED:" , buf)
            #qdata = input("SEND(TYPE q or Q to Quit):" )
            #print(qdata)
            #if (qdata == 'Q' and qdata == 'q'):
            #    break;
            #else:
            buf = buf.decode()
            print(buf)
            X = ast.literal_eval(buf)
            X = np.asmatrix(buf)
            buf = mlp.predict(X)
            print('We are now sending', buf)
            connection.send(buf)
            connection.close()
            print(buf, 'was just sent')



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
                mlp = joblib.load(inputfile)
                receive(mlp)

                print(time.time() - start_time , " sec")

if __name__ == '__main__':
        main()
