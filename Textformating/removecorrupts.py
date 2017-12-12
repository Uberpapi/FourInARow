import optparse
import time
import ast

def removeCorrupts(inputfile, outputfile):
    lines=open(inputfile, 'r').readlines()
    lines_set = set(lines)
    out=open(outputfile, 'w')
    whowon = line.pop()
    games = 0
    for line in lines_set:
        aCount, bCount, cCount, dCount, eCount, fCount, gCount = 0,0,0,0,0,0,0
        x = ast.literal_eval(line)
        for i in range(len(x)):
            if x[i] == "a":
                aCount += 1
            elif x[i] == "b":
                bCount += 1
            elif x[i] == "c":
                cCount += 1
            elif x[i] == "d":
                dCount += 1
            elif x[i] == "e":
                eCount += 1
            elif x[i] == "f":
                fCount += 1
            elif x[i] == "g":
                gCount += 1
        if aCount > 6 or bCount > 6 or cCount > 6 or dCount > 6 or eCount > 6 or fCount > 6 or gCount > 6:
            pass
        elif (whowon == "p1"):
            out.write(line)
        elif (games%2 == 0):
            games += 1
            pass
        else:
            games += 1
            out.write(line)
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
            removeCorrupts(inputfile, outputfile)
            print(time.time() - start_time , " sec")

if __name__ == '__main__':
        main()
