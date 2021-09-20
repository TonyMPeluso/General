install.packages("sf")
install.packages("cancensus")
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("rsconnect")
library(sf)
library(cancensus)
options(cancensus.cache_path = "custom cache path")
options(cancensus.api_key = "CensusMapper_XXX")
library(tidyverse)
library(ggplot2)
library(rsconnect)

# The following commands list and output the variables in the census and tax datasets
# list_census_vectors(dataset='CA16')
# write_xlsx(list_census_datasets(), "datasets.xlsx")
# write_xlsx(list_census_vectors(dataset='CA16'), "vectorsCA16.xlsx")
# list_census_regions(dataset="TX2000")
# write_xlsx(list_census_vectors(dataset='TX2000'), "vectorsTX2000.xlsx")

# Defines vector and assings names variables of interest
census_vars <- c(
  pop_Tot ="v_CA16_401",	#Total	Population, 2016		
  dwell_Tot = "v_CA16_404",	#Total private dwellings		
  land_area = "v_CA16_407",	#Total	Land area in square kilometres		
  pop_0to14 = "v_CA16_4",	#Total	0 to 14 years	
  pop_15to19 ="v_CA16_64",	#Total	15 to 19 years
  pop_20to24 = "v_CA16_82",	#Total	20 to 24 years
  pop_65Plus = "v_CA16_244",	#Total	65 years and over
  pop_65to69 = "v_CA16_247",	#Total	65 to 69 years
  dwell_type_SingDet = "v_CA16_409",	#Total	Single-detached house	
  dwell_type_AppBldg5Plus = "v_CA16_410",	#Total	Apartment in a building that has five or more storeys	
  dwell_type_OtherAttch = "v_CA16_411",	#Total	Other attached dwelling	
  dwell_type_SemiDet = "v_CA16_412",	#Total	Semi-detached house	
  dwell_type_RowHouse = "v_CA16_413",	#Total	Row house	
  dwell_type_AppDuplex = "v_CA16_414",	#Total	Apartment or flat in a duplex	
  dwell_type_AppBldg5Minus = "v_CA16_415",	#Total	Apartment in a building that has fewer than five storeys	
  dwell_type_OtherSingleAtt = "v_CA16_416",	#Total	Other single-attached house	
  hh_demo_AverageSize = "v_CA16_425",	#Total	Average household size
  hh_demo_TotCensusFamMarStatus = "v_CA16_484",	#Total	Total number of census families in private households - 100% data
  hh_demo_TotCouples = "v_CA16_485",	#Total	Total couple families
  hh_demo_TotCensusFamChil = "v_CA16_491",	#Total	Total - Couple census families in private households - 100% data
  hh_demo_CouplesNoChildren = "v_CA16_492",	#Total	Couples without children
  hh_demo_CouplesWChildren = "v_CA16_493",	#Total	Couples with children
  hh_demo_TotLoneParents = "v_CA16_497",	#Total	Total - Lone-parent census families in private households - 100% data
  hh_Inc_TotHH = "v_CA16_2201",	#Total	Total - Income statistics in 2015 for the population aged 15 years and over in private households - 100% data
  hh_inc_MedIncRecipBefTax = "v_CA16_2207",	#Total	Median total income in 2015 among recipients ($)	Currency
  hh_inc_MedIncRecipAftTax = "v_CA16_2213",	#Total	Median after-tax income in 2015 among recipients ($)
  hh_inc_MedIncHHBefTax = "v_CA16_2397",	#Total	Median total income of households in 2015 ($)
  hh_inc_MedIncHHAftTax = "v_CA16_2398",	#Total	Median after-tax income of households in 2015 ($)
  hh_inc_AvgSizeEconFamily = "v_CA16_2449",	#Total	Average family size of economic families
  hh_tenure_TotHHByTenureSmpl = "v_CA16_4836",	#Total	Total - Private households by tenure - 25% sample data
  hh_tenure_NumbOwnerSmpl = "v_CA16_4837",	#Total	Owner
  hh_tenure_NumbRenterSmpl = "v_CA16_4838",	#Total	Renter
  hh_cond_TotCondoStatusSmpl = "v_CA16_4840", #	Total	Total - Occupied private dwellings by condominium status - 25% sample data
  hh_cond_CondoSmpl = "v_CA16_4841",	#Total	Condominium
  hh_cond_NotCondoSmpl = "v_CA16_4842",	#Total	Not condominium
  dwell_char_AvgRoomsSmpl = "v_CA16_4855",	#Total	Average number of rooms per dwelling	
  dwell_fin_NumbHHSmpl = "v_CA16_4890",	#Total	Total - Owner households in non-farm, non-reserve private dwellings - 25% sample data
  dwell_fin_MedSheltCostOwnedSmpl = "v_CA16_4893", #Total	Median monthly shelter costs for owned dwellings ($)
  dwell_fin_AvgSheltCostOwnedSmpl = "v_CA16_4894",	#Total	Average monthly shelter costs for owned dwellings ($)
  dwell_fin_MedValueOfDwellingSmpl = "v_CA16_4895", #Total	Median value of dwellings ($)
  dwell_fin_AvgValueOfDwellingSmpl = "v_CA16_4896", #Total	Average value of dwellings ($)
  dwell_fin_MedSheltCostRentSmpl = "v_CA16_4900",	#Total	Median monthly shelter costs for rented dwellings ($)
  dwell_fin_AvgSheltCostRentSmpl = "v_CA16_4901",	#Total	Average monthly shelter costs for rented dwellings ($)
  hh_educ_TotHighestDegreeSmpl = "v_CA16_5051",	#Total	Total - Highest certificate, diploma or degree for 
    #the population aged 15 years and over in private households - 25% sample data"
  hh_educ_TotUnivPlusSmpl = "v_CA16_5078",	#Total	University certificate, diploma or degree at bachelor level or above
  hh_educ_Bach = "v_CA16_5081",	#Total	Bachelor's degree
  hh_educ_AboveBach = "v_CA16_5084",	#Total	University certificate or diploma above bachelor level
  hh_educ_Med = "v_CA16_5087",	#Total	Degree in medicine, dentistry, veterinary medicine or optometry
  ###What of 5120..
  hh_TotalLabourForceSmpl = "v_CA16_5597",	#Total	Total - Population aged 15 years and over by Labour force status - 25% sample data
  hh_InLabourForceSmpl = "v_CA16_5600",	#Total	In the labour force
  hh_UnemployedSmpl = "v_CA16_5606",	#Total	Unemployed
  hh_WorkPlaceSmpl = "v_CA16_5762",	#Total	Total - Place of work status for the employed labour force aged 15 years and over in private households - 25% sample data
  hh_WorkAtHome = "v_CA16_5765",	#Total	Worked at home
  travel_dist_TotDestSmpl = "v_CA16_5777",	#Total	Total - Commuting destination for the employed labour force aged 15 years and over in private households with a usual place of work - 25% sample data
  traveL_dist_WithinCSDSmpl = "v_CA16_5780",	#Total	Commute within census subdivision (CSD) of residence
  traveL_dist_DiffCSDSameCDSmpl = "v_CA16_5783",	#Total	Commute to a different census subdivision (CSD) within census division (CD) of residence
  traveL_dist_DiffCSDDiffCDSmpl = "v_CA16_5786",	#otal	Commute to a different census subdivision (CSD) and census division (CD) within province or territory of residence
  traveL_dist_DiffProvSmpl = "v_CA16_5789",	#Total	Commute to a different province or territory
  traveL_mode_TotModeSmpl = "v_CA16_5792",	#Total	Total - Main mode of commuting for the employed labour force aged 15 years 
    #and over in private households with a usual place of work or no fixed workplace address - 25% sample data
  traveL_mode_CarEtcDriverSmpl = "v_CA16_5795",	#Total	Car, truck, van - as a driver
  traveL_mode_CarEtcPassSmpl = "v_CA16_5798",	#Total	Car, truck, van - as a passenger
  traveL_mode_PublicTransSmpl = "v_CA16_5801",	#Total	Public transit
  traveL_time_TotCommuteTimeSmpl = "v_CA16_5813",	#Total	Total - Commuting duration for the employed labour force aged 15 years and over in 
    #private households with a usual place of work or no fixed workplace address - 25% sample data	
  traveL_time_Less15Smpl = "v_CA16_5816",	#Total	Less than 15 minutes	
  traveL_time_15to29Smpl = "v_CA16_5819",	#Total	15 to 29 minutes	
  traveL_time_30to44Smpl= "v_CA16_5822",	#Total	30 to 44 minutes	
  traveL_time_45to59Smpl = "v_CA16_5825",	#Total	45 to 59 minutes	
  travel_time_60PlusSmpl = "v_CA16_5828"	#Total	60 minutes and over
  )

# Retrieves census data and filters data for Ottawa (CMA_UID = "505")
census_data <- get_census(dataset='CA16', regions=list(PR="35"),
                          vectors=c(census_vars), level='CT', quiet = TRUE, 
                          geo_format = 'sf', labels = 'short')
CTOttawa <- filter(census_data, CMA_UID == "505")
CTOttawa <- na.omit(CTOttawa)

# Plot #
ggplot(CTOttawa) + geom_sf(aes(fill = hh_inc_MedIncHHAftTax), colour = "grey") +
  scale_fill_viridis_c("hh_inc_MedIncHHAftTax", labels = scales::dollar) + theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) + 
  coord_sf(datum=NA) +
  labs(title = "Median Household Income", subtitle = "Ontario Census Tracts, 2016 Census")
