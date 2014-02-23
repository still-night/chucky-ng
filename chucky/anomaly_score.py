#!/usr/bin/env python2

from joerntools.shelltool.PipeTool import PipeTool
from joerntools.mlutils.EmbeddingLoader import EmbeddingLoader

import scipy.sparse
import sys

DESCRIPTION = """ Calculates the center of mass of the given embedding
and returns the distance of every input line """

DEFAULT_DIRNAME = 'embedding'

class AnomalyScore(PipeTool):
    
    def __init__(self):
        PipeTool.__init__(self, DESCRIPTION)
        self.loader = EmbeddingLoader()

        self.argParser.add_argument('-d', '--dirname', nargs='?',
                                    type = str, help="""The directory containing the embedding""",
                                    default = DEFAULT_DIRNAME)

    def _loadEmbedding(self, dirname):
        try:
            return self.loader.load(dirname)
        except IOError:
            sys.stderr.write('Error reading embedding.\n')
            sys.exit()

    # @Override
    def streamStart(self):
        self.emb = self._loadEmbedding(self.args.dirname)

    # @Override
    def processLine(self, line):
    	try:
            dataPointIndex = self.emb.rTOC[line]
        except KeyError:
            sys.stderr.write('Warning: no data point found for %s\n' % (line))
    	
    	return self.calculateDistance(dataPointIndex)
    	
    def calculateDistance(self, index):
    	 if not self.emb.dExists():
            self.emb.D = self.calculateCenterOfMass()
         print max((self.emb.D - self.emb.x[index]).data)

    def calculateCenterOfMass(self):
       	return  scipy.sparse.csr_matrix(self.emb.x.mean(axis=0))


if __name__ == '__main__':
    tool = AnomalyScore()
    tool.run()
