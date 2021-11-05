/* Running the psql test */
psql test

/* Creating a table called movies2 with different columns in it in order to use it in the next codes */
Create TABLE movies2 (
url text,
title text,
ReleaseDate text,
Distributor text,
Starring text,
Summary text,
Director text,
Genre text,
Rating text,
Runtime text,
Userscore text,
Metascore text,
scoreCounts text
);

/* Importing the data for the movies2 table created above from the csv file */                                 ^
\COPY movies2 FROM '/home/pi/RSL/moviesFromMetacritic.csv' DELIMITER ';' CSV HEADER;

/* Selecting my favourite movie from all other movies */
SELECT * FROM movies2 WHERE url='alvin-and-the-chipmunks-chipwrecked';

/* Creating the lexemesTitle column */
ALTER TABLE movies2 ADD lexemesTitle tsvector;

/* Searching the text based on Title to fill in the lexemesTitle column created above */
UPDATE movies2 SET lexemesTitle=to_tsvector(Title);

/* Select movies from movies2 table where the lexemesTitle has the word "Alvin" in it to get other movies that have the word "Alvin" in the lexemesTitle */
SELECT url FROM movies2 WHERE lexemesTitle @@to_tsquery('alvin');

/* Adding a column rank that shows the type of data that can be entered in a specific column*/
ALTER TABLE movies2 ADD rank float4;

/* Updating the table movies2 with a rank for each movie based on the user's input for movie "alvin and the cipmunks chipwrecked" */
test=> UPDATE movies2 SET rank=ts_rank(lexemesTitle,plainto_tsquery((SELECT Title FROM movies2 WHERE url='alvin-and-the-chipmunks-chipwrecked')));

*/ Creating another table called "RecommendationsBasedOnTitleField based on the given input, but limiting it to 50 recommendations */
CREATE TABLE recommendationsBasedOnTitleField1 AS SELECT url, rank FROM movies2 WHERE rank >-1 ORDER BY rank DESC LIMIT 50;

/* Copying the Recommendations based on Title table to a separate csv file in the RSL folder. Thus, creating Top 50 recommendations based on title */
\COPY (SELECT * FROM recommendationsBasedOnTitleField1) to '/home/pi/RSL/top50recommendationsTitle.csv' WITH csv;

