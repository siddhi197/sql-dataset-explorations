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
