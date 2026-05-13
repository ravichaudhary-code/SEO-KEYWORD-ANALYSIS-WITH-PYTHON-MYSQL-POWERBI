CREATE DATABASE seo_project;
USE seo_project;

CREATE TABLE main_table (
    Title TEXT,
    Keyword TEXT,
    Keyword_ID INT,
    Position INT,
    Previous_position INT
);

CREATE TABLE lookup_keyword (
    Keyword_ID INT PRIMARY KEY,
    Group_Name VARCHAR(100)
);

CREATE TABLE lookup_search (
    Keyword_ID INT,
    Search_Volume FLOAT,
    PRIMARY KEY (Keyword_ID)
);

CREATE TABLE lookup_traffic (
    Keyword_ID INT,
    Traffic FLOAT,
    Traffic_Percentage FLOAT,
    PRIMARY KEY (Keyword_ID)
);

CREATE TABLE lookup_metrics (
    Keyword_ID INT,
    CPC FLOAT,
    Keyword_Difficulty FLOAT,
    Competition FLOAT,
    PRIMARY KEY (Keyword_ID)
);

ALTER TABLE main_table
ADD CONSTRAINT fk_keyword
FOREIGN KEY (Keyword_ID)
REFERENCES lookup_keyword(Keyword_ID);

ALTER TABLE main_table
ADD CONSTRAINT fk_search
FOREIGN KEY (Keyword_ID)
REFERENCES lookup_search(Keyword_ID);

ALTER TABLE main_table
ADD CONSTRAINT fk_traffic
FOREIGN KEY (Keyword_ID)
REFERENCES lookup_traffic(Keyword_ID);

ALTER TABLE main_table
ADD CONSTRAINT fk_metrics
FOREIGN KEY (Keyword_ID)
REFERENCES lookup_metrics(Keyword_ID);

SELECT * FROM main_table LIMIT 10;

SELECT * FROM lookup_keyword;

SELECT COUNT(*) FROM main_table;

SELECT COUNT(DISTINCT Keyword_ID) FROM main_table;

-- Group-wise keyword count
SELECT l.Group_Name, COUNT(*) AS total_keywords
FROM main_table m
JOIN lookup_keyword l
ON m.Keyword_ID = l.Keyword_ID
GROUP BY l.Group_Name
ORDER BY total_keywords DESC;

-- Avg Search Volume by Category
SELECT l.Group_Name, AVG(s.Search_Volume) AS avg_search
FROM main_table m
JOIN lookup_search s ON m.Keyword_ID = s.Keyword_ID
JOIN lookup_keyword l ON m.Keyword_ID = l.Keyword_ID
GROUP BY l.Group_Name
ORDER BY avg_search DESC;

-- Top performing keywords (Traffic)
SELECT m.Keyword, t.Traffic
FROM main_table m
JOIN lookup_traffic t ON m.Keyword_ID = t.Keyword_ID
ORDER BY t.Traffic DESC
LIMIT 10;

-- High CPC Keywords
SELECT l.Group_Name, AVG(mt.CPC) AS avg_cpc
FROM main_table m
JOIN lookup_metrics mt ON m.Keyword_ID = mt.Keyword_ID
JOIN lookup_keyword l ON m.Keyword_ID = l.Keyword_ID
GROUP BY l.Group_Name
ORDER BY avg_cpc DESC;

-- Position Improvement Check
SELECT Keyword,
       Position,
       Previous_position,
       (Previous_position - Position) AS Improvement
FROM main_table
ORDER BY Improvement DESC
LIMIT 10;





