-- =========================
-- СОЗДАНИЕ ТАБЛИЦ
-- =========================

CREATE TABLE genre (
  genre_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE artist (
  artist_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE album (
  album_id SERIAL PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  release_year INTEGER NOT NULL
);

CREATE TABLE track (
  track_id SERIAL PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  duration TIME NOT NULL,
  album_id INTEGER NOT NULL REFERENCES album(album_id)
);

CREATE TABLE collection (
  collection_id SERIAL PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  release_year INTEGER NOT NULL
);

CREATE TABLE artist_genre (
  artist_id INTEGER REFERENCES artist(artist_id) ON DELETE CASCADE,
  genre_id INTEGER REFERENCES genre(genre_id) ON DELETE CASCADE,
  PRIMARY KEY (artist_id, genre_id)
);

CREATE TABLE artist_album (
  artist_id INTEGER REFERENCES artist(artist_id) ON DELETE CASCADE,
  album_id INTEGER REFERENCES album(album_id) ON DELETE CASCADE,
  PRIMARY KEY (artist_id, album_id)
);

CREATE TABLE collection_track (
  collection_id INTEGER REFERENCES collection(collection_id) ON DELETE CASCADE,
  track_id INTEGER REFERENCES track(track_id) ON DELETE CASCADE,
  PRIMARY KEY (collection_id, track_id)
);

-- =========================
-- ЗАПОЛНЕНИЕ ДАННЫХ
-- =========================

INSERT INTO genre (name)
VALUES
('Pop'),
('Hip-Hop'),
('Rock');

INSERT INTO artist (name)
VALUES
('Adele'),
('Drake'),
('Coldplay'),
('Eminem');

INSERT INTO album (title, release_year)
VALUES
('25', 2015),
('Scorpion', 2018),
('Parachutes', 2000);

INSERT INTO track (title, duration, album_id)
VALUES
('Hello', '00:05:00', 1),
('My Life', '00:03:30', 2),
('Gods Plan', '00:03:00', 2),
('Yellow', '00:04:20', 3),
('Fix You', '00:05:00', 3),
('My Song', '00:04:00', 1);

INSERT INTO collection (title, release_year)
VALUES
('Best of 2018', 2018),
('Hits 2019', 2019),
('Top 2020', 2020),
('Modern Classics', 2021);

INSERT INTO artist_genre (artist_id, genre_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 2);

INSERT INTO artist_album (artist_id, album_id)
VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO collection_track (collection_id, track_id)
VALUES
(1, 1),
(1, 4),
(2, 2),
(2, 3),
(3, 5),
(4, 6);