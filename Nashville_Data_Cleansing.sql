--I-Check the columns name and data types

SELECT *
FROM Portfolio.dbo.Nashville_Data

--II- Dealing with Saledate column
----1- Let's change the Sale Date column type from datetime to date

SELECT CAST(SaleDate AS date) 
FROM Portfolio.dbo.Nashville_Data

----2- Add a column named Sale_Date_Updated

ALTER TABLE Portfolio.dbo.Nashville_Data
ADD Sale_Date_Updated date

UPDATE Portfolio.dbo.Nashville_Data
SET Sale_Date_Updated = CAST(SaleDate AS date)


--III- Dealing with NULL data
-----1- Cheking if Property Address column has any NULL values

SELECT *
FROM Portfolio.dbo.Nashville_Data
WHERE PropertyAddress IS NULL

----2-Populate Property Address Data for NULL Values

SELECT a.ParcelID , b.ParcelID , a.PropertyAddress , b.PropertyAddress , ISNULL(a.PropertyAddress , b.PropertyAddress)
FROM Portfolio.dbo.Nashville_Data a
JOIN Portfolio.dbo.Nashville_Data b 
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress , b.PropertyAddress)
FROM Portfolio.dbo.Nashville_Data a
JOIN Portfolio.dbo.Nashville_Data b 
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL 

--IV- Breaking out Addresses into Individual Columns (Address, City, State)
----1-Breaking out Property Address (Address, City)

SELECT *
FROM Portfolio.dbo.Nashville_Data

ALTER TABLE Portfolio.dbo.Nashville_Data
ADD PropertyAddress_Upd NVARCHAR(200) ,  PropertyCity_Upd NVARCHAR(200)

UPDATE Portfolio.dbo.Nashville_Data
SET PropertyAddress_Upd = PARSENAME(Replace(PropertyAddress, ',', '.'), 2),
    PropertyCity_Upd = PARSENAME(Replace(PropertyAddress, ',', '.'), 1)

----2-Breaking out Owner Address(Address, City, State)

SELECT *
FROM Portfolio.dbo.Nashville_Data

ALTER TABLE Portfolio.dbo.Nashville_Data
ADD OwnerAddress_Upd NVARCHAR(200) ,  OwnerCity_Upd NVARCHAR(200) ,  OwnerState_Upd NVARCHAR(200)

UPDATE Portfolio.dbo.Nashville_Data
SET OwnerAddress_Upd = PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
    OwnerCity_Upd = PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
    OwnerState_Upd = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)

--V- Check Sols As Vacant column

SELECT DISTINCT SoldAsVacant
FROM Portfolio.dbo.Nashville_Data 

----1- Let's change "N" to "NO" and "Y" to "YES"


UPDATE Portfolio.dbo.Nashville_Data 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'N' THEN 'NO'
	                    WHEN SoldAsVacant = 'Y' THEN 'YES'
			            ELSE SoldAsvacant
			       END 

--VI- Remove Duplicates


WITH RowNumCTE AS (
SELECT *, ROW_NUMBER() OVER ( PARTITION BY ParcelID,
                                           PropertyAddress,
										   SaleDate,
										   LegalReference,
										   OwnerName,
										   OwnerAddress
							  ORDER BY     UNIQUEID
							  ) row_num
FROM Portfolio.dbo.Nashville_Data
                    )
DELETE
FROM RowNumCTE
WHERE row_num > 1
                         
--VII- Delete unused columns

SELECT *
FROM  Portfolio.dbo.Nashville_Data

ALTER TABLE Portfolio.dbo.Nashville_Data
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, taxDistrict





























