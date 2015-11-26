DROP TABLE RatesVendor;

DROP TABLE FitsIn;

DROP TABLE Vehicle;

DROP TABLE Make;

DROP TABLE Model;

DROP TABLE ContainsPart;

DROP TABLE ListedPart;

DROP TABLE Part;

DROP TABLE PartCategory;

DROP TABLE Payment;

DROP TABLE Shipment;

DROP TABLE PartOrder;

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

CREATE TABLE Shipment (
    shipmentId          INTEGER,
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
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (orderId) REFERENCES PartOrder (orderId)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Payment (
    accountNumber   INTEGER,
    shipmentId      INTEGER
        NOT NULL,
    paymentType     VARCHAR(25)
        CHECK (paymentType IN ('Paypal', 'Visa', 'MasterCard')),
    PRIMARY KEY (accountNumber),
    FOREIGN KEY (shipmentId) REFERENCES Shipment (shipmentId)
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
    dateListed  DATETIME
        NOT NULL,
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

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('3', '1', '4.9');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('5', '2', '4.3');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('10', '3', '2.5');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('12', '4', '4.7');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('13', '5', '3.8');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('17', '6', '0.1');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('1', '1', '2015-01-01 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('2', '2', '2015-01-02 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('3', '2', '2015-01-03 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('4', '2', '2015-01-04 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('5', '1', '2015-01-05 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('6', '4', '2015-01-06 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('7', '5', '2015-01-07 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('8', '1', '2015-01-08 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('9', '1', '2015-01-09 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('10', '2', '2015-01-10 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('11', '4', '2015-01-11 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('12', '5', '2015-01-12 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('13', '5', '2015-01-13 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('14', '5', '2015-01-14 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('15', '5', '2015-01-15 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('16', '5', '2015-01-16 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('17', '1', '2015-01-17 00:00:00');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('1', '1000457', '1', 'USPS', 'Deliver between 08:00 and 20:00', '9.95', '2015-01-01 00:00:00', 'Express', '4 Northridge Park', 'Farmington', 'Michigan', 'United States', '48335', '73331 Jana Way', 'Winston Salem', 'North Carolina', 'United States', '27116');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('2', '2000914', '2', 'CanadaPost', 'If noone is home, leave out back', '123.45', '2015-01-02 00:00:00', 'Normal', '334 Northridge Crossing', 'Tulsa', 'Oklahoma', 'United States', '74133', '8888 Hoard Terrace', 'Dayton', 'Ohio', 'United States', '45440');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('3', '4001828', '3', 'FedEx', 'If noone is home, leave out back', '456.3', '2015-01-03 00:00:00', 'Express', '1 Shopko Court', 'Tucson', 'Arizona', 'United States', '85754', '51 Carioca Alley', 'Washington', 'District of Columbia', 'United States', '20337');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('4', '405002', '4', 'USPS', 'Deliver between 08:00 and 20:00', '32', '2015-01-04 00:00:00', 'Normal', '32 Autumn Leaf Court', 'Rochester', 'New York', 'United States', '14652', '00 1st Plaza', 'Dallas', 'Texas', 'United States', '75236');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('5', '253525', '5', 'CanadaPost', 'If noone is home, leave out back', '255.175', '2015-01-05 00:00:00', 'Normal', '8343 Packers Hill', 'Des Moines', 'Iowa', 'United States', '50320', '83 Browning Avenue', 'Lakewood', 'Washington', 'United States', '98498');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('6', '4653534', '6', 'FedEx', 'If noone is home, leave out back', '295.075', '2015-01-06 00:00:00', 'Express', '85 Riverside Place', 'Milwaukee', 'Wisconsin', 'United States', '53215', '234 Hallows Alley', 'Sacramento', 'California', 'United States', '95852');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('7', '432442', '7', 'USPS', 'If noone is home, leave out back', '334.975', '2015-01-07 00:00:00', 'Normal', '92 Superior Avenue', 'Johnson City', 'Tennessee', 'United States', '37605', '4 4th Plaza', 'Aurora', 'Colorado', 'United States', '80045');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('8', '432423', '8', 'CanadaPost', 'If noone is home, leave out back', '374.875', '2015-01-08 00:00:00', 'Overnight', '12980 Veith Alley', 'Camden', 'New Jersey', 'United States', '8104', '24168 Nelson Drive', 'Philadelphia', 'Pennsylvania', 'United States', '19093');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('9', '35435356', '9', 'FedEx', 'Deliver between 08:00 and 20:00', '414.775', '2015-01-09 00:00:00', 'Overnight', '10 Hagan Place', 'Philadelphia', 'Pennsylvania', 'United States', '19172', '29461 Logan Center', 'Atlanta', 'Georgia', 'United States', '30311');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('10', '432465', '10', 'USPS', 'Deliver between 08:00 and 20:00', '454.675', '2015-01-10 00:00:00', 'Normal', '994 Fremont Road', 'Bradenton', 'Florida', 'United States', '34282', '90 Annamark Alley', 'Richmond', 'Virginia', 'United States', '23213');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('11', '353656', '11', 'CanadaPost', 'If noone is home, leave out back', '494.575', '2015-01-11 00:00:00', 'Express', '33 Melody Center', 'El Paso', 'Texas', 'United States', '88563', '74224 Jenna Trail', 'Arlington', 'Virginia', 'United States', '22244');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('12', '854', '12', 'UPS', 'If noone is home, leave out back', '534.475', '2015-01-12 00:00:00', 'Overnight', '13133 Upham Way', 'Erie', 'Pennsylvania', 'United States', '16565', '848 Lien Hill', 'Lake Charles', 'Louisiana', 'United States', '70616');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('13', '12325', '13', 'USPS', 'Deliver between 08:00 and 20:00', '574.375', '2015-01-13 00:00:00', 'Normal', '194 Steensland Trail', 'Houston', 'Texas', 'United States', '77010', '06327 Clyde Gallagher Center', 'Kansas City', 'Kansas', 'United States', '66112');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('14', '533', '14', 'CanadaPost', 'If noone is home, leave out back', '614.275', '2015-01-14 00:00:00', 'Express', '26874 Bartelt Park', 'Roanoke', 'Virginia', 'United States', '24040', '49059 Dennis Terrace', 'Washington', 'District of Columbia', 'United States', '56944');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('15', '53', '15', 'UPS', 'Deliver between 08:00 and 20:00', '654.175', '2015-01-15 00:00:00', 'Normal', '32 Buena Vista Park', 'Savannah', 'Georgia', 'United States', '31416', '0102 Hoepker Alley', 'Pueblo', 'Colorado', 'United States', '81005');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('16', '525', '16', 'USPS', 'Deliver between 08:00 and 20:00', '694.075', '2015-01-16 00:00:00', 'Overnight', '1 Debs Crossing', 'Washington', 'District of Columbia', 'United States', '20520', '66075 Norway Maple Court', 'Waterbury', 'Connecticut', 'United States', '6726');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode, fromAddress, fromCity, fromProvinceState, fromCountry, fromPostalCode)
    VALUES ('17', '25252', '17', 'USPS', 'Deliver between 08:00 and 20:00', '733.975', '2015-01-17 00:00:00', 'Overnight', '9 Jackson Trail', 'Washington', 'District of Columbia', 'United States', '20540', '3846 Westend Way', 'Albuquerque', 'New Mexico', 'United States', '87115');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('1', '1', 'Paypal');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('2', '2', 'Paypal');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('4', '3', 'Visa');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('6', '4', 'Visa');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('7', '5', 'Paypal');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('8', '6', 'Visa');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('9', '7', 'MasterCard');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('11', '8', 'Paypal');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('14', '9', 'MasterCard');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('15', '10', 'Visa');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('16', '11', 'Paypal');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('18', '12', 'MasterCard');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('19', '13', 'Paypal');

INSERT INTO Payment (accountNumber, shipmentId, paymentType)
    VALUES ('20', '14', 'MasterCard');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Seat', 'A thing made or used for sitting on');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Brake', 'A device for slowing or stopping a moving vehicle, typically by applying pressure to the wheels.');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Tire', 'A  tire consists of a rubber ring around the rim of an automobile whee');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Wheel Rim', 'The outer edge of a wheel, on which the tire is fitted.');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Steering Wheel', 'A wheel that a driver rotates in order to steer a vehicle.');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Battery', 'An automotive battery is a type of rechargeable battery that supplies electric energy to an automobile.');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Windshield Wipers', 'A motor-driven device for keeping a windshield clear of rain, typically one with a rubber blade on an arm that moves in an arc');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Windshield', 'A window at the front of the passenger compartment of a motor vehicle.');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Engine', 'A machine with moving parts that converts power into motion.');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('1', 'Seat', 'Red/Black Seat', 'Red and black seat', 'public/images/parts/part1.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('2', 'Brake', 'Brake Rotor - Rear', 'Brake Rotor features a patented elliptical grooves help channel awa heat, water and gases, reducing brake fade', 'public/images/parts/part2.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('3', 'Brake ', 'Brake Rotor - Front', 'Brake Rotor features a patented elliptical grooves help channel awa heat, water and gases, reducing brake fade', 'public/images/parts/part3.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('4', 'Brake', 'Sever Duty Brake Pad Set', 'Resists brake fade that can occur In extended & extreme Use', 'public/images/parts/part4.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('5', 'Engine', 'dodge engine', 'Internal combustion engine made for Dodge vehicles', 'public/images/parts/part5.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('6', 'Engine', 'every other engine', 'Internal combustion engine made for non-Dodge vehicles', 'public/images/parts/part6.jpg');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('1', '2', '1', '1', '250', '2015-01-01 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('2', '3', '2', '1', '100', '2015-01-02 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('3', '4', '3', '1', '100', '2015-01-03 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('4', '5', '4', '1', '120', '2015-01-04 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('5', '1', '6', '1', '600', '2015-01-05 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('6', '1', '5', '1', '500', '2015-01-06 00:00:00');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('1', '1', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('2', '1', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('3', '1', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('4', '2', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('5', '3', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('6', '5', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('7', '6', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('8', '1', '2');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('9', '2', '3');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('10', '3', '3');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('11', '4', '2');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('12', '5', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('13', '3', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('14', '2', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('15', '1', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('16', '1', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('17', '1', '1');

INSERT INTO Make (name)
    VALUES ('Ford');

INSERT INTO Make (name)
    VALUES ('Chevrolet');

INSERT INTO Make (name)
    VALUES ('Dodge');

INSERT INTO Make (name)
    VALUES ('Ferrari');

INSERT INTO Make (name)
    VALUES ('Toyota');

INSERT INTO Make (name)
    VALUES ('Honda');

INSERT INTO Model (name)
    VALUES ('F-150');

INSERT INTO Model (name)
    VALUES ('F-350');

INSERT INTO Model (name)
    VALUES ('Caravan');

INSERT INTO Model (name)
    VALUES ('Ram');

INSERT INTO Model (name)
    VALUES ('Corvette');

INSERT INTO Model (name)
    VALUES ('Celta');

INSERT INTO Model (name)
    VALUES ('Daytona');

INSERT INTO Model (name)
    VALUES ('F40');

INSERT INTO Model (name)
    VALUES ('Corolla');

INSERT INTO Model (name)
    VALUES ('Camry');

INSERT INTO Model (name)
    VALUES ('Accord');

INSERT INTO Model (name)
    VALUES ('Fit');

INSERT INTO Model (name)
    VALUES ('Avenger');

INSERT INTO Model (name)
    VALUES ('Challenger');

INSERT INTO Model (name)
    VALUES ('Charger');

INSERT INTO Model (name)
    VALUES ('Dart');

INSERT INTO Model (name)
    VALUES ('Journey');

INSERT INTO Model (name)
    VALUES ('Viper');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('1', 'Ford', 'F-150', '2008');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('2', 'Ford', 'F-150', '2009');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('3', 'Ford', 'F-150', '2010');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('4', 'Ford', 'F-350', '2008');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('5', 'Ford', 'F-350', '2009');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('6', 'Ford', 'F-350', '2010');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('7', 'Dodge', 'Caravan', '2008');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('8', 'Dodge', 'Caravan', '2009');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('9', 'Dodge', 'Caravan', '2010');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('10', 'Dodge', 'Ram', '2008');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('11', 'Dodge', 'Ram', '2009');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('12', 'Dodge', 'Ram', '2010');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('13', 'Chevrolet', 'Celta', '2008');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('14', 'Chevrolet', 'Celta', '2009');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('15', 'Chevrolet', 'Celta', '2010');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('16', 'Chevrolet', 'Corvette', '2008');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('17', 'Chevrolet', 'Corvette', '2009');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('18', 'Chevrolet', 'Corvette', '2010');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('19', 'Ferrari', 'Daytona', '2008');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('20', 'Ferrari', 'Daytona', '2009');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('21', 'Ferrari', 'Daytona', '2010');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('22', 'Ferrari', 'F40', '2008');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('23', 'Ferrari', 'F40', '2009');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('24', 'Ferrari', 'F40', '2010');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('25', 'Ferrari', 'F40', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('26', 'Toyota', 'Corolla', '2008');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('27', 'Toyota', 'Corolla', '2009');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('28', 'Toyota', 'Corolla', '2010');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('29', 'Toyota', 'Camry', '2008');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('30', 'Toyota', 'Camry', '2009');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('31', 'Toyota', 'Camry', '2010');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('32', 'Honda', 'Accord', '2008');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('33', 'Honda', 'Accord', '2009');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('34', 'Honda', 'Accord', '2010');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('35', 'Honda', 'Fit', '2008');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('36', 'Honda', 'Fit', '2009');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('37', 'Honda', 'Fit', '2010');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('38', 'Dodge', 'Avenger', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('39', 'Dodge', 'Avenger', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('40', 'Dodge', 'Avenger', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('41', 'Dodge', 'Challenger', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('42', 'Dodge', 'Challenger', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('43', 'Dodge', 'Challenger', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('44', 'Dodge', 'Charger', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('45', 'Dodge', 'Charger', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('46', 'Dodge', 'Charger', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('47', 'Dodge', 'Dart', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('48', 'Dodge', 'Dart', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('49', 'Dodge', 'Dart', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('50', 'Dodge', 'Journey', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('51', 'Dodge', 'Journey', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('52', 'Dodge', 'Journey', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('53', 'Dodge', 'Viper', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('54', 'Dodge', 'Viper', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('55', 'Dodge', 'Viper', '2013');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '25');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '37');

