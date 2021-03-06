import sys, getopt
import argparse
import datetime
import re
import json
import os
import requests 
import MySQLdb #need sudo apt-get install python-mysqldb (for debian based distros), yum install MySQL-python (for rpm-based), or dnf install python-mysql (for modern fedora distro) in command line to download

start_date = '2021-01-1' 
end_date = '2021-06-01'
url = 'https://covidtrackerapi.bsg.ox.ac.uk/api/v2/stringency/date-range/'

try:  
   os.environ["DB_HOST"]
except KeyError: 
   print ("Please set the environment variable DB_HOST")
   sys.exit(1)

try:  
   os.environ["DB_USER"]
except KeyError: 
   print ("Please set the environment variable DB_USER")
   sys.exit(1)

try:  
   os.environ["DB_PASS"]
except KeyError: 
   print ("Please set the environment variable DB_PASS")
   sys.exit(1)

try:  
   os.environ["DB_NAME"]
except KeyError: 
   print ("Please set the environment variable DB_NAME")
   sys.exit(1)         

db_host = os.environ.get('DB_HOST')

print("DBHOST IS ", os.environ.get('DB_HOST'))

db_user = os.environ.get('DB_USER')
db_pass = os.environ.get('DB_PASS')
db_name = os.environ.get('DB_NAME')

query_insert = """INSERT INTO covid (date_value,country_code,confirmed,deaths,stringency_actual,stringency) VALUES (%s,%s,%s,%s,%s,%s)"""
query_select = """SELECT date_value,country_code,confirmed,deaths,stringency_actual,stringency FROM covid"""
query_create = """CREATE TABLE IF NOT EXISTS covid (
                  id INT AUTO_INCREMENT PRIMARY KEY, 
                  date_value VARCHAR(255) NOT NULL,
                  country_code VARCHAR(255) NOT NULL,
                  confirmed INT,
                  deaths INT,
                  stringency_actual FLOAT,
                  stringency FLOAT)"""
qurey_unique_index = """CREATE UNIQUE INDEX ix_uq ON covid (date_value, country_code)"""
query_update = """INSERT IGNORE INTO covid (date_value,country_code,confirmed,deaths,stringency_actual,stringency) VALUES (%s,%s,%s,%s,%s,%s)"""

# Initialising database connection
try:
    db = MySQLdb.connect(host = db_host,    # host, usually localhost
                     user = db_user,         # username
                     passwd = db_pass,  # password
                     db = db_name)        # of the data base
except ValueError:
    raise ValueError("No datatbase connect")

def create_table(url, start, end):
    print ("Creating table \"covid\"")
    cur = db.cursor()
    try:
       cur.execute(query_create)
    except ValueError:
        raise ValueError("Something go wrong while creating table")            
    print("Getting data from ", url + str(start) + '/' + str(end))
    r = requests.get(url  + str(start) + '/' + str(end))
    data = r.json()
    print("Opening database")    
    cur = db.cursor()
    print("Parsing data and inserting it to database")
    for date in data["data"]:
        for country in data["data"][date]:
            try:            
               cur.execute(query_insert, (data["data"][date][country]["date_value"], data["data"][date][country]["country_code"], data["data"][date][country]["confirmed"], data["data"][date][country]["deaths"], data["data"][date][country]["stringency_actual"],data["data"][date][country]['stringency']))  
            except ValueError:
                raise ValueError("Something go wrong while inserting new data")             
    print("Creating unique indexes for date_value and country_code fields")
    try:
       cur.execute(qurey_unique_index)
    except ValueError:
        raise ValueError("Something go wrong while creating indexes")         
    print("Commititng data")
    db.commit()
    print("Closing database")
    cur.close()       
    return("DB created and data has been inserted from: " + start_date + " to: " + end_date ) 

def update_data(url, start, end):
# Getting data from API and inserting it to database
    print("Getting data from ", url + str(start) + '/' + str(end))
    r = requests.get(url  + str(start) + '/' + str(end))
    data = r.json()
    print("Opening database")    
    cur = db.cursor()
    print("Parsing data and inserting it to database")
    for date in data["data"]:
        for country in data["data"][date]:
            try:
               cur.execute(query_update, (data["data"][date][country]["date_value"], data["data"][date][country]["country_code"], data["data"][date][country]["confirmed"], data["data"][date][country]["deaths"], data["data"][date][country]["stringency_actual"],data["data"][date][country]['stringency']))
            except ValueError:
                raise ValueError("Something go wrong while inserting new data")          
    print("Commititng data")
    db.commit()
    print("Closing database")
    cur.close()    
    return("DB has been update to: " + end_date )

def select_data():
# Selecting data drom database  
    print("Opening database") 
    cur = db.cursor()
    print("Selecting data from database")
    try:
       cur.execute(query_select)
    except ValueError:
        print("Something going wrong. Select didn't working. I'll check if table exist and if no I'll fix it")
        create_table(url, start_date, end_date)
        raise ValueError("Cannot get data from DB")      
    row_headers=[h[0] for h in cur.description]
    results = cur.fetchall()
    j_data=[]
    for result in results:
        j_data.append(dict(zip(row_headers, result))) 
    cur.close()
    return j_data