# Heart Disease Data Cleaning and Visualization

This repository contains SQL scripts for data cleaning operations and Python scripts for data visualization, specifically tailored for a heart disease dataset.

## SQL Data Cleaning

The SQL scripts perform various data cleaning steps on the `heart_disease` table. These scripts update missing values with either calculated values or random assignments based on the existing data distributions. It includes setting binary values for certain conditions, imputing null values, and adjusting data based on correlations found between variables.

### Steps to run the SQL scripts:

1. Ensure you have SQLite installed and set up on your machine.
2. Open your SQLite interface and connect to your database.
3. Execute the provided SQL scripts in the order they are provided.
4. Ensure you have a backup of your database before running these scripts, as they will modify your data.

## Python Data Visualization

The Python scripts use the pandas and matplotlib libraries to create scatter plots and box plots for various variables in the dataset. These visualizations aim to identify relationships between variables and spot outliers or unusual distributions.

### Requirements:

- Python 3
- Pandas library
- Matplotlib library

### Steps to run the Python scripts:

1. Ensure you have the required Python libraries installed.
2. Place the `cleanheart_disease.csv` dataset in the same directory as the script.
3. Run the script using Python. 

## Pseudo Code for Visualization

For each pair of variables specified for scatter plots:
1. Drop rows with null values in the current pair of columns.
2. Create a scatter plot with the first variable on the x-axis and the second variable on the y-axis.
3. Display the plot.

For each variable specified for box plots:
1. Drop rows with null values in the current column.
2. Create a box plot for the variable.
3. Display the plot.

## Sample Output

The output of these scripts will be graphical plots displayed on the screen. Sample screenshots of these plots are included in the repository under the `output_samples` directory.

