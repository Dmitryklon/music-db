-- 1. Количество исполнителей в каждом жанре
SELECT g.name AS genre, COUNT(ag.artist_id) AS artist_count
FROM genre g
JOIN artist_genre ag ON g.genre_id = ag.genre_id
GROUP BY g.name;

-- 2. Количество треков в альбомах 2019–2020
SELECT COUNT(t.track_id) AS track_count
FROM track t
JOIN album a ON t.album_id = a.album_id
WHERE a.release_year BETWEEN 2019 AND 2020;

-- 3. Средняя продолжительность треков по альбомам
SELECT a.title AS album, AVG(t.duration) AS avg_duration
FROM album a
JOIN track t ON a.album_id = t.album_id
GROUP BY a.title;

-- 4. Исполнители без альбомов в 2020 году
SELECT ar.name
FROM artist ar
WHERE ar.artist_id NOT IN (
    SELECT aa.artist_id
    FROM artist_album aa
    JOIN album al ON aa.album_id = al.album_id
    WHERE al.release_year = 2020
);

-- 5. Сборники с исполнителем Drake
SELECT DISTINCT c.title
FROM collection c
JOIN collection_track ct ON c.collection_id = ct.collection_id
JOIN track t ON ct.track_id = t.track_id
JOIN album a ON t.album_id = a.album_id
JOIN artist_album aa ON a.album_id = aa.album_id
JOIN artist ar ON aa.artist_id = ar.artist_id
WHERE ar.name = 'Drake';