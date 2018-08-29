FROM neepl/joern
COPY chucky /chucky 
VOLUME /code
WORKDIR /code
ENV NEO4J_HOME=/var/lib/neo4j CHUCKY_HOME=/chucky JOERN_HOME=/joern
RUN python -m pip install pip --upgrade \ 
	&& pip2.7 install numpy scipy scikit-learn \ 
	&& rm -r ~/.cache/pip \ 
	&& ln -s $NEO4J_HOME/bin/neo4j /bin/neo4j \ 
	&& echo 'rm -r .joernIndex && java -jar $JOERN_HOME/bin/joern.jar $@' > /bin/joern && chmod +x /bin/joern \ 
	&& echo 'python $CHUCKY_HOME/chucky.py' > /bin/chucky && chmod +x /bin/joern 
# EXPOSE 7474


