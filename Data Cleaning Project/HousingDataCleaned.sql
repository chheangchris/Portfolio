-- display all data in table

Select *
From PortfolioProjects.dbo.HousingData

-- format the data because the time is irrelavent 
	
Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProjects.dbo.HousingData

Update HousingData
SET SaleDate = CONVERT(Date,SaleDate)

-- cleaning property address by populating null values

Select PropertyAddress
From PortfolioProjects.dbo.HousingData
Where PropertyAddress is null

-- using a self join to make it fill the nulls if they have the same parcelID
	
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjects.dbo.HousingData a
JOIN PortfolioProjects.dbo.HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjects.dbo.HousingData a
JOIN PortfolioProjects.dbo.HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

-- Split the address from the city
	
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From PortfolioProjects.dbo.HousingData


ALTER TABLE HousingData
Add PropertySplitAddress NvarChar(255);

Update HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) 

ALTER TABLE HousingData
Add PropertySplitCity NvarChar(255);

Update HousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress))

-- Split the owner address into 3 columns. Street, City, State

Select
PARSENAME(REPLACE(OwnerAddress,',','.') , 3)
,PARSENAME(REPLACE(OwnerAddress,',','.') , 2)
,PARSENAME(REPLACE(OwnerAddress,',','.') , 1)
From PortfolioProjects.dbo.HousingData

ALTER TABLE HousingData
Add OwnerSplitAddress NvarChar(255);

Update HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') , 3)

ALTER TABLE HousingData
Add OwnerSplitCity NvarChar(255);

Update HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') , 2)

ALTER TABLE HousingData
Add OwnerSplitState NvarChar(255);

Update HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') , 1)

-- changning the SoldAsVacant to make it easier to read

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProjects.dbo.HousingData
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes' 
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProjects.dbo.HousingData


Update HousingData
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes' 
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- removing duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProjects.dbo.HousingData

)
DELETE
From RowNumCTE
Where row_num > 1

-- Dropping unnecessary data

ALTER TABLE PortfolioProjects.dbo.HousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

