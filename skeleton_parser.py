
"""
FILE: skeleton_parser.py
------------------
Author: Firas Abuzaid (fabuzaid@stanford.edu)
Author: Perth Charernwattanagul (puch@stanford.edu)
Modified: 04/21/2014

Skeleton parser for CS564 programming project 1. Has useful imports and
functions for parsing, including:

1) Directory handling -- the parser takes a list of eBay json files
and opens each file inside of a loop. You just need to fill in the rest.
2) Dollar value conversions -- the json files store dollar value amounts in
a string like $3,453.23 -- we provide a function to convert it to a string
like XXXXX.xx.
3) Date/time conversions -- the json files store dates/ times in the form
Mon-DD-YY HH:MM:SS -- we wrote a function (transformDttm) that converts to the
for YYYY-MM-DD HH:MM:SS, which will sort chronologically in SQL.

Your job is to implement the parseJson function, which is invoked on each file by
the main function. We create the initial Python dictionary object of items for
you; the rest is up to you!
Happy parsing!
"""

import sys
from json import loads
from re import sub
import os

columnSeparator = "|"

# Dictionary of months used for date transformation
MONTHS = {'Jan':'01','Feb':'02','Mar':'03','Apr':'04','May':'05','Jun':'06',\
        'Jul':'07','Aug':'08','Sep':'09','Oct':'10','Nov':'11','Dec':'12'}
########################################################################################
users = {}
itemcollection = set()
bidCollection = set()
catBidCollection = set()
usersCollection  = set()
jsons = set()
debug3Counter = 0
debug4 = 0
debug5 = None
debug6 = set()
#########################################################################################
"""
Returns true if a file ends in .json
"""
def isJson(f):
    return len(f) > 5 and f[-5:] == '.json'

"""
Converts month to a number, e.g. 'Dec' to '12'
"""
def transformMonth(mon):
    if mon in MONTHS:
        return MONTHS[mon]
    else:
        return mon

"""
Transforms a timestamp from Mon-DD-YY HH:MM:SS to YYYY-MM-DD HH:MM:SS
"""
def transformDttm(dttm):
    dttm = dttm.strip().split(' ')
    dt = dttm[0].split('-')
    date = '20' + dt[2] + '-'
    date += transformMonth(dt[0]) + '-' + dt[1]
    return date + ' ' + dttm[1]

"""
Transform a dollar value amount from a string like $3,453.23 to XXXXX.xx
"""

def transformDollar(money):
    if money == None or len(money) == 0:
        return money
    return sub(r'[^\d.]', '', money)


def userInfo(item):
    sell = item['Seller']
    buy = item['Bids']
    loc = item['Location']
    country = item['Country']
    if buy == None:
        pass
    else:
        #debug = buy[0]
        for aBid in buy:
            abuy = aBid['Bid']['Bidder']
            if abuy['UserID'] in users:
                users[abuy['UserID']]['buyer'] = True
            else:
                tempDic = {}
                tempDic['UserID'] = abuy['UserID']
                tempDic['Rating'] = abuy['Rating']
                tempDic['Location'] = abuy['Location'] if "Location" in abuy else 'NULL'
                tempDic['Country'] = abuy['Country'] if "Country" in abuy else 'NULL'
                tempDic['seller'] = False
                tempDic['buyer'] = True
                users[abuy['UserID']] = tempDic
    if sell == None:
        pass
    else:
        if sell['UserID'] in users:
            users[sell['UserID']]['seller'] = True
        else:
            tempDic = {}
            tempDic['UserID'] = sell['UserID']
            tempDic['Rating'] = sell['Rating']
            tempDic['Location'] = loc
            tempDic['Country'] = country
            tempDic['seller'] = True
            tempDic['buyer'] = False
            users[sell['UserID']] = tempDic

