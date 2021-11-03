test=> Create TABLE movies2 (
test(> url text,
test(> title text,
test(> ReleaseDate text,
test(> Distributor text,
test(> Starring text,
test(> Summary text,
test(> Director text,
test(> Genre text,
test(> Rating text,
test(> Runtime text,
test(> Userscore text,
test(> Metascore text,
test(> scoreCounts text
test(> );
CREATE TABLE
test=> \Copy movies2 FROM '/home/pi/RSL/moviesFromMetaCritic.csv' DELIMITER ';' CSV HEADER;
/home/pi/RSL/moviesFromMetaCritic.csv: No such file or directory
test=> \COPY movies2 FROM '/home/pi/RSL/moviesFromMetacritic.csv' DELIMIER ';' CSV HEADER;
ERROR:  syntax error at or near "DELIMIER"
LINE 1: COPY  movies2 FROM STDIN DELIMIER ';' CSV HEADER;
                                 ^
test=> \COPY movies2 FROM '/home/pi/RSL/moviesFromMetacritic.csv' DELIMITER ';' CSV HEADER;
COPY 5229
test=> SELECT * FROM movies2 WHERE url='alvin=and-the-chipmunks-chipwrecked';
 url | title | releasedate | distributor | starring | summary | director | genre | rating | runtime | userscore | metascore | scorecounts 
-----+-------+-------------+-------------+----------+---------+----------+-------+--------+---------+-----------+-----------+-------------
(0 rows)

test=> SELECT * FROM movies2 WHERE url='alvin-and-the-chipmunks-chipwrecked';
test=> ALTER TABLE movies2 ADD lexemesTitle tsvector;
ALTER TABLE
test=> UPDATE movies2 SET lexemesTitle=to_tsvector(Title);
UPDATE 5229
test=> SELECT url FROM movies2 WHERE lexemesTitle @@to_tsquery('alvin');
                  url                   
----------------------------------------
 alvin-and-the-chipmunks-chipwrecked
 alvin-and-the-chipmunks-the-road-chip
 alvin-and-the-chipmunks
 alvin-and-the-chipmunks-the-squeakquel
(4 rows)

test=> ALTER TABLE movies2 ADD rank float4;
ALTER TABLE
test=> UPDATE movies2 SET rank=ts_rank(lexemesTitle,plainto_tsquery((SELECT Title FROM movies2 WHERE url='alvin-and-the-chipmunks-chipwrecked')));
UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnTitleField AS SELECT url, rank FROM movies2 WHERE rank >-1 ORDER BY rank DESC LIMIT 50;
ERROR:  relation "recommendationsbasedontitlefield" already exists
test=> CREATE TABLE recommendationsBasedOnTitleField1 AS SELECT url, rank FROM movies2 WHERE rank >-1 ORDER BY rank DESC LIMIT 50;
SELECT 50
test=> \COPY (SELECT * FROM recommendationsBasedOnTitleField1) to '/home/pi/RSL/top50recommendationsTitle.csv' WITH csv;
COPY 50
