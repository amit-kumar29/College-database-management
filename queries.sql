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
