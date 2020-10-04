--q6
SELECT count(UserID)
FROM userInfo u
WHERE u.isSeller = "True" AND u.isBuyer = "True"