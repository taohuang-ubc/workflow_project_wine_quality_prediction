# Docker file for DSCI_522_GROUP_311
# 
# January 2020

# Use continuumio/anaconda3 as base image
FROM continuumio/anaconda3 

# Install base R
RUN apt-get update && \
    apt-get install r-base r-base-dev -y && \
    apt-get install libcurl4-openssl-dev -y && \
    apt-get install libssl-dev -y

# install python packages   
RUN conda install requests 
RUN conda install numpy 
RUN conda install pandas 
RUN conda install altair -y 
RUN conda install pyjanitor -c conda-forge -y
RUN conda install scikit-learn
RUN conda install docopt

# Install R Packages
RUN Rscript -e "install.packages('testthat')" 
RUN Rscript -e "install.packages('docopt')"
RUN Rscript -e "install.packages('knitr')"
RUN Rscript -e "install.packages('tidyverse')"
RUN Rscript -e "install.packages('janitor')"
RUN Rscript -e "install.packages('reshape2')"
RUN Rscript -e "install.packages('virdis')"
RUN Rscript -e "install.packages('caret')"
RUN Rscript -e "install.packages('viridis')"

# some extra python packages
RUN conda install selenium

# Install chromium and chromedriver
RUN apt install -y chromium && apt-get install -y libnss3 && apt-get install unzip

RUN wget -q "https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /usr/bin/ \
    && rm /tmp/chromedriver.zip && chown root:root /usr/bin/chromedriver && chmod +x /usr/bin/chromedriver

# Put Anaconda Python in PATH
ENV PATH="/opt/conda/bin:${PATH}"

CMD ["/bin/bash"]