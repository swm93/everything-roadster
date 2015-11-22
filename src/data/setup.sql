DROP TABLE RatesVendor;

DROP TABLE FitsIn;

DROP TABLE Vehicle;

DROP TABLE Make;

DROP TABLE Model;

DROP TABLE ContainsPart;

DROP TABLE ListedPart;

DROP TABLE Part;

DROP TABLE PartCategory;

DROP TABLE Shipment;

DROP TABLE PartOrder;

DROP TABLE Payment;

DROP TABLE Account;


CREATE TABLE Account (
    accountId       INTEGER,
    accountType     VARCHAR(10)
        CHECK (accountType IN ('Customer', 'Vendor', 'Admin')),
    email           VARCHAR(254)
        NOT NULL
        UNIQUE,
    password        VARCHAR(25)
        NOT NULL,
    firstName       VARCHAR(30)
        NOT NULL,
    lastName        VARCHAR(30)
        NOT NULL,
    phoneNumber     VARCHAR(16),
    streetAddress   VARCHAR(30)
        NOT NULL,
    city            VARCHAR(20)
        NOT NULL,
    provinceState    VARCHAR(20)
        NOT NULL,
    country    VARCHAR(20)
        NOT NULL,
    postalCode    VARCHAR(8)
        NOT NULL,
    PRIMARY KEY (accountId)
);

