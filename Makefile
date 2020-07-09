# wine quality data pipe
# author: Group 311 - Tao Huang, Xugang(Kirk) Zhong, Hanying Zhang
# date: 2020-01-30
# This Makefile helps you reproduce our analysis easily.

all: results/quality_value_distribution.png results/feature_distributions.png results/feature_correlation_heatmap.png doc/wine_quality_eda.md results/ranked_features.png results/feature_weight_plot.png results/prediction_result.png doc/report.md

# download data from the url
data/raw/red_wine.csv: src/data_download.py
	python src/data_download.py --url=https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv --filepath=data/raw --filename=red_wine

# process data and split the data into training set (X_train and y_train), and test set (X_test and y_test)
data/processed/X_train.csv data/processed/X_test.csv data/processed/y_train.csv data/processed/y_test.csv: src/data_process.py data/raw/red_wine.csv
	python src/data_process.py --filepath=data/raw/red_wine.csv --output_path=data/processed

# generate exploratory data analysis report
results/quality_value_distribution.png results/feature_distributions.png results/feature_correlation_heatmap.png: src/plot_create.r data/processed/X_train.csv data/processed/y_train.csv
	Rscript src/plot_create.r --x_train=data/processed/X_train.csv --y_train=data/processed/y_train.csv --output=results

doc/wine_quality_eda.md: doc/wine_quality_eda.Rmd doc/ref.bib
	Rscript -e "rmarkdown::render('doc/wine_quality_eda.Rmd')"

# perform analysis and predict on the data
results/ranked_features.png results/feature_weight_plot.png results/prediction_result.png: src/analysis.py data/processed/X_train.csv data/processed/y_train.csv data/processed/X_test.csv data/processed/y_test.csv
	python src/analysis.py --input=data/processed --output=results

# generate the final report
doc/report.md: doc/report.Rmd doc/ref.bib
	Rscript -e "rmarkdown::render('doc/report.Rmd')"

clean: 
	rm -rf data/*
	rm -rf results/*.png
	rm -rf doc/report.md doc/wine_quality_eda.md