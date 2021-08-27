import csv

class Parser():
    
    def __init__(self, srcPath):
        self.srcPath = srcPath
        self.filename = srcPath.split('.')[0]  
        
    def analyseLines(self, lines):
        cols = len(lines[0])
        correct_lines = [ l for l in lines if len(l)==cols]
        wrong_lines = [l for l in lines if len(l) != cols]
        
        return correct_lines, wrong_lines

    def readTSV(self):
        with open(self.srcPath,'rb') as tsv_file:
            self.lines = tsv_file.read().decode("utf-16-le").encode("utf-8")
        return

    def convertTSVtoCSV(self):
        lines = [l.split('\t') for l in self.lines.split('\n')]
        self.lines, self.wrong_lines = self.analyseLines(lines)
        return
    
    def exportCSV(self, dstPath=None, expWrongLines=False, errPath=None):
        
        if dstPath == None:
            dstPath='{0}.csv'.format(self.filename)
        
        with open(dstPath, 'wb') as f:
            write = csv.writer(f, delimiter='|')
            write.writerows(self.lines)
        
        if expWrongLines:
            with open(errPath, 'wb') as f:
                write = csv.writer(f, delimiter='|')
                write.writerows(self.wrong_lines)
        return

    def runParser(self, output_path=None):
        self.readTSV()
        self.convertTSVtoCSV()
        self.exportCSV(output_path)
        return
                    