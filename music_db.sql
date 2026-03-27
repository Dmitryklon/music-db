-- Жанры
CREATE TABLE genre (
  genre_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- Исполнители
CREATE TABLE artist (
  artist_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- Альбомы
CREATE TABLE album (
  album_id SERIAL PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  release_year INTEGER NOT NULL
);

-- Треки
CREATE TABLE track (
  track_id SERIAL PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  duration TIME NOT NULL,
  album_id INTEGER NOT NULL REFERENCES album(album_id)
);

-- Сборники
CREATE TABLE collection (
  collection_id SERIAL PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  release_year INTEGER NOT NULL
);

-- Связь исполнитель-жанр (M:N)
CREATE TABLE artist_genre (
  artist_id INTEGER REFERENCES artist(artist_id) ON DELETE CASCADE,
  genre_id INTEGER REFERENCES genre(genre_id) ON DELETE CASCADE,
  PRIMARY KEY (artist_id, genre_id)
);

-- Связь исполнитель-альбом (M:N)
CREATE TABLE artist_album (
  artist_id INTEGER REFERENCES artist(artist_id) ON DELETE CASCADE,
  album_id INTEGER REFERENCES album(album_id) ON DELETE CASCADE,
  PRIMARY KEY (artist_id, album_id)
);

-- Связь сборник-трек (M:N)
CREATE TABLE collection_track (
  collection_id INTEGER REFERENCES collection(collection_id) ON DELETE CASCADE,
  track_id INTEGER REFERENCES track(track_id) ON DELETE CASCADE,
  PRIMARY KEY (collection_id, track_id)
);