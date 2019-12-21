
WITH client_events AS (
	SELECT
		  C.id
		, COUNT(1) AS total_events

	FROM
		event.event AS E

	INNER JOIN account.client AS C ON C.id=E.client_id

	GROUP BY
		C.id
), 

client_users AS (
	SELECT
		  C.id
		, COUNT(
			  CASE WHEN U.is_anonymous=True THEN 1 ELSE NULL END
		  ) AS anonymous_user_count
		, COUNT(
			  CASE WHEN U.is_anonymous=False THEN 1 ELSE NULL END
		  ) AS user_count
		, COUNT(1) AS total_users

	FROM
		account.user AS U

	INNER JOIN account.client AS C ON C.id=U.client_id

	GROUP BY
		C.id
)

SELECT
	  C.id
	, C.name
	, C.slug
	, C.is_disabled
	, C.disabled_comment

	, C.owner_id
	, U.first_name       AS owner_first_name
	, U.last_name        AS owner_last_name
	, U.email            AS owner_email
	, U.username         AS owner_username
	, U.is_anonymous     AS owner_is_anonymous
	, U.is_disabled      AS owner_is_disabled
	, U.disabled_comment AS owner_disabled_comment

	, C.type_id
	, CT.name as type_name
	, CT.max_events
	, CT.max_event_viewers

	, CE.total_events
	, CU.anonymous_user_count
	, CU.user_count
	, CU.total_users

FROM
	account.client AS C
	
INNER JOIN account.user AS U ON U.id=C.owner_id
INNER JOIN account.client_type AS CT ON CT.id=C.type_id
INNER JOIN client_events AS CE ON CE.id=C.id
INNER JOIN client_users AS CU ON CU.id=C.id