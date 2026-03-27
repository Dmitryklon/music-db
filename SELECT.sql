-- 1. Самый длинный трек
SELECT title, duration
FROM track
ORDER BY duration DESC
LIMIT 1;

-- 2. Треки не менее 3.5 минут
SELECT title
FROM track
WHERE duration >= '00:03:30';

-- 3. Сборники 2018–2020
SELECT title
FROM collection
WHERE release_year BETWEEN 2018 AND 2020;

-- 4. Исполнители с именем из одного слова
SELECT name
FROM artist
WHERE name NOT LIKE '% %';

-- 5. Треки со словом "my" или "мой"
SELECT title
FROM track
WHERE LOWER(title) LIKE '%my%'
   OR LOWER(title) LIKE '%мой%';