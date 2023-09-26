cd /Users/sunjiaqi/Downloads
import delimited using cars.csv

* (a)
rename dimensionsheight height
rename dimensionslength length
rename dimensionswidth width
rename engineinformationdriveline driveline
rename engineinformationenginetype type
rename engineinformationhybrid hybrid
rename engineinformationnumberofforward gears
rename engineinformationtransmission transmission
rename fuelinformationcitympg city_mpg
rename fuelinformationfueltype fuel_type
rename fuelinformationhighwaympg highway_mpg
rename identificationclassification classification
rename identificationid ID
rename identificationmake make
rename identificationmodelyear model_year
rename identificationyear year
rename engineinformationenginestatistic horsepower
rename v18 torque

* (b)
keep if fuel_type == "Gasoline"

* (c)
regress highway_mpg c.horsepower c.torque c.height c.length c.width i.year

* (d)
regress highway_mpg c.horsepower##c.torque c.length c.width c.height i.year
margins, at(horsepower=(100(50)600) torque=(185 263 317) height=155 length=129 width=143 year=2011) plot(ytitle("Highway mpg") xtitle("Horsepower") title("Interaction Plot"))

graph export "/Users/sunjiaqi/Downloads/Graph.png", as(png) name("Graph")

* (e)
matrix X = J(4591, 10, .)
matrix y = J(4591, 1, .)
generate year2010 = 1 if year == 2010
generate year2011 = 1 if year == 2011
generate year2012 = 1 if year == 2012
replace year2010 = 0 if missing(year2010)
replace year2011 = 0 if missing(year2011)
replace year2012 = 0 if missing(year2012)

forval i = 1/4591 {
    matrix X[`i', 1] = horsepower[`i']
	matrix X[`i', 2] = torque[`i']
	matrix X[`i', 3] = horsepower[`i'] * torque[`i']
	matrix X[`i', 4] = length[`i']
	matrix X[`i', 5] = width[`i']
	matrix X[`i', 6] = height[`i']
	matrix X[`i', 7] = year2010[`i']
	matrix X[`i', 8] = year2011[`i']
	matrix X[`i', 9] = year2012[`i']
	matrix X[`i', 10] = 1
	matrix y[`i', 1] = highway_mpg[`i']
}

matrix b = inv(X' * X) * X' * y
matrix list b



