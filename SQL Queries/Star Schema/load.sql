USE test;

SELECT COUNT(*) AS 'Existing rows count prior to adding new month data' FROM factTableAll;

INSERT INTO factTableAll (
    vendorID,
    dateID,
    timeID,
    passengerCount,
    tripDistance,
    pickupLocationID,
    dropoffLocationID,
    rateCodeID,
    storeAndForward,
    paymentTypeID,
    fareAmount,
    extra,
    mtaTax,
    improvementSurcharge,
    tipAmount,
    tollsAmount,
    totalAmount,
    congestionSurcharge,
    tripDuration
)
SELECT
    yt.vendorID,
    dd.dateID,
    td.timeID,
    yt.passengerCount,
    yt.tripDistance,
    yt.pickupLocationID,
    yt.dropoffLocationID,
    yt.rateCodeID,
    yt.storeAndForward,
    yt.paymentTypeID,
    yt.fareAmount,
    yt.extra,
    yt.mtaTax,
    yt.improvementSurcharge,
    yt.tipAmount,
    yt.tollsAmount,
    yt.totalAmount,
    yt.congestionSurcharge,
    yt.duration
FROM
    yellowTaxi yt
JOIN
    dateDimension dd ON yt.year = dd.year AND yt.month = dd.month AND yt.day = dd.day
JOIN
    timeDimension td ON yt.hour = td.hour AND yt.minute = td.minute AND yt.second = td.second;

DROP TABLE yellowTaxi;

SELECT COUNT(*) AS 'Updated rows count after adding new month data' FROM factTableAll;

-- DELETE FROM factTableAll
-- WHERE dateID IN (
--     SELECT dateID
--     FROM dateDimension
--     WHERE year = 2023 AND month = 12
-- );

-- SELECT * FROM factTableAll
-- WHERE dateID IN (
--     SELECT dateID
--     FROM dateDimension
--     WHERE year = 2023 AND month = 12
-- ) LIMIT 5;


























