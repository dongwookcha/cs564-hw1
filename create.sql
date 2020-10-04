drop table if exists userInfo;
drop table if exists item;
drop table if exists bidInfo;
drop table if exists catBidInfo;


create table userInfo (
UserID INT NOT NULL UNIQUE,
Rating INT NOT NULL,
Location VARCHAR(255) NOT NULL,
Country VARCHAR(255) NOT NULL,
isSeller VARCHAR(6),
isBuyer VARCHAR(6),
PRIMARY KEY (UserID)
);
create table item (
ItemID	INT	NOT NULL UNIQUE,
Name VARCHAR(255) NOT NULL,
CategoryNum INT,
Currently DOUBLE,
FirstBid DOUBLE,
NumberBids INT,
Location VARCHAR(255),
Country VARCHAR(255),
Started DATE ,
Ended DATE,
Seller VARCHAR(255) NOT NULL,
Buy_Price DOUBLE,
Description VARCHAR(255),
PRIMARY KEY (ItemID),
FOREIGN KEY (Seller) REFERENCES userInfo(UserID)
);

create table bidInfo (
ItemID INT NOT NULL,
UserID VARCHAR(225) NOT NULL,
Rating DOUBLE,
Location VARCHAR(225),
Country VARCHAR(225),
CurrTime DATE NOT NULL,
Amount DOUBLE,
FOREIGN KEY (ItemID) REFERENCES item(ItemID),
FOREIGN KEY (UserID) REFERENCES userInfo(UserID)
);

create table catBidInfo(
Categories VARCHAR(255) NOT NULL,
Amount DOUBLE NOT NULL,
ID VARCHAR(255) NOT NULL,
FOREIGN KEY (ID) REFERENCES userInfo(UserID)
);


