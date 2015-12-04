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
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
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
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (orderId) REFERENCES PartOrder (orderId)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Payment (
    paymentId       INTEGER,
    shipmentId      INTEGER
        NOT NULL,
    accountNumber   INTEGER
        NOT NULL,
    paymentType     VARCHAR(25)
        CHECK (paymentType IN ('Paypal', 'Visa', 'MasterCard')),
    PRIMARY KEY (paymentId),
    FOREIGN KEY (shipmentId) REFERENCES Shipment (shipmentId)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
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
    partName        VARCHAR(50)
        NOT NULL,
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
        ON UPDATE NO ACTION
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
    VALUES ('1', 'customer', 'test@test.com', 'test', 'Test', 'Test', '1-(234)567-8900', '1234 Fake St', 'Kelowna', 'British Columbia', 'Canada', 'A1A1A1');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('2', 'vendor', 'dcoleman0@gravatar.com', 'nec', 'Doris', 'Coleman', '1-(202)876-8809', '0475 Cambridge Parkway', 'Washington', 'District of Columbia', 'United States', '20057');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('3', 'vendor', 'ghawkins1@yelp.com', 'vivamus', 'Gary', 'Hawkins', '1-(518)163-8665', '22868 Forest Place', 'Albany', 'New York', 'United States', '12255');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('4', 'vendor', 'emiller2@chicagotribune.com', 'ligula', 'Eugene', 'Miller', '1-(518)661-6997', '5 Lerdahl Road', 'Albany', 'New York', 'United States', '12237');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('5', 'customer', 'mhawkins3@shinystat.com', 'porttitor', 'Marilyn', 'Hawkins', '1-(305)863-3025', '8125 Oriole Parkway', 'Miami', 'Florida', 'United States', '33185');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('6', 'vendor', 'mprice4@mediafire.com', 'faucibus', 'Maria', 'Price', '1-(202)146-8119', '48 Heath Plaza', 'Washington', 'District of Columbia', 'United States', '20022');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('7', 'customer', 'mcrawford5@tripod.com', 'pellentesque', 'Mary', 'Crawford', '1-(561)147-4896', '0 Spenser Park', 'Lake Worth', 'Florida', 'United States', '33467');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('8', 'customer', 'ecooper6@mlb.com', 'cubilia', 'Ernest', 'Cooper', '1-(214)687-7486', '56 Sachs Terrace', 'Garland', 'Texas', 'United States', '75049');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('9', 'customer', 'cmarshall7@topsy.com', 'semper', 'Carol', 'Marshall', '1-(251)323-3089', '03694 Starling Trail', 'Mobile', 'Alabama', 'United States', '36622');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('10', 'admin', 'jmartin8@java.com', 'gravida', 'Jacqueline', 'Martin', '1-(701)240-4735', '28227 Badeau Parkway', 'Fargo', 'North Dakota', 'United States', '58122');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('11', 'vendor', 'rflores9@economist.com', 'diam', 'Robin', 'Flores', '1-(608)357-6583', '77700 Forest Place', 'Madison', 'Wisconsin', 'United States', '53779');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('12', 'vendor', 'rshawa@tamu.edu', 'mus', 'Rebecca', 'Shaw', '1-(520)347-5517', '8190 Center Place', 'Tucson', 'Arizona', 'United States', '85715');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('13', 'vendor', 'jdanielsb@imgur.com', 'augue', 'Johnny', 'Daniels', '1-(731)828-9905', '5550 Sachs Drive', 'Jackson', 'Tennessee', 'United States', '38308');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('14', 'vendor', 'redwardsc@jiathis.com', 'pellentesque', 'Ruby', 'Edwards', '1-(513)194-4635', '38 Petterle Street', 'Cincinnati', 'Ohio', 'United States', '45271');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('15', 'vendor', 'cmyersd@nifty.com', 'curabitur', 'Carl', 'Myers', '1-(608)855-1945', '666 Burrows Junction', 'Madison', 'Wisconsin', 'United States', '53710');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('16', 'customer', 'pcolee@sourceforge.net', 'sapien', 'Patricia', 'Cole', '1-(717)176-0760', '2690 Sundown Terrace', 'Lancaster', 'Pennsylvania', 'United States', '17622');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('17', 'customer', 'jwarrenf@theglobeandmail.com', 'primis', 'John', 'Warren', '1-(304)702-9618', '366 School Terrace', 'Huntington', 'West Virginia', 'United States', '25775');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('18', 'vendor', 'ffoxg@economist.com', 'faucibus', 'Fred', 'Fox', '1-(757)220-7707', '4 Porter Trail', 'Norfolk', 'Virginia', 'United States', '23514');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('19', 'vendor', 'pharrish@comsenz.com', 'pharetra', 'Phillip', 'Harris', '1-(650)359-8512', '0 Thierer Place', 'Redwood City', 'California', 'United States', '94064');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('20', 'vendor', 'scolei@theguardian.com', 'morbi', 'Scott', 'Cole', '1-(951)303-0657', '78 Jay Terrace', 'Corona', 'California', 'United States', '92878');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('21', 'vendor', 'gfowlerj@slashdot.org', 'proin', 'Gerald', 'Fowler', '1-(515)167-4752', '396 Maple Wood Place', 'Des Moines', 'Iowa', 'United States', '50936');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('22', 'admin', 'admin@test.com', 'test', 'Test', 'Test', '1-(608)855-1946', '5551 Sachs Drive', 'Cincinnati', 'Tennessee', 'United States', '72447');

INSERT INTO Account (accountId, accountType, email, password, firstName, lastName, phoneNumber, streetAddress, city, provinceState, country, postalCode)
    VALUES ('23', 'admin', 'ajdanielsb@imgur.com', 'augue', 'Johnny', 'Daniels', '1-(717)176-0761', '39 Petterle Street', 'Madison', 'Ohio', 'United States', '77113');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('3', '1', '4.9');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('4', '2', '4.3');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('6', '3', '2.5');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('11', '4', '4.7');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('12', '5', '1');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('13', '6', '2');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('14', '7', '5');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('2', '8', '2');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('15', '9', '4');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('18', '10', '4');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('19', '11', '4');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('20', '12', '5');

INSERT INTO RatesVendor (customerId, vendorId, userRating)
    VALUES ('21', '13', '5');

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

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('18', '17', '2015-01-18 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('19', '16', '2015-01-19 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('20', '17', '2015-01-20 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('21', '17', '2015-01-21 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('22', '16', '2015-01-22 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('23', '17', '2015-01-23 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('24', '16', '2015-01-24 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('25', '16', '2015-01-25 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('26', '9', '2015-01-26 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('27', '8', '2015-01-27 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('28', '7', '2015-01-28 00:00:00');

INSERT INTO PartOrder (orderId, customerId, orderDate)
    VALUES ('29', '5', '2015-01-29 00:00:00');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('1', '1000457', '1', 'USPS', 'Deliver between 08:00 and 20:00', '9.95', '2015-01-01 00:00:00', 'Express', '4 Northridge Park', 'Farmington', 'Michigan', 'United States', '48335');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('2', '2000914', '2', 'CanadaPost', 'If noone is home, leave out back', '123.45', '2015-01-02 00:00:00', 'Normal', '334 Northridge Crossing', 'Tulsa', 'Oklahoma', 'United States', '74133');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('3', '4001828', '3', 'FedEx', 'If noone is home, leave out back', '456.3', '2015-01-03 00:00:00', 'Express', '1 Shopko Court', 'Tucson', 'Arizona', 'United States', '85754');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('4', '405002', '4', 'USPS', 'Deliver between 08:00 and 20:00', '32', '2015-01-04 00:00:00', 'Normal', '32 Autumn Leaf Court', 'Rochester', 'New York', 'United States', '14652');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('5', '253525', '5', 'CanadaPost', 'If noone is home, leave out back', '255.175', '2015-01-05 00:00:00', 'Normal', '8343 Packers Hill', 'Des Moines', 'Iowa', 'United States', '50320');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('6', '4653534', '6', 'FedEx', 'If noone is home, leave out back', '295.075', '2015-01-06 00:00:00', 'Express', '85 Riverside Place', 'Milwaukee', 'Wisconsin', 'United States', '53215');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('7', '432442', '7', 'USPS', 'If noone is home, leave out back', '334.975', '2015-01-07 00:00:00', 'Normal', '92 Superior Avenue', 'Johnson City', 'Tennessee', 'United States', '37605');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('8', '432423', '8', 'CanadaPost', 'If noone is home, leave out back', '374.875', '2015-01-08 00:00:00', 'Overnight', '12980 Veith Alley', 'Camden', 'New Jersey', 'United States', '8104');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('9', '35435356', '9', 'FedEx', 'Deliver between 08:00 and 20:00', '414.775', '2015-01-09 00:00:00', 'Overnight', '10 Hagan Place', 'Philadelphia', 'Pennsylvania', 'United States', '19172');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('10', '432465', '10', 'USPS', 'Deliver between 08:00 and 20:00', '454.675', '2015-01-10 00:00:00', 'Normal', '994 Fremont Road', 'Bradenton', 'Florida', 'United States', '34282');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('11', '353656', '11', 'CanadaPost', 'If noone is home, leave out back', '494.575', '2015-01-11 00:00:00', 'Express', '33 Melody Center', 'El Paso', 'Texas', 'United States', '88563');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('12', '854', '12', 'UPS', 'If noone is home, leave out back', '534.475', '2015-01-12 00:00:00', 'Overnight', '13133 Upham Way', 'Erie', 'Pennsylvania', 'United States', '16565');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('13', '12325', '13', 'USPS', 'Deliver between 08:00 and 20:00', '574.375', '2015-01-13 00:00:00', 'Normal', '194 Steensland Trail', 'Houston', 'Texas', 'United States', '77010');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('14', '533', '14', 'CanadaPost', 'If noone is home, leave out back', '614.275', '2015-01-14 00:00:00', 'Express', '26874 Bartelt Park', 'Roanoke', 'Virginia', 'United States', '24040');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('15', '53', '15', 'UPS', 'Deliver between 08:00 and 20:00', '654.175', '2015-01-15 00:00:00', 'Normal', '32 Buena Vista Park', 'Savannah', 'Georgia', 'United States', '31416');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('16', '525', '16', 'USPS', 'Deliver between 08:00 and 20:00', '694.075', '2015-01-16 00:00:00', 'Overnight', '1 Debs Crossing', 'Washington', 'District of Columbia', 'United States', '20520');

INSERT INTO Shipment (shipmentId, trackingNumber, orderId, carrier, instruction, shipCost, shipDate, shipOption, toAddress, toCity, toProvinceState, toCountry, toPostalCode)
    VALUES ('17', '25252', '17', 'USPS', 'Deliver between 08:00 and 20:00', '733.975', '2015-01-17 00:00:00', 'Overnight', '9 Jackson Trail', 'Washington', 'District of Columbia', 'United States', '20540');

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

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Hood', 'The hinged cover over the engine of motor vehicles that allows access to the engine compartment');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Roof rack', 'A roof rack is a set of bars secured to the roof of a motor car. It is used to carry bulky items');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Bumper', 'A bumper is a structure attached or integrated to the front and rear of anautomobile to absorb impact in a minor collision, ideally minimizing repair costs.');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Sunroof motor', 'An automotive sunroof is a fixed or operable (venting or sliding) opening in an automobile roof which allows light and/or fresh air to enter the passenger compartment. Sunroofs may be manually operated or motor driven, and are available in many shapes, sizes and styles.');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Decklid', 'The main storage compartment of the vehicle.');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Dashboard', 'Fascia often refers to the decorative panels of a dashboard, or the entire dashboard assembly.');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Fender', 'Fender is the American English term for the part of an automobile,motorcycle or other vehicle body that frames a wheel well ');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Windows', 'Car glass includes windscreens, side and rear windows, and glass panel roofs on a vehicle.');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Pillar', 'Pillars are the vertical or near vertical supports of the window area');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Quarter panel', 'A quarter panel (British English: rear wing) is the body panel (exterior surface) of an automobile between a rear door (or only door on each side for two-door models) and the trunk');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Radiator', 'Radiators are heat exchangers used to transfer thermal energy from one medium to another for the purpose of cooling and heating. ');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Fuel Cap', 'A fuel tank (or petrol tank) is a safe container for flammable fluids. This is the cap used to prevent leakage');

