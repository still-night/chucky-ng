FROM neepl/joern
RUN python -m pip install pip --upgrade \ 
	&& pip2.7 install numpy scipy scikit-learn \ 
	&& rm -r ~/.cache/pip 
COPY chucky /chucky 
VOLUME /code
WORKDIR /code
ENV NEO4J_HOME=/var/lib/neo4j CHUCKY_HOME=/chucky JOERN_HOME=/joern 
COPY script /bin
RUN	/bin/chucky_docker_init.sh 
#	export PATH=/chucky/script:$PATH \
#	&&ln -s $NEO4J_HOME/bin/neo4j /bin/neo4j \ 
#	&& echo 'java -jar $JOERN_HOME/bin/joern.jar $@' > /bin/joern && chmod +x /bin/joern \ 
#	&& echo 'python $CHUCKY_HOME/chucky.py $@' > /bin/chucky && chmod +x /bin/chucky \
#	&& echo '(ls .joernIndex 2 >/dev/null && rm -rf .joernIndex ||echo "not exist .joernIndex") && joern . ' > /bin/run_joern && chmod +x /bin/run_joern\
#	&& echo -e '#!/bin/bash\nrun_joern && neo4j start ; chucky $@ ' > /bin/run_chucky && chmod +x /bin/run_chucky 
ENTRYPOINT ["/bin/run_chucky.sh"]
CMD ["-n","10"] 
#ENTRYPOINT ["/bin/echo","Hello"]
#CMD ["world"] 

# EXPOSE 7474



