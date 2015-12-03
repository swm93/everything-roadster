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
        ON UPDATE No Action
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
