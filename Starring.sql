/* Because we created the table movies2 when creating the top 50 recommendations based on Title, I skipped some steps and moved directly to step where I Alter Table */
/* Creating the lexemesTitle column */
ALTER TABLE movies2 ADD lexemesStarring tsvector;

/* Searching the text based on Title to fill in the lexemesTitle column created above */
UPDATE movies2 SET lexemesStarring=to_tsvector(Starring);

/* Select movies from movies2 table where the lexemesStarring has the actor "richardson" in it to get other movies that have the actor "richardson" in the lexemesStarring */
SELECT url FROM movies2 WHERE lexemesStarring @@to_tsquery('richardson');

/* Adding a column rank that shows the type of data that can be entered in a specific column*/
ALTER TABLE movies2 ADD rank float4

/* Updating the table movies2 with a rank for each movie based on the user's input for movie "alvin and the cipmunks chipwrecked" */
Update movies2 SET rank=ts_rank(lexemesStarring,plainto_tsquery((SELECT Starring FROM movies2 WHERE url='alvi-and-the-chipmunks-chipwrecked')));

/* Creating another table called "RecommendationsBasedOnStarringField based on the given input, but limiting it to 50 recommendations */
CREATE TABLE recommendationsBasedOnStarringField AS SELECT url, rank FROM movies2 WHERE rank >-1 ORDER BY rank DESC LIMIT 50;

/* Copying the Recommendations based on Starring table to a separate csv file in the RSL folder. Thus, creating Top 50 recommendations based on Starring */
\COPY (SELECT * FROM recommendationsBasedOnStarringField) to '/home/pi/RSL/top50recommendationsStarring.csv' WITH csv;


