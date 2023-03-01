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

      
     

 
 