CREATE TABLE RatesVendor (
    customerId  INTEGER,
    vendorId    INTEGER,
    userRating  DECIMAL(2,1)
        NOT NULL
        CHECK (userRating BETWEEN 0.0 AND 5.0),
    PRIMARY KEY (customerId, vendorId),
    FOREIGN KEY (customerId) REFERENCES Account (accountId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (vendorId) REFERENCES Account (accountId)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE PartOrder (
    orderId     INTEGER,
    customerId  INTEGER,
    orderDate   DATETIME
        NOT NULL,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES Account (accountId)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Payment (
    accountNumber   INTEGER,
    paymentType     VARCHAR(25)
        CHECK (paymentType IN ('Paypal', 'Visa', 'MasterCard')),
    PRIMARY KEY (accountNumber)
);

CREATE TABLE Shipment (
    trackingNumber      INTEGER,
    orderId             INTEGER,
    carrier             VARCHAR(25)
        CHECK (carrier IN ('USPS', 'FedEx', 'UPS', 'CanadaPost')),
    instruction         VARCHAR(8000),
    shipCost            DECIMAL(5,2)
        NOT NULL,
    shipDate            DATETIME
        NOT NULL,
    shipOption          VARCHAR(25)
        CHECK (shipOption IN ('Express', 'Overnight', 'Normal')),
    toAddress           VARCHAR(30)
        NOT NULL,
    toCity              VARCHAR(20)
        NOT NULL,
    toProvinceState     VARCHAR(20)
        NOT NULL,
    toCountry           VARCHAR(20)
        NOT NULL,
    toPostalCode        VARCHAR(8)
        NOT NULL,
    fromAddress         VARCHAR(30)
        NOT NULL,
    fromCity            VARCHAR(20)
        NOT NULL,
    fromProvinceState   VARCHAR(20)
        NOT NULL,
    fromCountry         VARCHAR(20)
        NOT NULL,
    fromPostalCode      VARCHAR(8)
        NOT NULL,
    paymentId           INTEGER
        NOT NULL,
    PRIMARY KEY (trackingNumber),
    FOREIGN KEY (orderId) REFERENCES PartOrder (orderId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (paymentId) REFERENCES Payment (accountNumber)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE PartCategory (
    categoryName    VARCHAR(50),
    description     VARCHAR(8000),
    PRIMARY KEY (categoryName)
);

CREATE TABLE Part (
    partId          INTEGER,
    imagePath       VARCHAR(255),
    categoryName    VARCHAR(50),
    partName        VARCHAR(50),
    description     VARCHAR(8000),
    PRIMARY KEY (partId),
    FOREIGN KEY (categoryName) REFERENCES PartCategory (categoryName)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE ListedPart (
    listId      INTEGER,
    vendorId    INTEGER
        NOT NULL,
    partId      INTEGER
        NOT NULL,
    quantity    INTEGER
        NOT NULL
        CHECK (quantity >= 0),
    price       DECIMAL(10,2)
        NOT NULL
        CHECK (price >= 0.0),
    PRIMARY KEY (listId),
    FOREIGN KEY (vendorId) REFERENCES Account (accountId)
        -- ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (partId) REFERENCES Part (partId)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE ContainsPart (
    orderId     INTEGER,
    listId      INTEGER,
    quantity    INTEGER
        NOT NULL
        CHECK (quantity > 0),
    PRIMARY KEY (orderId, listId),
    FOREIGN KEY (orderId) REFERENCES PartOrder (orderId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (listId) REFERENCES ListedPart (listId)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE Make (
    name    VARCHAR(25),
    PRIMARY KEY (name)
);

CREATE TABLE Model (
    name    VARCHAR(25),
    PRIMARY KEY (name)
);

CREATE TABLE Vehicle (
    vehicleId   INTEGER,
    makeName    VARCHAR(25),
    modelName   VARCHAR(25),
    year        INTEGER
        NOT NULL,
    PRIMARY KEY (vehicleId),
    FOREIGN KEY (makeName) REFERENCES Make (name)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (modelName) REFERENCES Model (name)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE FitsIn (
    partId      INTEGER,
    vehicleId   INTEGER,
    PRIMARY KEY (partId, vehicleId),
    FOREIGN KEY (partId) REFERENCES Part (partId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (vehicleId) REFERENCES Vehicle (vehicleId)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('1', 'admin', 'dcoleman0@gravatar.com', 'nec', 'Doris', 'Coleman', '1-(202)876-8809', '0475 Cambridge Parkway', 'Washington', 'District of Columbia', 'United States', '20057');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('2', 'admin', 'ghawkins1@yelp.com', 'vivamus', 'Gary', 'Hawkins', '1-(518)163-8665', '22868 Forest Place', 'Albany', 'New York', 'United States', '12255');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('3', 'vendor', 'emiller2@chicagotribune.com', 'ligula', 'Eugene', 'Miller', '1-(518)661-6997', '5 Lerdahl Road', 'Albany', 'New York', 'United States', '12237');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('4', 'customer', 'mhawkins3@shinystat.com', 'porttitor', 'Marilyn', 'Hawkins', '1-(305)863-3025', '8125 Oriole Parkway', 'Miami', 'Florida', 'United States', '33185');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('5', 'vendor', 'mprice4@mediafire.com', 'faucibus', 'Maria', 'Price', '1-(202)146-8119', '48 Heath Plaza', 'Washington', 'District of Columbia', 'United States', '20022');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('6', 'customer', 'mcrawford5@tripod.com', 'pellentesque', 'Mary', 'Crawford', '1-(561)147-4896', '0 Spenser Park', 'Lake Worth', 'Florida', 'United States', '33467');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('7', 'customer', 'ecooper6@mlb.com', 'cubilia', 'Ernest', 'Cooper', '1-(214)687-7486', '56 Sachs Terrace', 'Garland', 'Texas', 'United States', '75049');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('8', 'customer', 'cmarshall7@topsy.com', 'semper', 'Carol', 'Marshall', '1-(251)323-3089', '03694 Starling Trail', 'Mobile', 'Alabama', 'United States', '36622');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('9', 'admin', 'jmartin8@java.com', 'gravida', 'Jacqueline', 'Martin', '1-(701)240-4735', '28227 Badeau Parkway', 'Fargo', 'North Dakota', 'United States', '58122');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('10', 'vendor', 'rflores9@economist.com', 'diam', 'Robin', 'Flores', '1-(608)357-6583', '77700 Forest Place', 'Madison', 'Wisconsin', 'United States', '53779');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('11', 'admin', 'rshawa@tamu.edu', 'mus', 'Rebecca', 'Shaw', '1-(520)347-5517', '8190 Center Place', 'Tucson', 'Arizona', 'United States', '85715');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('12', 'vendor', 'jdanielsb@imgur.com', 'augue', 'Johnny', 'Daniels', '1-(731)828-9905', '5550 Sachs Drive', 'Jackson', 'Tennessee', 'United States', '38308');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('13', 'vendor', 'redwardsc@jiathis.com', 'pellentesque', 'Ruby', 'Edwards', '1-(513)194-4635', '38 Petterle Street', 'Cincinnati', 'Ohio', 'United States', '45271');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('14', 'admin', 'cmyersd@nifty.com', 'curabitur', 'Carl', 'Myers', '1-(608)855-1945', '666 Burrows Junction', 'Madison', 'Wisconsin', 'United States', '53710');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('15', 'customer', 'pcolee@sourceforge.net', 'sapien', 'Patricia', 'Cole', '1-(717)176-0760', '2690 Sundown Terrace', 'Lancaster', 'Pennsylvania', 'United States', '17622');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('16', 'customer', 'jwarrenf@theglobeandmail.com', 'primis', 'John', 'Warren', '1-(304)702-9618', '366 School Terrace', 'Huntington', 'West Virginia', 'United States', '25775');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('17', 'vendor', 'ffoxg@economist.com', 'faucibus', 'Fred', 'Fox', '1-(757)220-7707', '4 Porter Trail', 'Norfolk', 'Virginia', 'United States', '23514');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('18', 'admin', 'pharrish@comsenz.com', 'pharetra', 'Phillip', 'Harris', '1-(650)359-8512', '0 Thierer Place', 'Redwood City', 'California', 'United States', '94064');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('19', 'admin', 'scolei@theguardian.com', 'morbi', 'Scott', 'Cole', '1-(951)303-0657', '78 Jay Terrace', 'Corona', 'California', 'United States', '92878');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('20', 'admin', 'gfowlerj@slashdot.org', 'proin', 'Gerald', 'Fowler', '1-(515)167-4752', '396 Maple Wood Place', 'Des Moines', 'Iowa', 'United States', '50936');

