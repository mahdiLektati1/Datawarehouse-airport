CREATE TABLE IF NOT EXISTS `Country` (
    CodeCo VARCHAR(3) NOT NULL,
    NameCo VARCHAR(50),
    PopulationCo INT(11) CHECK(PopulationCo > 0),
    PRIMARY KEY (CodeCo),
    INDEX (CodeCo)
);

CREATE TABLE IF NOT EXISTS `City` (
    CodeCi VARCHAR(5) NOT NULL,
    NameCi VARCHAR(50),
    PopulationCi INT(11) CHECK(PopulationCi > 0),
    CodeCo VARCHAR(3),
    PRIMARY KEY (CodeCi),
    FOREIGN KEY (CodeCo) REFERENCES Country(CodeCo),
    INDEX (CodeCi)
);

CREATE TABLE IF NOT EXISTS `Airport` (
    CodeAP VARCHAR(3) NOT NULL,
    NameAP VARCHAR(50),
    MaxAircraftHubSize INT(11) CHECK(MaxAircraftHubSize > 0),
    OwnrCompName VARCHAR(50),
    OwnrCompCountry VARCHAR(50),
    CodeCi VARCHAR(5),
    PRIMARY KEY (CodeAP),
    FOREIGN KEY (CodeCi) REFERENCES City(CodeCi),
    INDEX (CodeAP)
);

CREATE TABLE IF NOT EXISTS `Category` (
    CodeCa INT NOT NULL AUTO_INCREMENT,
    NameCa varchar(30),
    PRIMARY KEY (CodeCa)
);

CREATE TABLE IF NOT EXISTS `Company` (
    CodeC mediumint(9) NOT NULL,
    NameC varchar(50),
    HeadOffCity varchar(50),
    HeadOffCountry varchar(50),
    CodeAP varchar(3),
    PRIMARY KEY (CodeC),
    FOREIGN KEY (CodeAP) REFERENCES Airport(CodeAP)
);

CREATE TABLE IF NOT EXISTS `Type` (
    CodeTy INT NOT NULL AUTO_INCREMENT,
    NameTy  varchar(30),
    PRIMARY KEY (CodeTy),
    INDEX (CodeTy)
);

CREATE TABLE IF NOT EXISTS `Aircraft` (
    CodeA           varchar(6) NOT NULL,
    Manufacturer    varchar(50),   
    Model           varchar(8),
    SeatCount       int,
    LoadMax         float,
    EmptyWeight     float,
    CodeTy          int,
    AcquisYear      varchar(19),
    CodeC           mediumint(9),
    PRIMARY KEY (CodeA),
    FOREIGN KEY (CodeC) REFERENCES Company(CodeC),
    FOREIGN KEY (CodeTy) REFERENCES Type(CodeTy),
    CHECK (SeatCount >= 0),
    CHECK (LoadMax > 0),
    CHECK (EmptyWeight > 0),
    CHECK (AcquisYear <= YEAR(CURDATE())),
    INDEX (CodeA)
);

CREATE TABLE IF NOT EXISTS `Flight_Reference` (
    CodeFR varchar(8),
    FrequencyFR ENUM ('daily','daily working','day only', 'day weekend only', 'weekly', 'monthly', 'specific'),
    DistanceFR int,
    TakeOffTimeFR DATETIME CHECK(DistanceFR > 0),
    LandingTimeFR DATETIME CHECK(LandingTimeFR > TakeOffTimeFR),
    CodeCa int,
    CodeC mediumint(9),
    CodeAP_Dep varchar(3),
    CodeAP_Arr varchar(3),
    PRIMARY KEY (CodeFR),
    FOREIGN KEY (CodeAP_Dep) REFERENCES Airport(CodeAP),
    FOREIGN KEY (CodeAP_Arr) REFERENCES Airport(CodeAP),
    FOREIGN KEY (CodeCa) REFERENCES Category(CodeCa),
    FOREIGN KEY (CodeC) REFERENCES Company(CodeC),
    INDEX (CodeFR)
);

CREATE TABLE IF NOT EXISTS `Flight` (
    CodeA varchar(6),
    CodeFR varchar(8),
    DateF DATETIME CHECK(DateF <= CURDATE()),
    FlightDuration int,
    PassengerCount int,
    KeroseneWeight float,
    AircraftLoadWeight float,
    FOREIGN KEY (CodeA) REFERENCES Aircraft(CodeA),
    FOREIGN KEY (CodeFR) REFERENCES Flight_Reference(CodeFR)
);

