USE nyc_yellowtaxi; #database name 

# Star Schema Validation 
#1. What is the revenue collected in the last 5 years grouped by each month? 

SELECT datedimension.weekday, COUNT(facttableall.factID) AS trips
FROM facttableall
JOIN datedimension 
ON facttableall.dateID = datedimension.dateID
GROUP BY datedimension.weekday;

#2. How many trips are recorded for every weekday for the last 5 years? 

SELECT datedimension.month, SUM(facttableall.totalAmount) AS Revenue
FROM facttableall
JOIN datedimension
ON facttableall.dateID = dateDimension.dateID
GROUP BY datedimension.month;

#BI QUERIES

/*  Query 1: What are the total monthly revenues generated by each taxi vendor, 
and how do they contribute to the overall revenue of the taxi cab company? */

SELECT 
    vendorDimension.vendorName,
    COUNT(factTableAll.factID) as NoOfTrips,
    dateDimension.year as Year,
    dateDimension.month as Month,
    SUM(factTableAll.totalAmount) AS TotalRevenue
FROM 
    factTableAll
INNER JOIN vendorDimension ON factTableAll.vendorID = vendorDimension.vendorID
INNER JOIN dateDimension ON factTableAll.dateID = dateDimension.dateID
GROUP BY 
    ROLLUP(vendorDimension.vendorName, dateDimension.year, dateDimension.month)
ORDER BY 
    dateDimension.year, dateDimension.month;
    
/* Query 2: What are the yearly trends in taxi demand based on the day of the week and pickup location? */

SELECT 
    dd.year as Year, 
    dd.weekday,
    COUNT(*) AS NumberOfTrips
FROM 
    factTableAll ft
JOIN dateDimension dd ON ft.dateID = dd.dateID
GROUP BY 
    dd.year, 
    dd.weekday WITH ROLLUP
ORDER BY 
    dd.year, 
    dd.weekday;

/* Query 3: What are the top 10 location zones experiencing high trip demand, 
their corresponding revenue generated and how does the demand vary across 
different boroughs? */

SELECT ld.borough as Borough, 
	   ld.zone as Zone, 
       COUNT(ft.factID) as Total_trips, 
       ROUND(SUM(ft.totalAmount)) as Revenue
FROM locationdimension ld, facttableall ft
WHERE ld.LocationID = ft.pickupLocationID 
GROUP BY ld.zone, ld.borough
ORDER BY Total_trips DESC
LIMIT 10;

/* Query 4: How much does an average trip to an airport cost as compared to a 
drop-off at other zones and what are the extra charges, trip durations for both 
scenarios? */

SELECT
  CASE 
    WHEN l.zone = 'Newark Airport' OR l.zone='JFK Airport' THEN 'Airport'
    ELSE 'NonAirportAreas' 
  END AS Boroughs,
  AVG(f.tripDuration) AS AverageTripDuration,
  AVG(f.totalAmount) AS AverageTripAmount,
  AVG(f.totalAmount-f.fareAmount) AS ExtraAmount
FROM factTableAll f
JOIN locationdimension l
  ON f.dropoffLocationID = l.locationID
GROUP BY 
  CASE 
    WHEN l.zone = 'Newark Airport' OR l.zone='JFK Airport' THEN 'Airport'
    ELSE 'NonAirportAreas'
  END;

/* Query 5: Do long distance routes generate high revenues? */

SELECT
  routes AS RouteNames,
  tripDistance AS trip_distance,
  totalAmount AS revenue
FROM factTableAll f, locationdimension l
where l.locationID = f.pickupLocationID
ORDER BY f.tripDistance desc
LIMIT 20;