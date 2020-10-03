drop table if exists userInfo;
drop table if exists itemInfo;
drop table if exists bidInfo;
drop table if exists catBidInfo;


create table userInfo (
UserID		INT		NOT NULL UNIQUE,
Rating		INT		NOT NULL,
Location	VARCHAR(255)	NOT NULL,
Country	    VARCHAR(255)	NOT NULL,
isSeller    BOOL         NOT NULL,
isBuyer     BOOL         NOT NULL,
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
FOREIGN KEY Seller REFERENCES userInfo(UserID),
PRIMARY KEY (ItemID)
);

create table bidInfo (
ItemID INT NOT NULL UNIQUE,
UserID INT NOT NULL UNIQUE,
Location VARCHAR(225) NOT NULL,
Country VARCHAR(225) NOT NULL,
Time DATE NOT NULL,
Amount DOUBLE NOT NULL,
PRIMARY KEY (ItemID),
FOREIGN KEY ItemID REFERENCES itemInfo (ItemID),
FOREIGN KEY UserID REFERENCES userInfo (UserID)
);

create table catBidInfo (
aCateg     VARCHAR(225) NOT NULL,
Amount     INT          NOT NULL UNIQUE,
UserID     INT          NOT NULL UNIQUE
);

--create table Categories (
--CategoryID	INT		NOT NULL UNIQUE,
--Name		VARCHAR(255)	NOT NULL,
--PRIMARY KEY (CategoryID)
--);
--
--create table ItemCategories (
--ItemID		INT		NOT NULL UNIQUE,
--CategoryID	INT		NOT NULL UNIQUE,
--PRIMARY KEY (ItemID, CategoryID),
--FOREIGN KEY (ItemID) REFERENCES Items (ItemID),
--FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)
--);

--create table Bids (
--BidID	INT		NOT NULL UNIQUE,
--Time	DATE		NOT NULL,
--Amount	DOUBLE		NOT NULL,
--PRIMARY KEY (BidID),
--FOREIGN KEY BidID REFERENCES Items (ItemID),
--FOREIGN KEY BidID REFERENCES Users (UserID)
--);