INSERT INTO `Country` VALUES ('ANG','Angola',50000000),('CIV','Cote d\'Ivoire',20000000),('FRA','France',68000000),('NIG','Nigeria',100000000),('USA','United States of America',400000000);

INSERT INTO `City` VALUES ('ABJ','Abidjan',4000000,'CIV'),('LGS','Lagos',5000000,'NIG'),('LND','Luanda',3000000,'ANG'),('NYC','Ney York',10000000,'USA'),('PRS','Paris',2100000,'FRA'),('TLS','Toulouse',480000,'FRA');

INSERT INTO `Category` VALUES (1,'Commercial flight'),(2,'Official flight'),(3,'Cargo transport');

INSERT INTO `Type` VALUES (1,'jumbo jet'),(2,'airliner'),(3,'regional');

INSERT INTO `Airport` VALUES ('CDG','Charles de Gaulle',300,'Paris Aeroport','France','PRS'),('FHB','Felix Boigny',50,'Abijan aiport','Cote d\'ivoire','ABJ'),('LUA','Kari Airport',100,'Ango Airport','Angola','LND'),('NYA','New York Airport',500,'NYC Airport','United States','NYC'),('TLS','Toulouse Blagnac',150,'Toulouse airport','France','TLS');

INSERT INTO `Company` VALUES (110234,'AirCote','Abidjan','Cote dIvoire','FHB'),(111111,'AeroFrance','Toulouse','France','TLS'),(127658,'AirFrance','Paris','France','CDG'),(198574,'Angola Airline','Luanda','Angola','LUA'),(456789,'Delta','New York','United States of America','NYA');

INSERT INTO `Aircraft` VALUES ('AK3800','AIRBUS','ABC',300,4000,2500,2,'2019-03-11 00:00:00',198574),('AZ3455','KLMRT','ZERT',250,3000,2000,2,'2021-02-11 00:00:00',111111),('DE3455','DNTJF','ZERT',50,2000,1000,3,'2020-01-01 00:00:00',111111);

INSERT INTO `Flight_Reference` VALUES ('AC7564FR','daily',4568,'1899-12-30 12:00:00','1899-12-30 15:00:00',1,110234,'FHB','CDG'),('AF3453BC','daily',500,'1899-12-30 08:00:00','1899-12-30 09:50:00',1,127658,'CDG','TLS'),('AO3455KF','daily',674,'1899-12-30 10:00:00','1899-12-30 11:47:00',1,111111,'TLS','CDG'),('AO4987TH','weekly',700,'1899-12-30 08:00:00','1899-12-30 11:00:00',3,111111,'CDG','TLS'),('AO6894GY','monthly',2345,'1899-12-30 09:45:00','1899-12-30 13:40:00',2,111111,'TLS','CDG'),('DE4567TY','monthly',9678,'1899-12-30 09:00:00','1899-12-30 17:00:00',1,456789,'NYA','LUA'),('LU8364UH','daily',2000,'1899-12-30 14:00:00','1899-12-30 17:00:00',1,198574,'LUA','FHB');

INSERT INTO `Flight` VALUES ('AK3800','AF3453BC','2021-01-02 00:00:00',6,300,1000,4000),('AK3800','AO3455KF','2021-01-01 00:00:00',3,300,1000,4000),('AK3800','AO3455KF','2021-02-22 00:00:00',2,10,450,1000),('AK3800','AO4987TH','2021-01-03 00:00:00',4,10,500,1000),('AK3800','AO4987TH','2021-01-05 00:00:00',2,20,500,1000),('AK3800','AO4987TH','2021-01-24 00:00:00',3,300,1000,4000),('AK3800','AO6894GY','2021-01-04 00:00:00',2,10,500,1000),('AZ3455','AO3455KF','2021-02-11 00:00:00',2,25,234,2000),('AZ3455','AO4987TH','2021-01-05 00:00:00',3,10,550,1050),('AZ3455','LU8364UH','2021-03-03 00:00:00',5,250,700,3000),('DE3455','AC7564FR','2012-02-20 00:00:00',6,45,567,1500),('DE3455','DE4567TY','2021-01-23 00:00:00',4,50,500,2000);