INSERT INTO PartCategory (categoryName, description)
    VALUES ('Spoiler', 'A spoiler is an automotive aerodynamic device whose intended design function is to spoil unfavorable air movement across a body of a vehicle in motion, usually described as turbulence or drag.');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('1', 'Seat', 'Red/Black Seat', 'Red and black seat', 'public/images/parts/part1.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('2', 'Brake', 'Brake Rotor - Rear', 'Brake Rotor features a patented elliptical grooves help channel awa heat, water and gases, reducing brake fade', 'public/images/parts/part2.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('3', 'Brake ', 'Brake Rotor - Front', 'Brake Rotor features a patented elliptical grooves help channel awa heat, water and gases, reducing brake fade', 'public/images/parts/part3.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('4', 'Brake', 'Sever Duty Brake Pad Set', 'Resists brake fade that can occur In extended & extreme Use', 'public/images/parts/part4.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('5', 'Engine', 'An engine specified for a Dodge made vehicle', 'Internal combustion engine made for Dodge vehicles', 'public/images/parts/part5.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('6', 'Tire', 'Car Tire', 'A tire consisting of a rubber ring around the rim of an automobile wheel', 'public/images/parts/part6.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('7', 'Wheel Rim', 'A wheel rim', 'The outer edge of a wheel, on which the tire is fitted.', 'public/images/parts/part7.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('8', 'Steering Wheel', 'A steering wheel', 'A wheel that a driver rotates in order to steer a vehicle.', 'public/images/parts/part8.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('9', 'Battery', 'A car battery', 'An automotive battery is a type of rechargeable battery that supplies electric energy to an automobile.', 'public/images/parts/part9.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('10', 'Windshield Wipers', 'Windshield wipers', 'A motor-driven device for keeping a windshield clear of rain, typically one with a rubber blade on an arm that moves in an arc.', 'public/images/parts/part10.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('11', 'Windshield', 'Protective glass', 'A window at the front of the passenger compartment of a motor vehicle.', 'public/images/parts/part11.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('12', 'Hood', 'FlipFront hood', 'The hinged cover over the engine of motor vehicles that allows access to the engine compartment', 'public/images/parts/part12.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('13', 'Roof rack', 'Rack for your roof', 'A roof rack is a set of bars secured to the roof of a motor car. It is used to carry bulky items', 'public/images/parts/part13.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('14', 'Bumper', 'Exposed Bumper', 'A bumper is a structure attached or integrated to the front and rear of anautomobile to absorb impact in a minor collision, ideally minimizing repair costs.', 'public/images/parts/part14.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('15', 'Sunroof motor', 'Automatic Sunroof', 'An automotive sunroof is a fixed or operable (venting or sliding) opening in an automobile roof which allows light and/or fresh air to enter the passenger compartment. Sunroofs may be manually operated or motor driven, and are available in many shapes, sizes and styles.', 'public/images/parts/part15.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('16', 'Decklid', 'Trunk door', 'The trunk of a a car is the vehicle\'s main storage compartment.', 'public/images/parts/part16.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('17', 'Dashboard', 'Standard issue dash', 'Fascia often refers to the decorative panels of a car\'s dashboard, or the entire dashboard assembly.', 'public/images/parts/part17.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('18', 'Fender', 'Red Fender', 'Fender is the American English term for the part of an automobile,motorcycle or other vehicle body that frames a wheel well ', 'public/images/parts/part18.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('19', 'Windows', 'Tinted windows', 'Car glass includes windscreens, side and rear windows, and glass panel roofs on a vehicle.', 'public/images/parts/part19.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('20', 'Pillar', 'Stainless-steel pillar', 'Pillars are the vertical or near vertical supports of a car\'s window area', 'public/images/parts/part20.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('21', 'Quarter panel', 'Black/red panel', 'A quarter panel (British English: rear wing) is the body panel (exterior surface) of an automobile between a rear door (or only door on each side for two-door models) and the trunk', 'public/images/parts/part21.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('22', 'Radiator', 'Core support', 'Radiators are heat exchangers used to transfer thermal energy from one medium to another for the purpose of cooling and heating. ', 'public/images/parts/part22.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('23', 'Fuel Cap', 'Black Cap', 'A fuel tank (or petrol tank) is a safe container for flammable fluids. This is the cap used to prevent leakage', 'public/images/parts/part23.jpg');

INSERT INTO Part (partId, categoryName, partName, description, imagePath)
    VALUES ('24', 'Spoiler', 'Blue/Black', 'A spoiler is an automotive aerodynamic device whose intended design function is to \'spoil\' unfavorable air movement across a body of a vehicle in motion, usually described as turbulence or drag.', 'public/images/parts/part24.jpg');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('1', '1', '847182374', 'Paypal');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('2', '2', '192347918', 'Paypal');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('3', '3', '754823793', 'Visa');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('4', '4', '234524352', 'Visa');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('5', '5', '764324547', 'Paypal');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('6', '6', '424527744', 'Visa');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('7', '7', '134468533', 'MasterCard');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('8', '8', '354678578', 'Paypal');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('9', '9', '135426547', 'MasterCard');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('10', '10', '345667687', 'Visa');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('11', '11', '234524677', 'Paypal');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('12', '12', '444563788', 'MasterCard');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('13', '13', '536875654', 'Paypal');

INSERT INTO Payment (paymentId, shipmentId, accountNumber, paymentType)
    VALUES ('14', '14', '456745689', 'MasterCard');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('1', '1', '1', '500', '250', '2015-01-01 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('2', '2', '2', '200', '100', '2015-01-02 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('3', '3', '3', '500', '100', '2015-01-03 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('4', '4', '4', '100', '120', '2015-01-04 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('5', '5', '6', '900', '600', '2015-01-05 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('6', '6', '5', '100', '500', '2015-01-06 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('7', '7', '6', '100', '600', '2015-01-07 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('8', '7', '7', '100', '100', '2015-01-08 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('9', '1', '8', '239', '200', '2015-01-09 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('10', '12', '9', '125', '383.888888889', '2015-01-10 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('11', '14', '10', '800', '403.555555556', '2015-01-11 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('12', '15', '11', '200', '423.222222222', '2015-01-12 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('13', '18', '12', '1331', '442.888888889', '2015-01-13 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('14', '19', '13', '3124', '462.555555556', '2015-01-14 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('15', '20', '14', '41515', '482.222222222', '2015-01-15 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('16', '21', '15', '51515', '501.888888889', '2015-01-16 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('17', '21', '16', '2434', '521.555555556', '2015-01-17 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('18', '21', '17', '3242', '541.222222222', '2015-01-18 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('19', '20', '18', '200', '560.888888889', '2015-01-19 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('20', '19', '19', '1234', '580.555555556', '2015-01-20 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('21', '18', '20', '123', '600.222222222', '2015-01-21 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('22', '14', '21', '22', '619.888888889', '2015-01-22 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('23', '13', '22', '10', '639.555555556', '2015-01-23 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('24', '12', '23', '300', '659.222222222', '2015-01-24 00:00:00');

INSERT INTO ListedPart (listId, vendorId, partId, quantity, price, dateListed)
    VALUES ('25', '2', '24', '10000', '678.888888889', '2015-01-25 00:00:00');

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

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('18', '2', '2');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('19', '21', '3');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('20', '18', '4');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('21', '19', '5');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('22', '17', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('23', '16', '2');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('24', '21', '3');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('25', '17', '4');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('26', '18', '5');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('27', '19', '1');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('28', '20', '4');

INSERT INTO ContainsPart (orderId, listId, quantity)
    VALUES ('28', '13', '3');

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

INSERT INTO Make (name)
    VALUES ('Chrystler ');

INSERT INTO Make (name)
    VALUES ('Tesla');

INSERT INTO Make (name)
    VALUES ('Aston Martin');

INSERT INTO Make (name)
    VALUES ('Aston Martin Lagonda');

INSERT INTO Make (name)
    VALUES ('Bristol (1946-present)');

INSERT INTO Make (name)
    VALUES ('Bentley (1919-present)');

INSERT INTO Make (name)
    VALUES ('David Brown (2013-present)');

INSERT INTO Make (name)
    VALUES ('Jaguar (1945-present)');

INSERT INTO Make (name)
    VALUES ('Land Rover (1948-present)');

INSERT INTO Make (name)
    VALUES ('Range Rover');

INSERT INTO Make (name)
    VALUES ('Rolls Royce (1904-present)');

INSERT INTO Make (name)
    VALUES ('SAAB');

INSERT INTO Make (name)
    VALUES ('Koenigsegg');

INSERT INTO Make (name)
    VALUES ('Bugatti');

INSERT INTO Make (name)
    VALUES ('Maserati');

INSERT INTO Make (name)
    VALUES ('Fiat');

INSERT INTO Make (name)
    VALUES ('Lamborghini');

INSERT INTO Make (name)
    VALUES ('Audi');

INSERT INTO Make (name)
    VALUES ('BMW');

INSERT INTO Make (name)
    VALUES ('Mercedes Benz');

INSERT INTO Make (name)
    VALUES ('Opel');

INSERT INTO Make (name)
    VALUES ('Porsche');

INSERT INTO Make (name)
    VALUES ('Abarth');

INSERT INTO Make (name)
    VALUES ('Alfa Romeo');

INSERT INTO Make (name)
    VALUES ('Citroen');

INSERT INTO Make (name)
    VALUES ('Dacia');

INSERT INTO Make (name)
    VALUES ('DS');

INSERT INTO Make (name)
    VALUES ('Hyundai');

INSERT INTO Make (name)
    VALUES ('Jeep');

INSERT INTO Make (name)
    VALUES ('Kia');

INSERT INTO Make (name)
    VALUES ('Mazda');

INSERT INTO Make (name)
    VALUES ('Mercedes-Benz');

INSERT INTO Make (name)
    VALUES ('MG');

INSERT INTO Make (name)
    VALUES ('Microcar');

INSERT INTO Make (name)
    VALUES ('MINI');

INSERT INTO Make (name)
    VALUES ('Mitsubishi');

INSERT INTO Make (name)
    VALUES ('Nissan');

INSERT INTO Make (name)
    VALUES ('Peugeot');

INSERT INTO Make (name)
    VALUES ('Renault');

INSERT INTO Make (name)
    VALUES ('SEAT');

INSERT INTO Make (name)
    VALUES ('Skoda');

INSERT INTO Make (name)
    VALUES ('Ssangyong');

INSERT INTO Make (name)
    VALUES ('Subaru');

INSERT INTO Make (name)
    VALUES ('Suzuki');

INSERT INTO Make (name)
    VALUES ('Toyota');

INSERT INTO Make (name)
    VALUES ('Vauxhall');

INSERT INTO Make (name)
    VALUES ('Volkswagen');

INSERT INTO Make (name)
    VALUES ('Volvo');

INSERT INTO Make (name)
    VALUES ('Smart');

INSERT INTO Make (name)
    VALUES ('Aixam');

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

INSERT INTO Model (name)
    VALUES ('500');

INSERT INTO Model (name)
    VALUES ('500C');

INSERT INTO Model (name)
    VALUES ('Coupe');

INSERT INTO Model (name)
    VALUES ('Crossline');

INSERT INTO Model (name)
    VALUES ('Crossover');

INSERT INTO Model (name)
    VALUES ('Giulietta');

INSERT INTO Model (name)
    VALUES ('MiTo');

INSERT INTO Model (name)
    VALUES ('A1');

INSERT INTO Model (name)
    VALUES ('A3');

INSERT INTO Model (name)
    VALUES ('Q3');

INSERT INTO Model (name)
    VALUES ('1 Series');

INSERT INTO Model (name)
    VALUES ('2 Series');

INSERT INTO Model (name)
    VALUES ('3 Series');

INSERT INTO Model (name)
    VALUES ('Berlingo');

INSERT INTO Model (name)
    VALUES ('C1');

INSERT INTO Model (name)
    VALUES ('C3');

INSERT INTO Model (name)
    VALUES ('C3 Picasso');

INSERT INTO Model (name)
    VALUES ('C4');

INSERT INTO Model (name)
    VALUES ('C4 Cactus');

INSERT INTO Model (name)
    VALUES ('C4 Picasso');

INSERT INTO Model (name)
    VALUES ('Dispatch');

INSERT INTO Model (name)
    VALUES ('Grand C4 Picasso');

INSERT INTO Model (name)
    VALUES ('Duster');

INSERT INTO Model (name)
    VALUES ('Logan MCV');

INSERT INTO Model (name)
    VALUES ('Sandero Stepway');

INSERT INTO Model (name)
    VALUES ('DS 3');

INSERT INTO Model (name)
    VALUES ('DS 3 Cabrio');

INSERT INTO Model (name)
    VALUES ('DS 4');

INSERT INTO Model (name)
    VALUES ('DS 5');

INSERT INTO Model (name)
    VALUES ('500');

INSERT INTO Model (name)
    VALUES ('500C');

INSERT INTO Model (name)
    VALUES ('500L');

INSERT INTO Model (name)
    VALUES ('500X');

INSERT INTO Model (name)
    VALUES ('Doblo');

INSERT INTO Model (name)
    VALUES ('Panda');

INSERT INTO Model (name)
    VALUES ('Qubo');

INSERT INTO Model (name)
    VALUES ('B-Max');

INSERT INTO Model (name)
    VALUES ('C-MAX');

INSERT INTO Model (name)
    VALUES ('EcoSport');

INSERT INTO Model (name)
    VALUES ('Fiesta');

INSERT INTO Model (name)
    VALUES ('Focus');

INSERT INTO Model (name)
    VALUES ('Galaxy');

INSERT INTO Model (name)
    VALUES ('Grand C-MAX');

INSERT INTO Model (name)
    VALUES ('Grand Tourneo Connect');

INSERT INTO Model (name)
    VALUES ('Ka');

INSERT INTO Model (name)
    VALUES ('Kuga');

INSERT INTO Model (name)
    VALUES ('Mondeo');

INSERT INTO Model (name)
    VALUES ('S-MAX');

INSERT INTO Model (name)
    VALUES ('Tourneo Connect');

INSERT INTO Model (name)
    VALUES ('Civic');

INSERT INTO Model (name)
    VALUES ('CR-V');

INSERT INTO Model (name)
    VALUES ('Jazz');

INSERT INTO Model (name)
    VALUES ('i10');

INSERT INTO Model (name)
    VALUES ('i20');

INSERT INTO Model (name)
    VALUES ('i30');

INSERT INTO Model (name)
    VALUES ('ix20');

INSERT INTO Model (name)
    VALUES ('ix35');

INSERT INTO Model (name)
    VALUES ('Tucson');

INSERT INTO Model (name)
    VALUES ('Renegade');

INSERT INTO Model (name)
    VALUES ('Carens');

INSERT INTO Model (name)
    VALUES ('ceed');

INSERT INTO Model (name)
    VALUES ('Picanto');

INSERT INTO Model (name)
    VALUES ('Pro ceed');

INSERT INTO Model (name)
    VALUES ('Rio');

INSERT INTO Model (name)
    VALUES ('Soul');

INSERT INTO Model (name)
    VALUES ('Sportage');

INSERT INTO Model (name)
    VALUES ('Venga');

INSERT INTO Model (name)
    VALUES ('Mazda2');

INSERT INTO Model (name)
    VALUES ('Mazda3');

INSERT INTO Model (name)
    VALUES ('Mazda6');

INSERT INTO Model (name)
    VALUES ('A-Class');

INSERT INTO Model (name)
    VALUES ('B-Class');

INSERT INTO Model (name)
    VALUES ('Citan');

INSERT INTO Model (name)
    VALUES ('GLA-Class');

INSERT INTO Model (name)
    VALUES ('Vito');

INSERT INTO Model (name)
    VALUES ('MG3');

INSERT INTO Model (name)
    VALUES ('MG6');

INSERT INTO Model (name)
    VALUES ('M-GO');

INSERT INTO Model (name)
    VALUES ('Mini');

INSERT INTO Model (name)
    VALUES ('Mini Countryman');

INSERT INTO Model (name)
    VALUES ('Mini Paceman');

INSERT INTO Model (name)
    VALUES ('ASX');

INSERT INTO Model (name)
    VALUES ('Mirage');

INSERT INTO Model (name)
    VALUES ('Outlander');

INSERT INTO Model (name)
    VALUES ('Juke');

INSERT INTO Model (name)
    VALUES ('Leaf');

INSERT INTO Model (name)
    VALUES ('Micra');

INSERT INTO Model (name)
    VALUES ('Note');

INSERT INTO Model (name)
    VALUES ('NV200');

INSERT INTO Model (name)
    VALUES ('Pulsar');

INSERT INTO Model (name)
    VALUES ('Qashqai');

INSERT INTO Model (name)
    VALUES ('X-Trail');

INSERT INTO Model (name)
    VALUES ('108');

INSERT INTO Model (name)
    VALUES ('2008');

INSERT INTO Model (name)
    VALUES ('208');

INSERT INTO Model (name)
    VALUES ('3008 Crossover');

INSERT INTO Model (name)
    VALUES ('308');

INSERT INTO Model (name)
    VALUES ('308 SW');

INSERT INTO Model (name)
    VALUES ('5008');

INSERT INTO Model (name)
    VALUES ('Partner');

INSERT INTO Model (name)
    VALUES ('Captur');

INSERT INTO Model (name)
    VALUES ('Clio');

INSERT INTO Model (name)
    VALUES ('Grand Scenic');

INSERT INTO Model (name)
    VALUES ('Kadjar');

INSERT INTO Model (name)
    VALUES ('Megane');

INSERT INTO Model (name)
    VALUES ('Scenic');

INSERT INTO Model (name)
    VALUES ('Scenic Xmod');

INSERT INTO Model (name)
    VALUES ('Twingo');

INSERT INTO Model (name)
    VALUES ('Zoe');

INSERT INTO Model (name)
    VALUES ('Alhambra');

INSERT INTO Model (name)
    VALUES ('Ibiza');

INSERT INTO Model (name)
    VALUES ('Leon');

INSERT INTO Model (name)
    VALUES ('Mii');

INSERT INTO Model (name)
    VALUES ('Toledo');

INSERT INTO Model (name)
    VALUES ('Citigo');

INSERT INTO Model (name)
    VALUES ('Fabia');

INSERT INTO Model (name)
    VALUES ('Octavia');

INSERT INTO Model (name)
    VALUES ('Rapid');

INSERT INTO Model (name)
    VALUES ('Rapid Spaceback');

INSERT INTO Model (name)
    VALUES ('Superb');

INSERT INTO Model (name)
    VALUES ('Yeti');

INSERT INTO Model (name)
    VALUES ('Yeti Outdoor');

INSERT INTO Model (name)
    VALUES ('forfour');

INSERT INTO Model (name)
    VALUES ('fortwo');

INSERT INTO Model (name)
    VALUES ('Korando');

INSERT INTO Model (name)
    VALUES ('Rexton W');

INSERT INTO Model (name)
    VALUES ('Turismo');

INSERT INTO Model (name)
    VALUES ('Forester');

INSERT INTO Model (name)
    VALUES ('XV');

INSERT INTO Model (name)
    VALUES ('Celerio');

INSERT INTO Model (name)
    VALUES ('Jimny');

INSERT INTO Model (name)
    VALUES ('S-Cross');

INSERT INTO Model (name)
    VALUES ('Swift');

INSERT INTO Model (name)
    VALUES ('Vitara');

INSERT INTO Model (name)
    VALUES ('Auris');

INSERT INTO Model (name)
    VALUES ('AYGO');

INSERT INTO Model (name)
    VALUES ('RAV4');

INSERT INTO Model (name)
    VALUES ('Verso');

INSERT INTO Model (name)
    VALUES ('Yaris');

INSERT INTO Model (name)
    VALUES ('ADAM');

INSERT INTO Model (name)
    VALUES ('Astra');

INSERT INTO Model (name)
    VALUES ('Cascada');

INSERT INTO Model (name)
    VALUES ('Corsa');

INSERT INTO Model (name)
    VALUES ('GTC');

INSERT INTO Model (name)
    VALUES ('Insignia');

INSERT INTO Model (name)
    VALUES ('Meriva');

INSERT INTO Model (name)
    VALUES ('Mokka');

INSERT INTO Model (name)
    VALUES ('Viva');

INSERT INTO Model (name)
    VALUES ('Zafira Tourer');

INSERT INTO Model (name)
    VALUES ('Beetle');

INSERT INTO Model (name)
    VALUES ('CC');

INSERT INTO Model (name)
    VALUES ('Golf');

INSERT INTO Model (name)
    VALUES ('Golf SV');

INSERT INTO Model (name)
    VALUES ('Jetta');

INSERT INTO Model (name)
    VALUES ('Passat');

INSERT INTO Model (name)
    VALUES ('Polo');

INSERT INTO Model (name)
    VALUES ('Scirocco');

INSERT INTO Model (name)
    VALUES ('Sharan');

INSERT INTO Model (name)
    VALUES ('Tiguan');

INSERT INTO Model (name)
    VALUES ('up!');

INSERT INTO Model (name)
    VALUES ('V40');

INSERT INTO Model (name)
    VALUES ('V60');

INSERT INTO Model (name)
    VALUES ('V70');

INSERT INTO Model (name)
    VALUES ('XC60');

INSERT INTO Model (name)
    VALUES ('XC70');

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

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('56', 'Abarth', '500', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('57', 'Abarth', '500C', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('58', 'Aixam', 'Coupe', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('59', 'Aixam', 'Crossline', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('60', 'Aixam', 'Crossover', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('61', 'Alfa Romeo', 'Giulietta', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('62', 'Alfa Romeo', 'MiTo', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('63', 'Audi', 'A1', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('64', 'Audi', 'A3', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('65', 'Audi', 'Q3', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('66', 'BMW', '1 Series', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('67', 'BMW', '2 Series', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('68', 'BMW', '3 Series', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('69', 'Citroen', 'Berlingo', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('70', 'Citroen', 'C1', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('71', 'Citroen', 'C3', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('72', 'Citroen', 'C3 Picasso', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('73', 'Citroen', 'C4', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('74', 'Citroen', 'C4 Cactus', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('75', 'Citroen', 'C4 Picasso', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('76', 'Citroen', 'Dispatch', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('77', 'Citroen', 'Grand C4 Picasso', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('78', 'Dacia', 'Duster', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('79', 'Dacia', 'Logan MCV', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('80', 'Dacia', 'Sandero Stepway', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('81', 'DS', 'DS 3', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('82', 'DS', 'DS 3 Cabrio', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('83', 'DS', 'DS 4', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('84', 'DS', 'DS 5', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('85', 'Fiat', '500', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('86', 'Fiat', '500C', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('87', 'Fiat', '500L', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('88', 'Fiat', '500X', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('89', 'Fiat', 'Doblo', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('90', 'Fiat', 'Panda', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('91', 'Fiat', 'Qubo', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('92', 'Ford', 'B-Max', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('93', 'Ford', 'C-MAX', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('94', 'Ford', 'EcoSport', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('95', 'Ford', 'Fiesta', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('96', 'Ford', 'Focus', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('97', 'Ford', 'Galaxy', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('98', 'Ford', 'Grand C-MAX', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('99', 'Ford', 'Grand Tourneo Connect', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('100', 'Ford', 'Ka', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('101', 'Ford', 'Kuga', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('102', 'Ford', 'Mondeo', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('103', 'Ford', 'S-MAX', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('104', 'Ford', 'Tourneo Connect', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('105', 'Honda', 'Civic', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('106', 'Honda', 'CR-V', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('107', 'Honda', 'Jazz', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('108', 'Hyundai', 'i10', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('109', 'Hyundai', 'i20', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('110', 'Hyundai', 'i30', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('111', 'Hyundai', 'ix20', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('112', 'Hyundai', 'ix35', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('113', 'Hyundai', 'Tucson', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('114', 'Jeep', 'Renegade', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('115', 'Kia', 'Carens', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('116', 'Kia', 'ceed', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('117', 'Kia', 'Picanto', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('118', 'Kia', 'Pro ceed', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('119', 'Kia', 'Rio', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('120', 'Kia', 'Soul', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('121', 'Kia', 'Sportage', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('122', 'Kia', 'Venga', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('123', 'Mazda', 'Mazda2', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('124', 'Mazda', 'Mazda3', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('125', 'Mazda', 'Mazda6', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('126', 'Mercedes-Benz', 'A-Class', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('127', 'Mercedes-Benz', 'B-Class', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('128', 'Mercedes-Benz', 'Citan', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('129', 'Mercedes-Benz', 'GLA-Class', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('130', 'Mercedes-Benz', 'Vito', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('131', 'MG', 'MG3', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('132', 'MG', 'MG6', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('133', 'Microcar', 'M-GO', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('134', 'MINI', 'Mini', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('135', 'MINI', 'Mini Countryman', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('136', 'MINI', 'Mini Paceman', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('137', 'Mitsubishi', 'ASX', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('138', 'Mitsubishi', 'Mirage', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('139', 'Mitsubishi', 'Outlander', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('140', 'Nissan', 'Juke', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('141', 'Nissan', 'Leaf', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('142', 'Nissan', 'Micra', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('143', 'Nissan', 'Note', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('144', 'Nissan', 'NV200', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('145', 'Nissan', 'Pulsar', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('146', 'Nissan', 'Qashqai', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('147', 'Nissan', 'X-Trail', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('148', 'Peugeot', '108', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('149', 'Peugeot', '2008', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('150', 'Peugeot', '208', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('151', 'Peugeot', '3008 Crossover', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('152', 'Peugeot', '308', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('153', 'Peugeot', '308 SW', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('154', 'Peugeot', '5008', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('155', 'Peugeot', 'Partner', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('156', 'Renault', 'Captur', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('157', 'Renault', 'Clio', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('158', 'Renault', 'Grand Scenic', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('159', 'Renault', 'Kadjar', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('160', 'Renault', 'Megane', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('161', 'Renault', 'Scenic', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('162', 'Renault', 'Scenic Xmod', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('163', 'Renault', 'Twingo', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('164', 'Renault', 'Zoe', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('165', 'SEAT', 'Alhambra', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('166', 'SEAT', 'Ibiza', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('167', 'SEAT', 'Leon', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('168', 'SEAT', 'Mii', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('169', 'SEAT', 'Toledo', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('170', 'Skoda', 'Citigo', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('171', 'Skoda', 'Fabia', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('172', 'Skoda', 'Octavia', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('173', 'Skoda', 'Rapid', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('174', 'Skoda', 'Rapid Spaceback', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('175', 'Skoda', 'Superb', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('176', 'Skoda', 'Yeti', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('177', 'Skoda', 'Yeti Outdoor', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('178', 'Smart', 'forfour', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('179', 'Smart', 'fortwo', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('180', 'Ssangyong', 'Korando', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('181', 'Ssangyong', 'Rexton W', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('182', 'Ssangyong', 'Turismo', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('183', 'Subaru', 'Forester', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('184', 'Subaru', 'XV', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('185', 'Suzuki', 'Celerio', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('186', 'Suzuki', 'Jimny', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('187', 'Suzuki', 'S-Cross', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('188', 'Suzuki', 'Swift', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('189', 'Suzuki', 'Vitara', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('190', 'Toyota', 'Auris', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('191', 'Toyota', 'AYGO', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('192', 'Toyota', 'RAV4', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('193', 'Toyota', 'Verso', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('194', 'Toyota', 'Yaris', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('195', 'Vauxhall', 'ADAM', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('196', 'Vauxhall', 'Astra', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('197', 'Vauxhall', 'Cascada', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('198', 'Vauxhall', 'Corsa', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('199', 'Vauxhall', 'GTC', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('200', 'Vauxhall', 'Insignia', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('201', 'Vauxhall', 'Meriva', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('202', 'Vauxhall', 'Mokka', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('203', 'Vauxhall', 'Viva', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('204', 'Vauxhall', 'Zafira Tourer', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('205', 'Volkswagen', 'Beetle', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('206', 'Volkswagen', 'CC', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('207', 'Volkswagen', 'Golf', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('208', 'Volkswagen', 'Golf SV', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('209', 'Volkswagen', 'Jetta', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('210', 'Volkswagen', 'Passat', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('211', 'Volkswagen', 'Polo', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('212', 'Volkswagen', 'Scirocco', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('213', 'Volkswagen', 'Sharan', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('214', 'Volkswagen', 'Tiguan', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('215', 'Volkswagen', 'up!', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('216', 'Volvo', 'V40', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('217', 'Volvo', 'V60', '2013');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('218', 'Volvo', 'V70', '2011');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('219', 'Volvo', 'XC60', '2012');

INSERT INTO Vehicle (vehicleId, makeName, modelName, year)
    VALUES ('220', 'Volvo', 'XC70', '2013');

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

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '3');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '4');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '5');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '6');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '7');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '8');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '9');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '10');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '11');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '12');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '13');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '14');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '15');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '16');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '17');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '18');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '19');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '20');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '21');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '22');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '23');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '24');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '26');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '27');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '28');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '29');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '30');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '31');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '32');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '33');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '34');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '35');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '36');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '37');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '38');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '39');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '40');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '41');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '42');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '43');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '44');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '45');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '46');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '47');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '48');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '49');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '50');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '51');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '52');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '53');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '54');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '55');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '1');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '2');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('1', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('2', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('3', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('4', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('5', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('6', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('7', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('8', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('9', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('10', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('11', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('12', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('13', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('14', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('15', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('16', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('17', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('18', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('19', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('20', '203');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '204');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '205');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '206');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '207');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '208');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '209');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '210');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '211');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '212');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '213');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '214');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '215');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '216');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '217');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '218');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '219');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '220');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '56');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '57');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '58');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '59');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '60');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('21', '61');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '62');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '63');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '64');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '65');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '66');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '67');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '68');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '69');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '70');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '71');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '72');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '73');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '74');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '75');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '76');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '77');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '78');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '79');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '80');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '81');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '82');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '83');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '84');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '85');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '86');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '87');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '88');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '89');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '90');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '91');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '92');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '93');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '94');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '95');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('22', '96');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '97');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '98');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '99');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '100');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '101');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '102');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '103');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '104');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '105');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '106');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '107');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '108');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '109');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '110');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '111');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '112');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '113');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '114');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '115');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '116');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '117');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '118');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '119');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '120');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '121');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '122');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '123');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '124');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '125');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '126');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '127');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '128');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '129');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '130');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '131');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '132');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '133');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '134');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '135');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '136');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '137');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '138');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '139');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '140');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '141');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '142');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '143');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '144');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '145');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '146');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '147');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '148');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('23', '149');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '150');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '151');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '152');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '153');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '154');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '155');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '156');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '157');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '158');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '159');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '160');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '161');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '162');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '163');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '164');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '165');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '166');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '167');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '168');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '169');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '170');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '171');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '172');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '173');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '174');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '175');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '176');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '177');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '178');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '179');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '180');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '181');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '182');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '183');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '184');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '185');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '186');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '187');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '188');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '189');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '190');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '191');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '192');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '193');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '194');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '195');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '196');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '197');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '198');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '199');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '200');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '201');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '202');

INSERT INTO FitsIn (partId, vehicleId)
    VALUES ('24', '203');

