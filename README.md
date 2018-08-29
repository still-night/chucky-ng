chucky-ng
==============

Chucky new generation

Docker run method
--
  1. generate joern database  
   `docker run --rm -v /path/to/source/code:/code imakar/chucky joern . ` 
  2. run chucky check   
   `docker run --rm -v /path/to/source/code:/code imakar/chucky run_chucky [chucky parameters]`

Introduction
--
This program implements the missing check detection method named "Chucky".
Chucky statically taints source code and identifies anomalous or missing conditions linked to security-critical objects.
Chucky analyzes functions for anomalies. To this end, the usage of symbols
used by a function is analyzed by comparing the checks used in conjunction
with the symbol with those used in similar functions. Consult [here](http://chucky.readthedocs.org/) for more detail document.

Dependencies
--
+ joern >= 2.0 <https://github.com/fabsx00/joern>
+ joern-tools >=0.1 <https://github.com/fabsx00/joern-tools>
+ Neo4j >=1.9 <http://www.neo4j.org>
+ Python 2.7

This version is for Debian & Ubuntu Linux only.

Fetch and Installation
--
Run the following command in the terminal:
From GIT repository first run

    $ sudo apt-get install git #skip this command if you have git already installed
    $ git clone https://github.com/yangke/chucky-ng.git
    
Usage
--
Suppose we have already parse the code and we have configured and started the neo4j database service.
(For parsing the code and database configuration please refer to the [document](http://joern.readthedocs.org/en/latest/) of [joern](https://github.com/fabsx00/joern). Don't worry, the Following quick start example will also mention a little about this.)

    $ cd chucky-ng/chucky
    $ python chucky.py  [-h] [-f FUNCTION] [--callee CALLEES [CALLEES ...]]
                 [-p PARAMETERS [PARAMETERS ...]]
                 [-var VARIABLES [VARIABLES ...]] -n N_NEIGHBORS
                 [-c CHUCKY_DIR] [-o OUTPUT_REPORT_DIRECTORY] [-r]
                 [--interactive] [-l LIMIT] [-d | -v | -q]
Example 1: 

    $ python chucky.py --parameter length -n 25 --interactive 
    
Example 2: 

    $ python chucky.py --p length --callee png_free --var slength -n 3 -l png_handle_sCAL -r
    
positional arguments:

    identifier          The name of the identifier (function name or
                        source/sink name)

optional arguments:

    -h, --help          show this help message and exit
    -f FUNCTION, --function FUNCTION
                        Specify the function to analysis. If this option is
                        configured, the analysis will only perform on this
                        function.
    -n N_NEIGHBORS, --n-neighbors N_NEIGHBORS
                        Number of neighbours to consider for neighborhood
                        discovery.
    -c CHUCKY_DIR, --chucky-dir CHUCKY_DIR
                        The directory holding chucky's data such as cached
                        symbol embeddings and possible annotations of sources
                        and sinks.
    -o OUTPUT_REPORT_DIRECTORY, --output-report-directory OUTPUT_REPORT_DIRECTORY
                        The report output directory of chucky. For each target
                        function under analyzationthe. Chucky will generate a
                        detail report.
    -r, --report          Output the detail report for each function under
                        analyzation.

    --interactive         Enable interactive mode.
    -l LIMIT, --limit LIMIT
                        Limit analysis to functions with given name
    -d, --debug         Enable debug output.
    -v, --verbose       Increase verbosity.
    -q, --quiet         Be quiet during processing.
    
source_sinks:

    --callee CALLEES [CALLEES ...]
                        Specify the identifier name of callee type source/sink
    -p PARAMETERS [PARAMETERS ...], --parameter PARAMETERS [PARAMETERS ...]
                        Specify the identifier name of parameter type
                        source/sink
    -var VARIABLES [VARIABLES ...], --variable VARIABLES [VARIABLES ...]
                        Specify the identifier name of variable type
                        source/sink
    
    
A Quick Start Example.
--
Suppose we are the planning to analyse the code of image processing library LibPNG(version 1.2.44).
Download and extract the the source code of libPNG.

    $ wget http://sourceforge.net/projects/libpng/files/libpng12/older-releases/1.2.44/libpng-1.2.44.tar.gz/download
    $ tar xvzf libpng-1.2.44.tar.gz
Generate the graph database.

    $ joern libpng-1.2.44
    
A hidden directory .joernIndex will be generated under the current directory(suppose it is $TEST).

Configure the graph database server [Neo4j](http://www.neo4j.org/).

Assume $NEO4J_HOME is the install directory of your Neo4j(Note that current joern only support 1.9.* version serials).
Edit the file $NEO4J_HOME/conf/server.properties.
Take neo4j-1.9.7 as an example, you should open the file neo4j-1.9.7/conf/neo4j-server.properties.
Then change 

    #org.neo4j.server.database.location=data/graph.db
to 

    #org.neo4j.server.database.location=$TEST/.joernIndex
and save it.
Start Neo4j database. 

    $ $NEO4J_HOME/bin/neo4j start
Go to your chucky directory(chucky-ng/chucky) and run a chucky analysis.

    $python chucky.py --parameter length -n 25 |sort -r -k 1

Then Chucky will generate the report to the screen.

    0.88	0.35	png_handle_hIST  	length	0.60	0.87	libpng-1.2.44/pngrutil.c:1509
    0.88	0.34	png_handle_pCAL  	length	0.62	1.05	libpng-1.2.44/pngrutil.c:1650
    0.88	0.32	png_handle_sCAL  	length	0.63	0.87	libpng-1.2.44/pngrutil.c:1784
    0.88	0.02	png_write_chunk_start	length	0.98	0.81	libpng-1.2.44/pngwutil.c:98
    0.88	0.01	process_data     	length	0.98	0.81	libpng-1.2.44/example.c:456
    0.52	0.25	png_handle_IEND  	png_ptr -> mode	0.52	0.45	libpng-1.2.44/pngrutil.c:649
    0.52	0.24	png_handle_sBIT  	png_ptr -> mode	0.54	0.47	libpng-1.2.44/pngrutil.c:752
    0.52	0.23	png_handle_gAMA  	png_ptr -> mode	0.56	0.45	libpng-1.2.44/pngrutil.c:671
    0.52	0.21	png_handle_pHYs  	png_ptr -> mode	0.60	0.45	libpng-1.2.44/pngrutil.c:1563
    0.52	0.20	png_handle_tIME  	png_ptr -> mode	0.62	0.45	libpng-1.2.44/pngrutil.c:1940
    ...

Following table explains some of the key column.

| column 1      |column 2        |column3               | column 4		            | column 5               | column 6               |  column 7                                 |  
| ------------- |:--------------:|:--------------------:|:-------------------------:|:----------------------:|:----------------------:|:-----------------------------------------:|
| anomaly score | anomaly_score* |function name         | sinificant missing symbol | mean cosine distance   |specificity             |   location  |
| 0.88000       | 0.32           |png\_handle\_sCAL     | length                    | 0.63                   |0.87                    |libpng-1.2.44/pngrutil.c:1784:0:52039:56355|

For the vulnerable function **png\_handle\_sCAL** as reported in CVE-2011-2692, we can see from the result that it is ranked in top 5(all the top 5 functions have the highest anomaly score 0.88).
This is because most of the similar functions(the first column shows the percentage) perform the check for the parameter **length**, howerver, **png\_handle\_sCAL** doesn't check it. We call these functions neighborhoods of  **png\_handle\_sCAL**.
Chucky is a efficient tool for checking such statistically significant missing case. 

For the orginal idea, you can refer to [Chucky: Exposing Missing Checks in Source Code for Vulnerability Discovery](http://user.informatik.uni-goettingen.de/~fyamagu/pdfs/2014-oakland.pdf)
 Fabian Yamaguchi, Christian Wressnegger, Hugo Gascon, and K. Rieck
*ACM Conference on Computer and Communications Security (CCS)*

This modified version of Chucky is based on the [original version](https://github.com/a0x77n/chucky-ng) written by Alwin Maier and [Fabian Yamaguchi](http://codeexploration.blogspot.de/).

About the Modification.
--
1. Refactor to clean the middle code.
    * Replace sally embedding module by pure python(transplant the code witten by Fabian) to remove the data exchange cost on disk.
    * Fix some bug and make it more robust.
2. Rewirte the KNN class to support the neighborhood selection strategy:
    * Leverage name(file name or function name) information and caller set information when it's usefull.
    * Kick out some name irrelevant functions, and set a robust multiselective threshold for the recomandation of good candidate.
3. Add multi-source/sink support.
    * Design a new option set for user to specify the multi-source/sink.
    * Use the combination of source/sink as the key feature to find candidate neighborhood.
    * Use the union of the tainted condition features as the condition embedding feature.
    * Refactor the job generation.
4. Add a report module to show the detail report.

For more information or bug report please do not hesitate to contact me. Ke Yang(123yangke321@sina.com) 
 
Still trying to update the wiki document.

  
