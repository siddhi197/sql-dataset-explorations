/*
Cleaning Data in SQL Queries
*/


Select 
      *
From 
      `light-sunup-366114.PortfolioProject.NashvilleHousing` 

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- BigQuery (Convert Function doesn't work)
SELECT 
      SaleDate,
      CAST(SaleDate AS DATE FORMAT 'MONTH DD, YYYY') AS SaleDateConverted
FROM
      `light-sunup-366114.PortfolioProject.NashvilleHousing` 


 --------------------------------------------------------------------------------------------------------------------------
 
 
 -- Populate Property Address data
 
Select 
     *
From 
     `light-sunup-366114.PortfolioProject.NashvilleHousing`
ORDER BY 
     ParcelID
     
     
      
 SELECT 
     a.ParcelID, 
     a.PropertyAddress,
     b.ParcelID,
     b.PropertyAddress,
     IFNULL(a.PropertyAddress, b.PropertyAddress) 
FROM
     `light-sunup-366114.PortfolioProject.NashvilleHousing` a
JOIN
     `light-sunup-366114.PortfolioProject.NashvilleHousing` b
ON
     a.ParcelID = b.ParcelID
   AND 
     a.UniqueID_ <> b.UniqueID_
WHERE 
     a.PropertyAddress IS NULL
     

UPDATE a
SET PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress) 
FROM
     `light-sunup-366114.PortfolioProject.NashvilleHousing` a
JOIN
     `light-sunup-366114.PortfolioProject.NashvilleHousing` b
ON
     a.ParcelID = b.ParcelID
   AND 
     a.UniqueID_ <> b.UniqueID_
WHERE 
     a.PropertyAddress IS NULL

      
      
--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT
    PropertyAddress,
    SUBSTRING(PropertyAddress, 1, STRPOS(PropertyAddress, ',')-1) AS StreetAddress,
    LTRIM(SUBSTRING(PropertyAddress, STRPOS(PropertyAddress,',')+1, LENGTH(PropertyAddress))) AS City
FROM
    PortfolioProject.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertyStreettAddress STRING

UPDATE NashvilleHousing
SET PropertyStreetAddress = SUBSTRING(PropertyAddress, 1, STRPOS(PropertyAddress, ',')-1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity STRING

UPDATE NashvilleHousing
SET PropertySplitCity = LTRIM(SUBSTRING(PropertyAddress, STRPOS(PropertyAddress,',')+1, LENGTH(PropertyAddress)))




SELECT 
      OwnerAddress
FROM
      `light-sunup-366114.PortfolioProject.NashvilleHousing` 


SELECT 
      OwnerAddress,
      SPLIT(OwnerAddress, ',') [OFFSET(0)] AS OwnerStreetAddress,
      SPLIT(OwnerAddress, ',') [OFFSET(1)] AS OwnerCity,
      SPLIT(OwnerAddress, ',') [OFFSET(2)] AS OwnerState
FROM
      `light-sunup-366114.PortfolioProject.NashvilleHousing` 


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress STRING;

UPDATE NashvilleHousing
SET OwnerSplitAddress = SPLIT(OwnerAddress, ',') [OFFSET(0)]


ALTER TABLE NashvilleHousing
Add OwnerSplitCity STRING;

UPDATE NashvilleHousing
SET OwnerSplitCity = SPLIT(OwnerAddress, ',') [OFFSET(1)]



ALTER TABLE NashvilleHousing
Add OwnerSplitState STRING;

UPDATE NashvilleHousing
SET OwnerSplitState = SPLIT(OwnerAddress, ',')[OFFSET(2)]

Select 
     *
From 
     PortfolioProject.NashvilleHousing
     
     
     
--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select 
     Distinct(SoldAsVacant), 
     Count(SoldAsVacant)
From PortfolioProject.NashvilleHousing
Group by SoldAsVacant
order by 2




Select 
     SoldAsVacant,
     CASE When SoldAsVacant = 'Y' THEN 'Yes'
	     When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END








-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select 
     *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.NashvilleHousing
)
DELETE *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.NashvilleHousing


ALTER TABLE PortfolioProject.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate








     

 
 
