DROP TABLE messages;
CREATE TABLE messages
(
    user_id INT PRIMARY KEY NOT NULL,
    user_name VARCHAR(50) NOT NULL,
    user_surname VARCHAR(50) NOT NULL,
    message VARCHAR(100),
    sent_by VARCHAR(50)
);

COPY messages FROM '/Users/jorgequintana/Documents/GitHub/Bets/data/messages.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM messages;

DROP TABLE passwords;
CREATE TABLE passwords
(
    user_id INT PRIMARY KEY NOT NULL,
    user_name VARCHAR(50) NOT NULL,
    user_surname VARCHAR(50) NOT NULL,
    user_registered VARCHAR(100),
    password_registered VARCHAR(50)
);

COPY passwords FROM '/Users/jorgequintana/Documents/GitHub/Bets/data/passwords.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM passwords;

DROP TABLE bookmarks;
CREATE TABLE bookmarks
(
    bookmark_id INT PRIMARY KEY NOT NULL,
    bookmark_name VARCHAR(50) NOT NULL,
    include     VARCHAR(4) NOT NULL
);

COPY bookmarks FROM '/Users/jorgequintana/Documents/GitHub/Bets/data/bookmarks.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM bookmarks;

DROP TABLE sports;
CREATE TABLE sports
(
    sport_id INT PRIMARY KEY NOT NULL,
    sport_name VARCHAR(50) NOT NULL
);

COPY sports FROM '/Users/jorgequintana/Documents/GitHub/Bets/data/sports.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM sports;

DROP TABLE bets;
CREATE TABLE bets
(
    bet_id INT PRIMARY KEY NOT NULL,
    region_name VARCHAR(50) NOT NULL,
    country_name VARCHAR(50) NOT NULL,
    league_name VARCHAR(50) NOT NULL,
    event_id INT NOT NULL,
    value INT NOT NULL
);

COPY bets FROM '/Users/jorgequintana/Documents/GitHub/Bets/data/events.csv' DELIMITER ',' CSV HEADER;
SELECT * FROM bets;