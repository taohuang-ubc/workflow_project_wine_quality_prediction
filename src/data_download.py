# author: Group 311 - Tao Huang, Xugang(Kirk) Zhong, Hanying Zhang
# date: 2020-01-19

'''This script downloads data file from a url and writes it to local. 
This script takes a URL and a local file path as the arguments.
The URL used for this file should be ended with '.csv', here is an example: 
"https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv"

Usage: src/data_download.py --url=<url> --filepath=<filepath> --filename=<filename>

Options:
--url=<url>              URL from where to download the data. This link should be ended with '.csv', eg. "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv"
--filepath=<filepath>    Local file path to write the data file. The path should not contain any filename or a "/" at the end, eg. "data/raw"
--filename=<filename>    Local file name. This filename should not include any extension, here is an example: "red_wine"
'''

import pandas as pd
import requests
import os
from docopt import docopt

opt = docopt(__doc__)

def main(url, filepath, filename):
    try: 
        request = requests.get(url, stream=True)
        request.status_code == 200 # successful request
    except Exception as ex:
        print("URL does not exist.")
        print(ex)

    filepath_long = filepath + "/" + filename + ".csv"
    assert url[-4:] == '.csv', "The URL must point to a csv file!"

    # check file path
    if not os.path.exists(filepath):
        os.makedirs(filepath)

    # download csv file from url
    try: 
        data = pd.read_csv(url, sep=";")
        data.to_csv(filepath_long, index=False)
    except Exception as e:
        print("Unable to download. Please check your URL again to see whether it is pointing to a downloadable file.")
        print(e)

if __name__ == "__main__":
    main(opt["--url"], opt["--filepath"], opt["--filename"])
