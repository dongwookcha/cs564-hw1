drop table if exists userInfo;
drop table if exists itemInfo;
drop table if exists bidInfo;
drop table if exists catBidInfo;


create table userInfo (
UserID		INT		NOT NULL UNIQUE,
Rating		INT		NOT NULL,
Location	VARCHAR(255)	NOT NULL,
Country	    VARCHAR(255)	NOT NULL,
isSeller    NUMBER         NOT NULL,
isBuyer     NUMBER         NOT NULL,
PRIMARY KEY (UserID),
FOREIGN KEY UserID REFERENCES bidInfo (BidID)
);

create table itemInfo (
ItemID INT NOT NULL UNIQUE,
Name VARCHAR(255) NOT NULL,
CategoryNum INT NOT NULL,
Currently DOUBLE,
FirstBid DOUBLE,
NumberBids INT,
Location VARCHAR(255) NOT NULL
Country VARCHAR(255) NOT NULL
Started DATE NOT NULL,
Ended DATE NOT NULL,
Seller VARCHAR(225) NOT NULL,
Buy_Price DOUBLE,
PRIMARY KEY (ItemID)
FOREIGN KEY Seller REFERENCES userInfo(UserID),
);

create table bidInfo (
ItemID INT NOT NULL UNIQUE,
UserID INT NOT NULL UNIQUE,
Seller_Rating INT NOT NULL,
Location VARCHAR(225) NOT NULL,
Country VARCHAR(225) NOT NULL,
Time DATE NOT NULL,
Amount DOUBLE NOT NULL,
PRIMARY KEY (ItemID),
FOREIGN KEY ItemID REFERENCES itemInfo (ItemID),
FOREIGN KEY UserID REFERENCES userInfo (UserID)
);

create table catBidInfo (
Name     VARCHAR(225) NOT NULL,
Amount     INT          NOT NULL,
UserID     INT          NOT NULL UNIQUE
);


