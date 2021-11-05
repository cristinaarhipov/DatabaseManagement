/* Running the psql test */
psql test

/* Creating a table called movies1 with different columns in it in order to use it in the next codes */
CREATE TABLE movies1 (
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

/* Importing the data for the movies1 table created above from the csv file */
\COPY movies1 FROM '/home/pi/RSL/moviesFromMetacritic.csv' DELIMITER ';' CSV HEADER;

/* Selecting my favourite movie from all other movies */
SELECT * FROM movies1 WHERE url='alvin-and-the-chipmunks-chipwrecked';

/* Creating the lexemesSummary column */
ALTER TABLE movies1 ADD lexemesSummary tsvector;

/* Searching the text based on Summary to fill in the lexemesSummary column created above */
UPDATE movies1 SET lexemesSummary=to_tsvector(Summary);

/* Select movies from movies1 table where the lexemesSummary has the word "Alvin" in it to get other movies that have the word "Alvin" in the lexemesSummary */
SELECT url FROM movies1 WHERE lexemesSummary @@to_tsquery('alvin');
 
/* Adding a column rank that shows the type of data that can be entered in a specific column*/
test=> ALTER TABLE movies1 ADD rank float4;

/* Updating the table movies1 with a rank for each movie based on the user's input for movie "alvin and the cipmunks chipwrecked" */
UPDATE movies1 SET rank=ts_rank(lexemesSummary,plainto_tsquery((SELECT Summary FROM movies1 WHERE url='alvin-and-the-chipmunks-chipwrecked')));

/* Creating another table called "RecommendationsBasedOnSummaryField based on the given input, but limiting it to 50 recommendations */
CREATE TABLE recommendationsBasedOnSummaryField AS SELECT url,rank FROM movies1 WHERE rank >-1 ORDER BY rank DESC LIMIT 50;

/* Copying the Recommendations based on summary table to a separate csv file in the RSL folder. Thus, creating Top 50 recommendations based on Summary */
\COPY (SELECT * FROM recommendationsBasedOnSummaryField) to '/home/pi/RSL/top50recommendations.csv' WITH csv;


