test=>ALTER TABLE movies2 ADD lexemesStarring tsvector;
ALTER TABLE
test=>UPDATE movies2 SET lexemesStarring=to_tsvector(Starring);
UPDATE 5229
test=> SELECT url FROM movies2 WHERE lexemesStarring @@to_tsquery('richardson');
                  url                   
----------------------------------------
 the-edge-of-seventeen
 the-bronze
 the-central-park-five
 dumb-and-dumberer-when-harry-met-lloyd
 empire-of-the-sun
 waking-up-in-reno
 the-hard-word
 hostel
 the-king-and-i
 maggie
 maid-in-manhattan
 maleficent
 the-parent-trap
 the-prince-and-me
 time-bandits
(15 rows)
test=> ALTER TABLE movies2 ADD rank float4
ALTER TABLE
test=>Update movies2 SET rank=ts_rank(lexemesStarring,plainto_tsquery((SELECT Starring FROM movies2 WHERE url='alvi-and-the-chipmunks-chipwrecked')));
UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnStarringField AS SELECT url, rank FROM movies2 WHERE rank >-1 ORDER BY rank DESC LIMIT 50;
SELECT 50
test=> \COPY (SELECT * FROM recommendationsBasedOnStarringField) to '/home/pi/RSL/top50recommendationsStarring.csv' WITH csv;
COPY 50

