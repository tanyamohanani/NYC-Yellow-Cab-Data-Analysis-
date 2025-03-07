import os
import sys
import numpy as np
import pandas as pd
import pyarrow.parquet as pq
from sqlalchemy import create_engine

def extract(dataPath, date):
    dataFrames = []
    files = os.listdir(dataPath)

    # Extracting the Location Lookup Table
    csvFile = next((os.path.join(dataPath, filename) for filename in os.listdir(dataPath) if filename.endswith(".csv")), None)
    locationLUT = pd.read_csv(csvFile)

    #Extracting the Yellow Trip Data
    # parquetFiles = [file for file in files if file.endswith('.parquet')]
    parquetFiles = [file for file in files if file.endswith('.parquet') and file.startswith(f'yellow_tripdata_{date}')]
    
    for file in parquetFiles:
        table = pq.read_table(dataPath+file)
        df = table.to_pandas().sample(frac=0.05)
        columns = df.columns.tolist()

        # Airport Fee is only included in 2022 & 2023 and is empty in 2019,2020,2021 data. Best to drop the column altogether.
        if 'airport_fee' in columns:
            df = df.drop(['airport_fee'], axis=1)
        elif 'Airport_fee' in columns:
            df = df.drop(['Airport_fee'], axis=1)    
        dataFrames.append(df)

    if len(dataFrames) > 1:
        rawData = pd.concat(dataFrames, ignore_index=True)
    elif len(dataFrames) == 1:
        rawData = dataFrames[0]
    else:
        rawData = pd.DataFrame()
    
    return rawData, locationLUT


def transform(rawData):

    # Renaming Columns for better interpretability
    rawData.rename(columns={
        'VendorID': 'vendorID',
        'passenger_count': 'passengerCount',
        'trip_distance': 'tripDistance',
        'RatecodeID': 'rateCodeID',
        'store_and_fwd_flag': 'storeAndForward',
        'PULocationID': 'pickupLocationID',
        'DOLocationID': 'dropoffLocationID',
        'tpep_pickup_datetime': 'pickupDatetime', 
        'tpep_dropoff_datetime': 'dropoffDatetime',
        'payment_type': 'paymentTypeID',
        'fare_amount': 'fareAmount',
        'mta_tax': 'mtaTax',
        'tip_amount': 'tipAmount',
        'tolls_amount': 'tollsAmount',
        'improvement_surcharge' : 'improvementSurcharge',
        'total_amount': 'totalAmount',
        'congestion_surcharge': 'congestionSurcharge'}, inplace=True)

    # Feature Engineering for Pickup & Dropoff Date
    rawData['date'] = rawData['pickupDatetime'].dt.date
    rawData['year'] = rawData['pickupDatetime'].dt.year
    rawData['month'] = rawData['pickupDatetime'].dt.month
    rawData['day'] = rawData['pickupDatetime'].dt.day
    rawData['weekday'] = rawData['pickupDatetime'].dt.day_name()

    # Feature Engineering for Pickup & Dropoff Time
    rawData['hour'] = rawData['pickupDatetime'].dt.hour
    rawData['minute'] = rawData['pickupDatetime'].dt.minute
    rawData['second'] = rawData['pickupDatetime'].dt.second
    rawData['duration'] = rawData['dropoffDatetime'] - rawData['pickupDatetime']
    rawData['duration'] = rawData['duration'] / np.timedelta64(1, 'm')
    rawData = rawData.drop(['pickupDatetime', 'dropoffDatetime'], axis=1)

    #Converting storeAndForward to Boolean
    rawData['storeAndForward'] = rawData['storeAndForward'].replace({'Y': True, 'N': False}).astype(bool)

    # Drop rows where rateCodeID is not between 1 and 6
    rawData = rawData[(rawData['rateCodeID'] >= 1) & (rawData['rateCodeID'] <= 6)]

    # Drop rows where vendorID is not 1 or 2
    # rawData = rawData[rawData['vendorID'].isin([1, 2])]
    
    # Dropping all Null Values
    # rawData = rawData.dropna()
    return rawData


def get_db_connection():
    db_user = "root"
    db_password = "password"
    db_name = "test"
    db_host = 'localhost'
    db_port = 3306

    connection_string = "mysql+pymysql://%s:%s@%s:%s/%s" % (db_user, db_password, db_host, db_port, db_name)
    db_connection = create_engine(connection_string)
    return db_connection


def write_to_database(source_dataframe, database_table, database_connection):
    source_dataframe.to_sql(name = database_table, con = database_connection, if_exists = 'append', index = False)


def main():
    # Data Extraction
    dataPath = r'/Users/kartik/Desktop/dataWarehousingProject/data/'
    date = sys.argv[1]
    rawData, locationLUT = extract(dataPath, date)
    print('rawData shape:', rawData.shape)
    print("Data Extraction Successful! Transforming Data...")

    # Data Transformation
    df = transform(rawData)
    print('df:', df.shape)
    print("Data Transformation Successful! Loading Data...")

    # Data Loading
    db_connection=get_db_connection()
    write_to_database(df, "yellowTaxi", db_connection)
    # write_to_database(locationLUT, "locationDimension", db_connection)
    print("Data Loaded Successfully! Check Database")


if __name__ == "__main__":
    main()
    