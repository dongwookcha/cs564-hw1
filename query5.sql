--q5
SELECT count(distinct UserID)
FROM userInfo u
WHERE u.Rating > 1000 AND u.isSeller = "True";