CREATE  OR REPLACE VIEW `V_Company_Flights` AS
SELECT  C.CodeC as code,
        C.NameC as name,
        C.HeadOffCountry as head_office_country,
        COUNT(*) as total_number_flights_operated
  FROM  Company C,
        Flight_Reference FR
 WHERE  FR.CodeC = C.CodeC
 GROUP BY C.CodeC, C.NameC, C.HeadOffCountry
 ORDER BY C.HeadOffCountry;

 CREATE  OR REPLACE VIEW `V_Companies_Daily2021` AS
SELECT DISTINCT 
        C.CodeC as code,
        C.NameC as name
  FROM  Company             C,
        Flight_Reference    FR,
        Flight              F
 WHERE  FR.CodeC = C.CodeC
   AND  F.CodeFR = FR.CodeFR
   AND  FR.FrequencyFR = 'daily'
   AND  YEAR(F.DateF) = 2021
 ORDER BY C.NameC;

 CREATE  OR REPLACE VIEW `V_AeroFrance_Flights_01-2021` AS
SELECT  A.CodeA as code,
        A.Model as model,
        COUNT(*) as total_number_flights
  FROM  Aircraft            A,
        Flight              F,
        Flight_Reference    FR,
        Company             C
 WHERE  F.CodeA = A.CodeA
   AND  FR.CodeFR = F.CodeFR
   AND  C.CodeC = FR.CodeC
   AND  DATE_FORMAT(F.DateF, '%m-%Y') = '01-2021'
   AND  UPPER(C.NameC) = 'AEROFRANCE'
 GROUP BY A.CodeA, A.Model HAVING COUNT(*) > 4
 ORDER BY A.CodeA;

 CREATE  OR REPLACE VIEW `V_Company_Flight_Stats` AS
SELECT  YEAR(F.DateF) as year,
        C.CodeC as code,
        C.NameC as name,
        (SELECT  COUNT(*) 
           FROM  Flight              F1,
                 Flight_Reference    FR1
          WHERE  FR1.CodeC = FR.CodeC
            AND  FR1.CodeFR = F1.CodeFR
            AND  YEAR(F1.DateF) = YEAR(F.DateF)
            AND  FR1.FrequencyFR IN ('daily', 'day only', 'daily working')) / COUNT(*) * 100 as perc_daily_flights,
        (SELECT  COUNT(*) 
           FROM  Flight              F2,
                 Flight_Reference    FR2
          WHERE  FR2.CodeC = FR.CodeC
            AND  FR2.CodeFR = F2.CodeFR
            AND  YEAR(F2.DateF) = YEAR(F.DateF)
            AND  FR2.FrequencyFR = 'weekly') / COUNT(*) * 100 as perc_weekly_flights,
        (SELECT  COUNT(*) 
           FROM  Flight              F3,
                 Flight_Reference    FR3
          WHERE  FR3.CodeC = FR.CodeC
            AND  FR3.CodeFR = F3.CodeFR
            AND  YEAR(F3.DateF) = YEAR(F.DateF)
            AND  FR3.FrequencyFR = 'monthly') / COUNT(*) * 100 as perc_monthly_flights,
        AVG(F.FlightDuration) as avg_duration,
        AVG(DistanceFR) as avg_distance,
        COUNT(*) as total_number_flights_operated
  FROM  Company C,
        Flight_Reference    FR,
        Flight              F
 WHERE  FR.CodeC = C.CodeC
   AND  F.codeFR = FR.codeFR
 GROUP BY YEAR(F.DateF), C.CodeC, C.NameC
 ORDER BY YEAR(F.DateF) DESC, C.NameC, COUNT(*);

 CREATE  OR REPLACE VIEW `V_Global` AS
