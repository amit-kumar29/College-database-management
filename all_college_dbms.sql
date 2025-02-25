-- Create STUDENT table
CREATE TABLE STUDENT (
    USN VARCHAR(10) PRIMARY KEY,
    SNAME VARCHAR(25),
    ADDRESS VARCHAR(25),
    PHONE VARCHAR(10),
    GENDER CHAR(1)
);

-- Create SEMSEC table
CREATE TABLE SEMSEC (
    SSID VARCHAR(5) PRIMARY KEY,
    SEM NUMBER(2),
    SEC CHAR(1)
);

-- Create CLASS table
CREATE TABLE CLASS (
    USN VARCHAR(10),
    SSID VARCHAR(5),
    PRIMARY KEY (USN, SSID),
    FOREIGN KEY (USN) REFERENCES STUDENT(USN),
    FOREIGN KEY (SSID) REFERENCES SEMSEC(SSID)
);

-- Create SUBJECT table
CREATE TABLE SUBJECT (
    SUBCODE VARCHAR(8) PRIMARY KEY,
    TITLE VARCHAR(20),
    SEM NUMBER(2),
    CREDITS NUMBER(2)
);

-- Create IAMARKS table
CREATE TABLE IAMARKS (
    USN VARCHAR(10),
    SUBCODE VARCHAR(8),
    SSID VARCHAR(5),
    TEST1 NUMBER(2),
    TEST2 NUMBER(2),
    TEST3 NUMBER(2),
    FINALIA NUMBER(3),
    PRIMARY KEY (USN, SUBCODE, SSID),
    FOREIGN KEY (USN) REFERENCES STUDENT(USN),
    FOREIGN KEY (SUBCODE) REFERENCES SUBJECT(SUBCODE),
    FOREIGN KEY (SSID) REFERENCES SEMSEC(SSID)
);

-- Insert values into STUDENT table
INSERT INTO STUDENT VALUES ('lcg15cs001', 'Abhi', 'tumkur', '9875698410', 'M');
INSERT INTO STUDENT VALUES ('lcg15cs002', 'Amulya', 'Gubbi', '8896557412', 'F');
INSERT INTO STUDENT VALUES ('lcg16me063', 'Chethan', 'Nitur', '7894759522', 'M');
INSERT INTO STUDENT VALUES ('lcg14ec055', 'Raghavi', 'Sspuram', '9485675521', 'F');
INSERT INTO STUDENT VALUES ('lcg15ee065', 'Sanjay', 'Bangalore', '9538444404', 'M');

-- Insert values into SEMSEC table
INSERT INTO SEMSEC VALUES ('5A', 5, 'A');
INSERT INTO SEMSEC VALUES ('3B', 3, 'B');
INSERT INTO SEMSEC VALUES ('7A', 7, 'A');
INSERT INTO SEMSEC VALUES ('2C', 2, 'C');
INSERT INTO SEMSEC VALUES ('4B', 4, 'B');
INSERT INTO SEMSEC VALUES ('4C', 4, 'C');

-- Insert values into CLASS table
INSERT INTO CLASS VALUES ('lcg15cs001', '5A');
INSERT INTO CLASS VALUES ('lcg15cs002', '5A');
INSERT INTO CLASS VALUES ('lcg16me063', '3B');
INSERT INTO CLASS VALUES ('lcg14ec055', '7A');
INSERT INTO CLASS VALUES ('lcg15ee065', '3B');
INSERT INTO CLASS VALUES ('lcg15ee065', '4C');
INSERT INTO CLASS VALUES ('lcg15cs002', '4C');

-- Insert values into SUBJECT table
INSERT INTO SUBJECT VALUES ('10CS81', 'ACA', 8, 4);
INSERT INTO SUBJECT VALUES ('15cs53', 'Dbms', 5, 4);
INSERT INTO SUBJECT VALUES ('15cs33', 'ds', 3, 4);
INSERT INTO SUBJECT VALUES ('15cs34', 'Co', 3, 4);
INSERT INTO SUBJECT VALUES ('15cs158', 'Dba', 5, 2);
INSERT INTO SUBJECT VALUES ('10cs71', 'Oomd', 7, 4);

-- Insert values into IAMARKS table
INSERT INTO IAMARKS VALUES ('lcg15cs001', '15cs53', '5A', 18, 19, 15, NULL);
INSERT INTO IAMARKS VALUES ('lcg15cs002', '15cs53', '5A', 15, 16, 14, NULL);
INSERT INTO IAMARKS VALUES ('lcg16me063', '15cs33', '3B', 10, 15, 16, NULL);
INSERT INTO IAMARKS VALUES ('lcg14ec055', '10cs71', '7A', 18, 20, 21, NULL);
INSERT INTO IAMARKS VALUES ('lcg15ee065', '15cs33', '3B', 16, 20, 17, NULL);
INSERT INTO IAMARKS VALUES ('lcg15ee065', '15cs53', '4C', 19, 20, 18, NULL);

-- 1. List all the student details studying in fourth semester ‘C’ section.
SELECT s.USN, s.SName, s.Address, s.Phone, s.Gender
FROM STUDENT s
JOIN CLASS c ON s.USN = c.USN
JOIN SEMSEC ss ON c.SSID = ss.SSID
WHERE ss.Sem = 4 AND ss.Sec = 'C';

-- 2. Compute the total number of male and female students in each semester and in each section.
SELECT ss.Sem, ss.Sec, s.Gender, COUNT(*) AS Total
FROM STUDENT s
JOIN CLASS c ON s.USN = c.USN
JOIN SEMSEC ss ON c.SSID = ss.SSID
GROUP BY ss.Sem, ss.Sec, s.Gender
ORDER BY ss.Sem, ss.Sec, s.Gender;

-- 3. Create a view of Test1 marks of student USN ‘1BI15CS101’ in all subjects.
CREATE VIEW Test1Marks AS
SELECT Subcode, Test1
FROM IAMARKS
WHERE USN = '1BI15CS101';

-- To see the view
SELECT * FROM Test1Marks;

-- 4. Calculate the FinalIA (average of best two test marks) and update the corresponding table for all students.
UPDATE IAMARKS
SET FinalIA = (
    SELECT ROUND((GREATEST(Test1, Test2, Test3) + LEAST(GREATEST(Test1, Test2), GREATEST(Test2, Test3), GREATEST(Test1, Test3))) / 2.0)
)
WHERE FinalIA IS NULL;

-- 5. Categorize students based on the following criterion for 8th semester A, B, and C section students:
--    If FinalIA = 17 to 20 then CAT = ‘Outstanding’
--    If FinalIA = 12 to 16 then CAT = ‘Average’
--    If FinalIA < 12 then CAT = ‘Weak’

SELECT s.USN, s.SName, s.Address, s.Phone, s.Gender,
       CASE 
           WHEN ia.FinalIA BETWEEN 17 AND 20 THEN 'Outstanding'
           WHEN ia.FinalIA BETWEEN 12 AND 16 THEN 'Average'
           ELSE 'Weak'
       END AS CAT
FROM STUDENT s
JOIN CLASS c ON s.USN = c.USN
JOIN SEMSEC ss ON c.SSID = ss.SSID
JOIN IAMARKS ia ON s.USN = ia.USN
JOIN SUBJECT sub ON ia.Subcode = sub.Subcode
WHERE ss.Sem = 8 AND ss.Sec IN ('A', 'B', 'C');
