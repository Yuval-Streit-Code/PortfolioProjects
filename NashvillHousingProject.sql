--DATA CLEANING 

SELECT * 
FROM PortfolioProject..NashvilleHousing

--changing date format------------------------------------------------------------------------------------

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--change property address data----------------------------------------------------------------------------------------------------------------------

SELECT *
FROM PortfolioProject..NashvilleHousing
where PropertyAddress is null

SELECT *
FROM PortfolioProject..NashvilleHousing
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--breaking address in to colums-----------------------------------------------------------------------------------------------------------------------

select PropertyAddress
from PortfolioProject..NashvilleHousing

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1 )

alter table NashvilleHousing
add PropertySplitcity nvarchar(255);

Update NashvilleHousing
SET PropertySplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress))

select * 
from PortfolioProject..NashvilleHousing



select OwnerAddress 
from PortfolioProject..NashvilleHousing

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
from PortfolioProject..NashvilleHousing


alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

alter table NashvilleHousing
add OwnerSplitcity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitcity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

alter table NashvilleHousing
add OwnerSplitstate nvarchar(255);

Update NashvilleHousing
SET OwnerSplitstate = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

select * 
from PortfolioProject..NashvilleHousing

--change Y/N in "sold as vacent"----------------------------------------------------------------------------------------

select Distinct ( SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,CASE when SoldAsVacant = 'Y' THEN 'Yes'
	  when SoldAsVacant = 'N' THEN 'No'
	  else SoldAsVacant
	  end
from PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	  when SoldAsVacant = 'N' THEN 'No'
	  else SoldAsVacant
	  end

--remove duplicates -----------------------------------------------------------------------------------------------------

WITH RowNumCTE AS(
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
from PortfolioProject..NashvilleHousing
--order by ParcelID
)
select * 
from RowNumCTE
where row_num > 1
order by PropertyAddress

--DELETE
--from RowNumCTE
--where row_num > 1


--Delete unused coloms--------------------------------------------------------------------------------------------

select * 
from PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, propertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate
