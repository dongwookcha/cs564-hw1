drop table if exists userInfo;
drop table if exists itemInfo;
drop table if exists bidInfo;
drop table if exists catBidInfo;


create table userInfo(
user_id		VARCHAR(255)	primary key NOT NULL,
Rating		INT		NOT NULL,
Location	VARCHAR(255)	NOT NULL,
Country	    VARCHAR(255)	NOT NULL,
isSeller    NUMBER         NOT NULL,
isBuyer     NUMBER         NOT NULL,
FOREIGN KEY user_id REFERENCES bidInfo (BidID)
);

create table itemInfo (
item_id INT NOT NULL UNIQUE,
Name VARCHAR(255) NOT NULL,
CategoryNum INT NOT NULL,
Currently DOUBLE,
FirstBid DOUBLE,
NumberBids INT,
Location VARCHAR(255) NOT NULL,
Country VARCHAR(255) NOT NULL,
Started DATE NOT NULL,
Ended DATE NOT NULL,
seller VARCHAR(225),
Buy_Price DOUBLE,
PRIMARY KEY (item_id),
FOREIGN KEY seller REFERENCES userInfo(user_id),
FOREIGN KEY item_id REFERENCES catBidInfo(user_id)
);

create table bidInfo (
item_id INT NOT NULL UNIQUE,
user_id VARCHAR(225) NOT NULL UNIQUE,
Seller_Rating INT NOT NULL,
Location VARCHAR(225) NOT NULL,
Country VARCHAR(225) NOT NULL,
Time DATE NOT NULL,
Amount DOUBLE NOT NULL,
PRIMARY KEY (item_id),
FOREIGN KEY item_id REFERENCES itemInfo (item_id),
FOREIGN KEY user_id REFERENCES userInfo (user_id)
);

create table catBidInfo (
Name     VARCHAR(225) NOT NULL,
Amount     DOUBLE     NOT NULL,
user_id     VARCHAR(255)  NOT NULL UNIQUE,
PRIMARY kEY (user_id)
);
