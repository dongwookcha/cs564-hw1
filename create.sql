drop table if exists Items;
drop table if exists Categories;
drop table if exists ItemCategories;
drop table if exists Bids;
drop table if exists Users;

create table Items (
ItemID		INT	 	NOT NULL UNIQUE,
Description VARCHAR(255)	NOT NULL,
Started		DATE		NOT NULL,
Ended		DATE		NOT NULL,
Currently	DOUBLE		NOT NULL,
Buy_Price	DOUBLE		NOT NULL,
First_Bid	DOUBLE		NOT NULL,
Number_of_Bids INT		NOT NULL,
PRIMARY KEY (ItemID)
);

create table Categories (
CategoryID	INT		NOT NULL UNIQUE,
Name		VARCHAR(255)	NOT NULL,
PRIMARY KEY (CategoryID)
);

create table ItemCategories (
ItemID		INT		NOT NULL UNIQUE,
CategoryID	INT		NOT NULL UNIQUE,
PRIMARY KEY (ItemID, CategoryID),
FOREIGN KEY (ItemID) REFERENCES Item (ItemID),
FOREIGN KEY (CategoryID) REFERENCES Category (CategoryID)
);

create table Bids (
BidID	INT		NOT NULL UNIQUE,
Time	DATE		NOT NULL,
Amount	DOUBLE		NOT NULL,
PRIMARY KEY (BidID),
FOREIGN KEY BidID REFERENCES Item (ItemID),
FOREIGN KEY BidID REFERENCES User (UserID)
);

create table Users (
UserID		INT		NOT NULL UNIQUE,
Rating		INT		NOT NULL,
Location	VARCHAR(255)	NOT NULL,
Country	VARCHAR(255)	NOT NULL,
PRIMARY KEY (UserID),
FOREIGN KEY UserID REFERENCES Item (ItemID),
FOREIGN KEY UserID REFERENCES Bid (BidID)
);
