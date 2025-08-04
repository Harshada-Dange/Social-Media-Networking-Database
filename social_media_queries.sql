1)NON EQUI JOIN
SHOW USERS WHOSE AGE IS LESS THAN ALLOW AGE

SELECT U.UNAME,U.AGE,L.ALLOW_AGE
FROM USER_1 U
JOIN LOGIN L
ON(U.U_ID=L.U_ID)
WHERE U.AGE<L.ALLOW_AGE

SELECT * FROM USER_1
SELECT * FROM LOGIN

--------------------------------------------------------------------------------------------------
2)MINUS 
Q)FIND GROUP THAT HAVE NO GROUP MEMBERS (RETURNS GID  VALUES IN GROUP BUT NOT IN GROUP MEMBER)
SELECT GROUP_ID FROM GROUP1
MINUS
SELECT GROUP_ID FROM GROUP_MEMBER

SELECT * FROM GROUP_MEMBER
--------------------------------------------------------------------------------------------------

3)ROWID
   CORELATED  SUBQERY
SELECT (ROWID) FROM USER_1

DELETE FROM USER_1 A
WHERE ROWID!=(SELECT MAX(ROWID)FROM USER_1 B
WHERE A.U_ID=B.U_ID)

--------------------------------------------------------------------------------------------
Q4)LEFT OUTER JOIN
Q)FINDING ALL GROUP MEMBER AND THEIR GROUP
 
SELECT G.GROUP_ID,G.G_NAME,GM.GM_ID,GM.ROLE
FROM GROUP1 G LEFT JOIN GROUP_MEMBER GM
ON(G.GROUP_ID=GM.GROUP_ID)
ORDER BY GROUP_ID ASC

SELECT * FROM GROUP_MEMBER
SELECT * FROM GROUP1

-----------------------------------------------------------------------------------------------------------
5)HAVING ,GROUP BY, WHERE
Q) FIND USERS WITH NO PENDING FRIEND REQUEST
(HAVING =CONDITION,FILTER)(GROUP BY =CREATE GROUP OF SIMILAR ELEMNTS)

SELECT U_ID,COUNT(FRIENDS_ID)AS NON_PENDING_FRIENDS_COUNT
FROM FRIENDS
WHERE STATUS !='PENDING'
GROUP BY U_ID
HAVING COUNT(FRIENDS_ID)>1
----------------------------------------------------------------------------------------------------------------------

6)NVL2
IF VALUE FOUND THEN REACTED
IF NULL FOUND THEN  NO REACTION

UPDATE MESSAGE SET REACTIONTYPE = NULL WHERE REACTIONTYPE = 'null'

SELECT M_ID,MSG_TEXT,SENDER_ID,RECEIVER_ID,REACTIONTYPE,
NVL2(REACTIONTYPE,'REACTED','NO REACTION')AS REACTION_STATUS
FROM MESSAGE;

------------------------------------------------------------------------------------------------
7)CASE EXPRESSION

SELECT 
VISIT_COUNT,
CASE 
WHEN VISIT_COUNT>5000 THEN 'FAMOUS SPOT'
WHEN VISIT_COUNT BETWEEN 1200 AND 5000 THEN 'MODERATELY KNOWN'
ELSE 'LESS KNOWN' END AS DATA1 FROM LOCATION
------------------------------------------------------------------------------------------------------------
8)ANY
Q) FIND USERS OLDER THAN ANY 'R%' USER

SELECT * FROM USER_1
WHERE AGE > ANY(SELECT AGE FROM USER_1 WHERE UNAME LIKE 'R%')
---------------------------------------------------------------------------------------------------------------
9)WITH CLAUSE (WITH CLAUSE IS TEMPORARY TABLE EXPRESSION PERFROM WITHIN QUERY)


WITH
X AS (SELECT * FROM USER_1),
Y AS (SELECT UNAME,U_ID FROM X)
SELECT UNAME FROM Y


SELECT *FROM LOGIN
---------------------------------------------------------------------------------------------------------------------------------------------------
Q)10 CREATE NEW TABLE FROM EXISTING 3 TABLES

CREATE TABLE FOR ACTIVE USERS

