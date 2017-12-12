import optparse
import numpy
import time
import ast
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report,confusion_matrix
from sklearn.externals import joblib


def receive(mlp):
    X = input("Enter boardstate: ")
    while(X != "exit"):
        print(mlp.predict(X))
        X = input("Enter boardstate: ")
    print("exiting")

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
