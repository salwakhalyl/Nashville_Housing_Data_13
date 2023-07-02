# Nashville_Housing_Data_13

This dataset contains information on housing data in the Nashville, TN area. I used SQL Server to clean the data to make it easier to use.

The steps i followed are :

1. Change the Sale Date column type from datetime to date and update the table.
2. Populate Property Address Data for NULL Values and update the table.
3. Breaking out Addresses into Individual Columns (Address, City, State) and update the table.
4. Check Sols As Vacant column and change "N" to "NO" ,"Y" to "YES".
5. Remove Duplicates and delete unused columns