CREATE TABLE ACTIVE_USER AS
SELECT U.UNAME,P.POST_ID,M.MSG_TEXT
FROM USER_1 U JOIN POST P
ON (U.U_ID = P.U_ID)
JOIN MESSAGE M
ON (M.POST_ID = P.POST_ID)

SELECT * FROM ACTIVE_USER

-------------------------------------------------------------------------------------------------------------------

Q1)
DISPLAY DETAILS OF USER ALONG WITH MESSAGE ALONG WITH POST 

SELECT U.U_ID,U.UNAME,P.PRIVACY,P.STATUS,M.SENDER_ID  
FROM USER_1 U JOIN POST P
ON (P.U_ID = U.U_ID)
JOIN MESSAGE M
ON (M.POST_ID = P.POST_ID)

ALTER TABLE MESSAGE ADD POST_ID NUMBER(10)
ALTER TABLE MESSAGE ADD CONSTRAINT FK_MESSAGE_POST FOREIGN KEY (POST_ID) REFERENCES POST(POST_ID)
SELECT * FROM USER_1
SELECT * FROM MESSAGE
SELECT * FROM POST
UPDATE MESSAGE 
SET POST_ID = 49
WHERE M_ID = 100
------------------------------------------------------------------------------------------------
Q2)DISLAY DETAILS OF TOP 5 USER BASED ON THEIR LIKES  WRONG

SELECT U.U_ID,U.UNAME,P.POST_ID,PL.LIKE_ID
FROM USER_1 U
JOIN POST P
ON(U.U_ID=P.U_ID)
JOIN POST_LIKES PL
ON(P.POST_ID=PL.POST_ID)
ORDER BY U.U_ID DESC
WHERE U.U_ID<=5

SELECT *
FROM (
SELECT U.U_ID,U.UNAME,COUNT(L.LIKE_ID)AS TOTAL_LIKES
FROM USER_1 U
JOIN POST P
ON(U.U_ID=P.U_ID)
JOIN POST_LIKES PL
ON(P.POST_ID=PL.POST_ID)
GROUP BY U.U_ID,U.UNAME
ORDER BY TOTAL_LIKES)
WHERE ROWNUM<=5



SELECT U.U_ID,U.UNAME,COUNT(PL.LIKE_ID)AS TOTAL_LIKES
FROM USER_1 U
JOIN POST P
ON(U.U_ID=P.U_ID)
JOIN POST_LIKES PL
ON(P.POST_ID=PL.POST_ID)
GROUP BY U.U_ID
WHERE U_ID=(SELECT MAX(U_ID) FROM USER_1)

SELECT * FROM POST
SELECT * FROM POST_LIKES


SELECT * FROM POST_LIKES

--------------------------------------------------------------------------------------------------------------

Q3)DISPLAY DETAILS OF USER ALONG WITH GROUP ALONG WITH FRIENDS

SELECT * FROM GROUP1
SELECT * FROM USER_1
SELECT * FROM FRIENDS

SELECT U.UNAME,G.G_NAME,F.STATUS
FROM USER_1 U JOIN FRIENDS F
ON(U.U_ID = F.U_ID)
JOIN GROUP1 G
ON(G.GROUP_ID = F.GROUP_ID)
----------------------------------------------------------------------------------------------------------------------------------

Q4)DISPLAY BIRTHDAY MESSAGE IN FEB ALONG WITH THEIR POST ALONG WITH THEIR USER NAME
SELECT * FROM MESSAGE

SELECT M.MSG_TEXT,P.POST_ID,U.UNAME
FROM MESSAGE M JOIN POST P
ON (M.POST_ID = P.POST_ID)
JOIN USER_1 U
ON (U.U_ID = P.U_ID)
WHERE TO_CHAR(SENDAT,'MON')='FEB' AND MSG_TEXT='Happy Birthday'

-------------------------------------------------------------------------------------------------------------------------------------------
Q5)DISPLAY DETAILS OF COUNT OF POST COUNT OF USER AS PER LOCATION

