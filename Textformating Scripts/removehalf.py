import optparse
import time
import ast

def removeHalf(inputfile, outputfile):
    lines=open(inputfile, 'r').readlines()
    lines_set = set(lines)
    out=open(outputfile, 'w')
    games = 0
    randomwon = 0
    for line in lines_set:
        x = ast.literal_eval(line)
        whowon = x[len(x)-1]
        if (whowon == "p1"):
            randomwon += 1
            out.write(line)
        elif (games%2 == 0):
            games += 1
            out.write(line)
        else:
            games += 1
    print(randomwon)
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
            removeHalf(inputfile, outputfile)
            print(time.time() - start_time , " sec")

if __name__ == '__main__':
        main()