def itemInfo(item):
    global debug3Counter
    global debug4,debug5
    item_id = item['ItemID'].strip()
    name = item['Name'].strip()
    tempcatitem = set()
    for aCatt in item['Category']:
        tempcatitem.add(aCatt)
    categoryNum = str(len(tempcatitem))
    #categoryNum = str(len(item['Category']))
    if categoryNum == '4':
        debug3Counter = debug3Counter + 1
    currently = transformDollar(item['Currently'])
    if float(currently) > debug4:
        debug4 = float(currently)
        debug5 = item_id
    firstBid = transformDollar(item['First_Bid'])
    numBid = item['Number_of_Bids'].strip()
    loc = item['Location'].strip()
    country = item['Country'].strip()
    started = transformDttm(item['Started']).strip()
    ends = transformDttm(item['Ends']).strip()
    seller = item['Seller']['UserID'].strip()
    if "Buy_Price" in item:
        buy_price = transformDollar(item['Buy_Price'])
    else:
        buy_price = 'NULL'

    aSequence = (item_id,name,categoryNum,currently,firstBid,numBid,loc,country,started,ends,seller,buy_price)
    combine = "|".join( aSequence )
    combine = combine + '\n'
    itemcollection.add(combine)

def bidInfo(item):
    buy = item['Bids']
    if buy == None:
        pass
    else:
        for aBid in buy:
            tempItemID = item['ItemID']
            abuy = aBid['Bid']['Bidder']
            tempID = abuy['UserID']
            tempRating = abuy['Rating']
            tempLocation = abuy['Location'] if "Location" in abuy else 'NULL'
            tempCountry = abuy['Country'] if "Country" in abuy else 'NULL'
            tempTime = transformDttm(aBid['Bid']['Time'])
            tempAmount = transformDollar(aBid['Bid']['Amount'])
            aSequence = (tempItemID,tempID,tempRating,tempLocation,tempCountry,tempTime,tempAmount)
            combine = "|".join( aSequence )
            combine = combine + '\n'
            bidCollection.add(combine)

def catBidInfo(item):
    cats = item['Category']
    buy = item['Bids']
    if buy == None:
        pass
    else:
        for aBid in buy:
            tempAmount = transformDollar(aBid['Bid']['Amount'])
            #debug
            if float(tempAmount) >  100:
                for aCateg in cats:
                    debug6.add(aCateg)
            # debug end
            abuy = aBid['Bid']['Bidder']
            tempID = abuy['UserID']
            for aCateg in cats:
                aSeq = (aCateg,tempAmount,tempID)
                combine = "|".join(aSeq)
                combine = combine + '\n'
                catBidCollection.add(combine)







"""
Parses a single json file. Currently, there's a loop that iterates over each
item in the data set. Your job is to extend this functionality to create all
of the necessary SQL tables for your database.
"""
def parseJson(json_file):
    with open(json_file, 'r') as f:
        items = loads(f.read())['Items'] # creates a Python dictionary of Items for the supplied json file
        for item in items:
            userInfo(item)
            itemInfo(item)
            bidInfo(item)
            catBidInfo(item)

def reformUser():
    for (key,value) in users.items():
        tempId = value['UserID']
        tempRating = value['Rating']
        tempLocation = value['Location']
        tempCoutry = value['Country']
        tempSeller = str(value['seller'])
        tempbuyer = str(value['buyer'])
        seq = (tempId,tempRating,tempLocation,tempCoutry,tempSeller,tempbuyer)
        combine = "|".join(seq)
        combine = combine + '\n'
        usersCollection.add(combine)

def generateDAT():
    with open("itemcollection.dat", "w") as f:
        for aString in itemcollection:
            f.write(aString)
    #bidCollection
    with open("bidCollection.dat", "w") as f:
        for aString in bidCollection:
            f.write(aString)
    #catBidCollection
    with open("catBidCollection.dat", "w") as f:
        for aString in catBidCollection:
            f.write(aString)
    #usersCollection
    with open("usersCollection.dat", "w") as f:
        for aString in usersCollection:
            f.write(aString)









"""
Loops through each json files provided on the command line and passes each file
to the parser
"""

def main(argv):
    if len(argv) < 2:
        print >> sys.stderr, 'Usage: python skeleton_json_parser.py <path to json files>'
        sys.exit(1)
    # loops over all .json files in the argument
    for f in argv[1:]:
        if isJson(f):
            parseJson(f)
            print ("Success parsing " + f)
    reformUser()
    generateDAT()

    

if __name__ == '__main__':
    main(sys.argv)



#parseJson("items-0.json")

#############################################################################################################################
'''def findAllFile(base):
    for root, ds, fs in os.walk(base):
        for f in fs:
            yield f


base = '.'
debug = findAllFile(base)
print()
for i in findAllFile(base):
    if isJson(i):
        jsons.add(i)
for aJson in jsons:
    parseJson(aJson)
    #print(aJson)
reformUser()
generateDAT()'''