SELECT L.LOCATION_ID,L.LOCATION_NAME,COUNT(U.U_ID) AS USER_COUNT,COUNT(P.POST_ID)AS POST_COUNT
FROM USER_1 U
JOIN POST P ON (U.U_ID = P.U_ID)
JOIN PHOTOS PH 
ON (P.POST_ID=PH.POST_ID)
JOIN LOCATION L
ON(L.LOCATION_ID=PH.LOCATION_ID)
GROUP BY L.LOCATION_ID, L.LOCATION_NAME 

SELECT * FROM LOCATION
SELECT * FROM PHOTOS

--------------------------------------------------------------------------------------------
Q6) DISPLAY DETAILS OF THOSE USERS FOR MESSAGE DELIVERY STATUS IS NOT DELIVERED
SELECT * FROM MESSAGE


UPDATE MESSAGE
SET DELIVEREDAT =NULL
WHERE M_ID=81

select * from message

SELECT U.U_ID,U.UNAME,M.MSG_TEXT,DELIVEREDAT
FROM USER_1 U JOIN MESSAGE M 
ON (U.U_ID = M.U_ID)
WHERE M.DELIVEREDAT IS NULL

---------------------------------------------------------------------------------------------------------------------------
Q7) DISPLAY DETAILS OF USER ALONG WITH POST ALONG WITH MESSAGE WHERE REACTION TYPE IS DISLIKE
SELECT * FROM USER_1
SELECT * FROM POST
SELECT * FROM MESSAGE

SELECT U.UNAME,P.POST_CONTENT,M.MSG_TEXT,M.REACTIONTYPE
FROM USER_1 U JOIN POST P
ON (U.U_ID = P.U_ID)
JOIN MESSAGE M
ON (M.U_ID = U.U_ID)
WHERE M.REACTIONTYPE = 'DISLIKE'

UPDATE MESSAGE
SET REACTIONTYPE ='DISLIKE'
WHERE REACTIONTYPE = 'LIKE'

--------------------------------------------------------------------------------------------------------------------------------------------------------------
Q8)ACCEPT USER ID AND DISPLAY DETAILS FROM ALL TABLES FROM PROJECT

SELECT U.*,L.*,PR.*,P.*,PL.*,PC.*,PT.*,PH.*,L1.*,GM.*,G.*,F.*,MF.*,M.*,NM.*,N.*
FROM USER_1 U JOIN LOGIN L
ON(U.U_ID=L.U_ID)
JOIN PRIVACY1 PR
ON(L.LID=PR.LID)
JOIN POST P
ON(P.U_ID=U.U_ID)
JOIN POST_LIKES PL
ON(P.POST_ID=PL.POST_ID)
JOIN POST_COMMENTS PC
ON(P.POST_ID=PC.POST_ID)
JOIN POST_TAG PT
ON(P.POST_ID=PT.POST_ID)
JOIN PHOTOS PH
ON(P.POST_ID=PH.POST_ID)
JOIN LOCATION L1
ON(L1.LOCATION_ID=PH.LOCATION_ID)
JOIN GROUP_MEMBER GM
ON(U.U_ID=GM.U_ID)
JOIN GROUP1 G
ON(G.GROUP_ID=GM.GROUP_ID)
JOIN FRIENDS F
ON(F.GROUP_ID=G.GROUP_ID)
JOIN MESS_FRI MF
ON(MF.FRIENDS_ID=F.FRIENDS_ID)
JOIN MESSAGE M
ON(M.M_ID=MF.M_ID)
JOIN NOTI_MESS NM
ON(NM.M_ID=M.M_ID)
JOIN NOTIFICATION N
ON(N.N_ID=NM.N_ID)
WHERE LID='&X1'

-----------------------------------------------------------------------------------------------------------------
Q9)DISPLAY PRIVATE POST OF SPECIFIC USER
SELECT * FROM POST
SELECT * FROM MESSAGE

SELECT POST_CONTENT,PRIVACY FROM POST
WHERE U_ID ='&X1' AND PRIVACY ='PRIVATE'


--------------------------------------------

select department_id,department_name,employee_id,first_name
from departments natural join employees

select * from employees
select * from departments

UPDATE POST
SET PRIVACY = 'PRIVATE'
WHERE PRIVACY = 'FRIENDS'

----------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
select department_id,department_name,employee_id,first_name
from departments natural join employees
where department_name='IT'

select * from departments