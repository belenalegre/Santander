WITH MostLoggedUser AS (
		SELECT TOP 10 u.USER_ID, count(s.SESSION_ID) AS Q_SESS_WithLOGIN
        FROM SESSIONS s
        INNER JOIN USERS u ON (s.USER_ID = u.USER_ID)
        --WHERE DATEPART(s.SERVER_TIME, month) = DATEPART(getdate(), month)
        GROUP BY u.USER_ID
        ORDER BY count(s.SESSION_ID) DESC
)

SELECT 
	(
      	SELECT 
      		COUNT(A.SESSION_ID) 
      	FROM SESSIONS A
    ) AS AllSessions,
    (
      	SELECT 
        	count(A.SESSION_ID) AS OtherSessions
        FROM SESSIONS A
        INNER JOIN MostLoggedUser B ON (A.USER_ID = B.USER_ID)
        INNER JOIN dimEVENTS E ON (A.EVENT_ID = E.EVENT_ID)
        WHERE 
          E.EVENT_DESCRIPTION != 'Login' AND
          A.TIME_SPENT >= 5 AND
      	  DATEADD(day, -1, DATEPART(E.SERVER_TIME, DATE)) IN (SELECT DISTINCT DATEPART(C.SERVER_TIME,DATE) FROM SESSIONS C WHERE C.USER_ID = A.USER_ID)
    ) as OtherSessions,
    FORMAT((
      	SELECT 
        	1.0 * count(A.SESSION_ID) AS OtherSessions
        FROM SESSIONS A
        INNER JOIN MostLoggedUser B ON (A.USER_ID = B.USER_ID)
        INNER JOIN dimEVENTS E ON (A.EVENT_ID = E.EVENT_ID)
        WHERE 
          E.EVENT_DESCRIPTION != 'Login' AND
          A.TIME_SPENT >= 5
    )/(
      	SELECT 
      		1.0 * COUNT(A.SESSION_ID)
      	FROM SESSIONS A
    ),'P3') AS Perc_KPI_RET;



