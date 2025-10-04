Select *
from [Portfolio Project]..NashvilleHousing$


--Standardize the Sale Date format

select SaleDate , CONVERT(Date,SaleDate) as Sale_and_date_only
from [Portfolio Project]..NashvilleHousing$

ALTER TABLE NashvilleHousing$
Add saledateconverted Date;

update NashvilleHousing$
SET saledateconverted = convert(date,saledate)


select saledateconverted
from  [Portfolio Project]..NashvilleHousing$



--Populate Property Address Data

Select PropertyAddress
from [Portfolio Project]..NashvilleHousing$
where PropertyAddress is null

select *
from [Portfolio Project]..NashvilleHousing$
order by ParcelID

Select one.ParcelID, one.PropertyAddress,two.ParcelID,two.PropertyAddress,ISNULL(one.propertyaddress,two.PropertyAddress) as PropertyAddressNew
from [Portfolio Project]..NashvilleHousing$ one
JOIN [Portfolio Project]..NashvilleHousing$ two
ON one.ParcelID =two.ParcelID
and one.[UniqueID ] <> two.[UniqueID ]
where one.PropertyAddress is null

update one
set PropertyAddress = isnull(one.propertyaddress,two.PropertyAddress)
from [Portfolio Project]..NashvilleHousing$ one
join [Portfolio Project]..NashvilleHousing$ two
on one.ParcelID = two.ParcelID
and one.[UniqueID ]<> two.[UniqueID ]
where one.PropertyAddress is null


-- Breaking Out Addresses Into Individual Columns i.e Address, City, State

select propertyaddress
from [Portfolio Project]..NashvilleHousing$

Select
SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1) as address
, SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1, LEN(PropertyAddress)) as address

from [Portfolio Project]..NashvilleHousing$

ALTER TABLE NashvilleHousing$
add propertysplitaddress Nvarchar(250);

update NashvilleHousing$
Set propertysplitaddress = SUBSTRING(PropertyAddress, 1, charindex(',' ,PropertyAddress) -1)

ALTER TABLE NashvilleHousing$
add PropertySplitCity Nvarchar(250);

Update NashvilleHousing$
SET propertysplitcity = SUBSTRING(PropertyAddress, charindex(',',propertyaddress)+1, LEN(PropertyAddress))

select *
from NashvilleHousing$

--Separating Address, city and State

SELECT Owneraddress
from [Portfolio Project]..NashvilleHousing$

Select
Parsename(REPLACE(owneraddress,',','.'), 3)
,Parsename(REPLACE(owneraddress,',','.'), 2)
,Parsename(REPLACE(owneraddress,',','.'), 1)
from [Portfolio Project]..NashvilleHousing$


ALTER TABLE NashvilleHousing$
ADD ownersplitaddress Nvarchar(250);

UPDATE NashvilleHousing$
SET ownersplitaddress = Parsename(REPLACE(owneraddress,',','.'), 3)


ALTER TABLE NashvilleHousing$
ADD the_city nvarchar(250);

UPDATE NashvilleHousing$
set the_city = Parsename(REPLACE(owneraddress,',','.'), 2)


ALTER TABLE NashvilleHousing$
add the_state nvarchar(240);


update NashvilleHousing$
set the_state = Parsename(REPLACE(owneraddress,',','.'), 1)

SELECT *
From [Portfolio Project]..NashvilleHousing$

--Changing Y and N to Yes and No in the 'Sold as Vacant' field

select distinct(SoldAsVacant)
from [Portfolio Project]..NashvilleHousing$


Select soldasvacant
, CASE when soldasvacant = 'Y' THEN 'Yes'
      when soldasvacant= 'N' THEN 'No'
	  ELSE soldasvacant
	  END
from [Portfolio Project]..NashvilleHousing$


UPDATE NashvilleHousing$
SET SoldAsVacant = CASE when soldasvacant = 'Y' THEN 'Yes'
      when soldasvacant= 'N' THEN 'No'
	  ELSE soldasvacant
	  END

Select *
from [Portfolio Project]..NashvilleHousing$


--Remove Duplicates 

WITH RowNumCTE AS (

Select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID, propertyaddress,saleprice,saledate,legalreference
	order by uniqueid) row_num

from [Portfolio Project]..NashvilleHousing$
)

--Delete Unused Columns 

Delete 
from RowNumCTE
where row_num > 1

ALTER TABLE NashvilleHousing$
DROP COLUMN OwnerAddress,TaxDistrict

ALTER TABLE NashvilleHousing$
DROP COLUMN SaleDate
