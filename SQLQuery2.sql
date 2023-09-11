--Cleaning Data in SQL Queries



Select *
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]

-- Standardize Date Format


Select SaleDateConverted, CONVERT(Date, SaleDate)
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]


Update [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
Add SaleDateConverted Date;

Update [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
SET SaleDateConverted = CONVERT(Date,SaleDate)


--Removing the Saledate column

ALTER TABLE [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
Drop SaleDateConverted;

 -- Populate Property Address data

Select *
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning] a
JOIN [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning] a
JOIN [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]


ALTER TABLE [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
Add PropertyAddress1 Nvarchar(255);

Update [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
SET PropertyAddress1 = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
Add PropertyAddress2 Nvarchar(255);

Update [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
SET PropertyAddress2 = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]





Select OwnerAddress
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]



ALTER TABLE [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
Add OwnerAddress1 Nvarchar(255);

Update [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
SET OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
Add OwnerAddress2 Nvarchar(255);

Update [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
SET OwnerAddress2 = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
Add OwnerAddress3 Nvarchar(255);

Update [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
SET OwnerAddress3 = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]




-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]


Update [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDateConverted,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [Kim'sSQL].[dbo].[NashVille Housing Data Cleaning]
