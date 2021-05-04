-- Используйте таблицу checks и разделите всех покупателей на сегменты:

-- А — средний чек покупателя менее 5 ₽
-- B — средний чек покупателя от 5-10 ₽
-- C — средний чек покупателя от 10-20 ₽
-- D — средний чек покупателя более 20 ₽

-- Затем используйте этот запрос как подзапрос и посчитайте, сколько клиентов приходится на каждый 
-- сегмент и сколько доходов он приносит. Отсортируйте результат по убыванию суммы доходов на сегмент

SELECT segments, count(UserID) as user_count, sum(summa_rub) as sum_rub from(
SELECT UserID, avg_rub, summa_rub,
    CASE
        WHEN avg_rub < 5 THEN 'A' 
        WHEN avg_rub >= 5 and avg_rub < 10 THEN 'B'
        WHEN avg_rub >= 10 and avg_rub < 20 THEN 'C'
        ELSE 'D'
    END AS segments
FROM
(SELECT UserID, AVG(Rub) as avg_rub, sum(Rub) as summa_rub FROM checks group by UserID)) group by segments order by sum_rub desc limit 10


-- Пользователи пришедшие из какого источника совершили наибольшее число покупок?

SELECT Source, COUNT(one.UserID) AS buys
FROM checks AS one
JOIN devices AS two
	ON one.UserID = two.UserID
JOIN installs AS three
	ON two.DevicesID = three.DevicesID
GROUP BY three.Source AS Source
ORDER BY buys DESC
LIMIT 10


-- Проверим, сколько товаров (events) в среднем просматривают пользователи с разных платформ 
-- (Platform), и пришедшие из разных источников  (Source). Отсортируйте полученную табличку по 
-- убыванию среднего числа просмотров.

SELECT Platform, Source, AVG(one.events) AS avg_events
FROM events AS one
JOIN installs AS two
	ON one.DeviceID = two.DeviceID
GROUP BY
	two.Platform AS Platform
	two.Source AS Source
ORDER BY
	avg_events DESC
LIMIT 1000