SELECT  DISTINCT 
        AC.CodeA,
        AC.Manufacturer,
        AC.Model,
        AC.SeatCount,
        AC.LoadMax,
        AC.EmptyWeight,
        AC.AcquisYear,
        AP.CodeAP,
        AP.NameAP,
        AP.MaxAircraftHubSize,
        AP.OwnrCompName,
        AP.OwnrCompCountry,
        CAT.CodeCa,
        CAT.NameCa,
        F.DateF,
        F.FlightDuration,
        F.PassengerCount,
        F.KeroseneWeight,
        F.AircraftLoadWeight,
        CP_aircraft.CodeC as CodeC_CP_aircraft,
        CP_aircraft.NameC as NameC_CP_aircraft,
        CP_aircraft.HeadOffCity as HeadOffCity_CP_aircraft,
        CP_aircraft.HeadOffCountry as HeadOffCountry_CP_aircraft,
        CP_aircraft.CodeAP as CodeAP_CP_aircraft,
        CP_flight.CodeC as CodeC_CP_flight,
        CP_flight.NameC as NameC_CP_flight,
        CP_flight.HeadOffCity as HeadOffCity_CP_flight,
        CP_flight.HeadOffCountry as HeadOffCountry_CP_flight,
        CP_flight.CodeAP as CodeAP_CP_flight,
        FR.CodeFR,
        FR.FrequencyFR,
        FR.DistanceFR,
        FR.TakeOffTimeFR,
        FR.LandingTimeFR,
        T.CodeTy,
        T.NameTy,
        CT_aircraft_company.NameCi as NameCi_aircraft_company,
        CT_aircraft_company.PopulationCi as PopulationCi_aircraft_company,
        CT_aircraft_company.CodeCo as CodeCo_aircraft_company,
        CO_aircraft_company.NameCo as NameCo_aircraft_company,
        CO_aircraft_company.PopulationCo as PopulationCo_aircraft_company,
        AP_dep.CodeAP as CodeAP_dep,
        AP_dep.NameAP as NameAP_dep,
        AP_dep.MaxAircraftHubSize as MaxAircraftHubSize_dep,
        AP_dep.OwnrCompName as OwnrCompName_dep,
        AP_dep.OwnrCompCountry as OwnrCompCountry_dep,
        AP_dep.CodeCi as CodeCi_dep,
        AP_arr.CodeAP as CodeAP_arr,
        AP_arr.NameAP as NameAP_arr,
        AP_arr.MaxAircraftHubSize as MaxAircraftHubSize_arr,
        AP_arr.OwnrCompName as OwnrCompName_arr,
        AP_arr.OwnrCompCountry as OwnrCompCountry_arr,
        AP_arr.CodeCi as CodeCi_arr,
        CT_dep.NameCi as NameCi_dep,
        CT_dep.PopulationCi as PopulationCi_dep,
        CT_dep.CodeCo as CodeCo_dep,
        CT_arr.NameCi as NameCi_arr,
        CT_arr.PopulationCi as PopulationCi_arr,
        CT_arr.CodeCo as CodeCo_arr,
        CO_dep.NameCo as NameCo_dep,
        CO_dep.PopulationCo as PopulationCo_dep,
        CO_arr.NameCo as NameCo_arr,
        CO_arr.PopulationCo as PopulationCo_arr
  FROM  
        Flight F
            LEFT JOIN Aircraft AC ON F.CodeA = AC.CodeA
            LEFT JOIN Type T ON AC.CodeTy = T.CodeTy
            LEFT JOIN Company CP_aircraft ON AC.CodeC = CP_aircraft.CodeC
            LEFT JOIN Airport AP ON CP_aircraft.CodeAP = AP.CodeAP
            LEFT JOIN City CT_aircraft_company ON CT_aircraft_company.CodeCi = AP.CodeCi
            LEFT JOIN Country CO_aircraft_company ON CT_aircraft_company.CodeCo = CO_aircraft_company.CodeCo,
        Flight_Reference FR
            LEFT JOIN Airport AP_dep ON FR.CodeAP_Dep = AP_dep.CodeAP
            LEFT JOIN Airport AP_arr ON FR.CodeAP_Arr = AP_arr.CodeAP
            LEFT JOIN City CT_dep ON AP_dep.CodeCi = CT_dep.CodeCi
            LEFT JOIN City CT_arr ON AP_arr.CodeCi = CT_arr.CodeCi
            LEFT JOIN Country CO_dep ON CT_dep.CodeCo = CO_dep.CodeCo
            LEFT JOIN Country CO_arr ON CT_arr.CodeCo = CO_arr.CodeCo
            LEFT JOIN Category CAT ON FR.CodeCa = CAT.CodeCa
            LEFT JOIN Company CP_flight ON FR.CodeC = CP_flight.CodeC
 WHERE  F.CodeFR = FR.CodeFR;
