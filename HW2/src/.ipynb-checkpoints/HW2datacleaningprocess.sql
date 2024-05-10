-- SQLite
SELECT age, sex, painloc, painexer, relrest, pncaden, cp, trestbps, htn, chol, smoke, cigs, years, fbs, dm, famhist, restecg, ekgmo, `ekgday(day`, ekgyr, dig, prop, nitr, pro, diuretic, proto, thaldur, thaltime, met, thalach, thalrest, tpeakbps, tpeakbpd, dummy, trestbpd, exang, xhypo, oldpeak, slope, rldv5, rldv5e, ca, restckm, exerckm, restef, restwm, exeref, exerwm, thal, thalsev, thalpul, earlobe, cmo, cday, cyr, target
FROM original_heart_disease;

CREATE TABLE cut_heart_disease (
    age INTEGER,
    sex INTEGER,
    painloc INTEGER,
    painexer INTEGER,
    cp INTEGER,
    trestbps INTEGER,
    smoke INTEGER,
    fbs INTEGER,
    prop INTEGER,
    nitr INTEGER,
    pro INTEGER,
    diuretic INTEGER,
    thaldur INTEGER,
    thalach INTEGER,
    exang INTEGER,
    oldpeak REAL,
    slope INTEGER,
    target INTEGER  
);

INSERT INTO cut_heart_disease (age, sex, painloc, painexer, cp, trestbps, smoke, fbs, prop, nitr, pro, diuretic, thaldur, thalach, exang, oldpeak, slope, target)
SELECT age, sex, painloc, painexer, cp, trestbps, smoke, fbs, prop, nitr, pro, diuretic, thaldur, thalach, exang, oldpeak, slope, target
FROM original_heart_disease;


DROP TABLE original_heart_disease

UPDATE cut_heart_disease SET trestbps = 100 WHERE trestbps < 100;

UPDATE cut_heart_disease
SET trestbps = (
    SELECT AVG(trestbps)
    FROM (
      SELECT trestbps
      FROM cut_heart_disease
      WHERE trestbps IS NOT NULL
      ORDER BY trestbps
      LIMIT 2 - (SELECT COUNT(*) FROM cut_heart_disease WHERE trestbps IS NOT NULL) % 2
      OFFSET (SELECT (COUNT(*) - 1) / 2 FROM cut_heart_disease WHERE trestbps IS NOT NULL)
    )
)
WHERE trestbps IS NULL;


UPDATE cut_heart_disease SET oldpeak = 0 WHERE oldpeak < 0;
UPDATE cut_heart_disease SET oldpeak = 4 WHERE oldpeak > 4;

DELETE FROM cut_heart_disease
WHERE age NOT LIKE '%[^0-9]%' AND (age < 0 OR age > 100) AND age IS NULL;

-- Update 'thaldur' with the mean of non-NULL values
UPDATE cut_heart_disease
SET thaldur = (SELECT AVG(thaldur) FROM cut_heart_disease WHERE thaldur IS NOT NULL)
WHERE thaldur IS NULL;

-- Update 'thalach' with the integer mean of non-NULL values
UPDATE cut_heart_disease 
SET thalach = CAST((SELECT AVG(thalach) FROM cut_heart_disease WHERE thalach IS NOT NULL) AS INTEGER)
WHERE thalach IS NULL;

UPDATE cut_heart_disease
SET thaldur = ROUND(thaldur, 1);

UPDATE cut_heart_disease
SET fbs = (
    SELECT AVG(fbs) FROM (
      SELECT fbs FROM cut_heart_disease
      WHERE fbs IS NOT NULL AND fbs <= 1
      ORDER BY fbs
      LIMIT 2 - (SELECT COUNT(*) FROM cut_heart_disease WHERE fbs IS NOT NULL AND fbs <= 1) % 2
      OFFSET (SELECT (COUNT(*) - 1) / 2 FROM cut_heart_disease WHERE fbs IS NOT NULL AND fbs <= 1)
    )
)
WHERE fbs IS NULL OR fbs > 1;

UPDATE cut_heart_disease
SET prop = (
    SELECT AVG(prop) FROM (
      SELECT prop FROM cut_heart_disease
      WHERE prop IS NOT NULL AND prop <= 1
      ORDER BY prop
      LIMIT 2 - (SELECT COUNT(*) FROM cut_heart_disease WHERE prop IS NOT NULL AND prop <= 1) % 2
      OFFSET (SELECT (COUNT(*) - 1) / 2 FROM cut_heart_disease WHERE prop IS NOT NULL AND prop <= 1)
    )
)
WHERE prop IS NULL OR prop > 1;

UPDATE cut_heart_disease
SET nitr = (
    SELECT AVG(nitr) FROM (
      SELECT nitr FROM cut_heart_disease
      WHERE nitr IS NOT NULL AND nitr <= 1
      ORDER BY nitr
      LIMIT 2 - (SELECT COUNT(*) FROM cut_heart_disease WHERE nitr IS NOT NULL AND nitr <= 1) % 2
      OFFSET (SELECT (COUNT(*) - 1) / 2 FROM cut_heart_disease WHERE nitr IS NOT NULL AND nitr <= 1)
    )
)
WHERE nitr IS NULL OR nitr > 1;


UPDATE cut_heart_disease
SET pro = (
    SELECT AVG(pro) FROM (
      SELECT pro FROM cut_heart_disease
      WHERE pro IS NOT NULL AND pro <= 1
      ORDER BY pro
      LIMIT 2 - (SELECT COUNT(*) FROM cut_heart_disease WHERE pro IS NOT NULL AND pro <= 1) % 2
      OFFSET (SELECT (COUNT(*) - 1) / 2 FROM cut_heart_disease WHERE pro IS NOT NULL AND pro <= 1)
    )
)
WHERE pro IS NULL OR pro > 1;

UPDATE cut_heart_disease
SET diuretic = (
    SELECT AVG(diuretic) FROM (
      SELECT diuretic FROM cut_heart_disease
      WHERE diuretic IS NOT NULL AND diuretic <= 1
      ORDER BY diuretic
      LIMIT 2 - (SELECT COUNT(*) FROM cut_heart_disease WHERE diuretic IS NOT NULL AND diuretic <= 1) % 2
      OFFSET (SELECT (COUNT(*) - 1) / 2 FROM cut_heart_disease WHERE diuretic IS NOT NULL AND diuretic <= 1)
    )
)
WHERE diuretic IS NULL OR diuretic > 1;

UPDATE cut_heart_disease
SET oldpeak = (
    SELECT AVG(oldpeak)
    FROM (
      SELECT oldpeak
      FROM cut_heart_disease
      WHERE oldpeak IS NOT NULL
      ORDER BY oldpeak
      LIMIT 2 - (SELECT COUNT(*) FROM cut_heart_disease WHERE oldpeak IS NOT NULL) % 2
      OFFSET (SELECT (COUNT(*) - 1) / 2 FROM cut_heart_disease WHERE oldpeak IS NOT NULL)
    )
)
WHERE oldpeak IS NULL;

-- Replace NULLs in 'exang' with the median value
UPDATE cut_heart_disease
SET exang = (
    SELECT exang
    FROM (
        SELECT exang
        FROM cut_heart_disease
        WHERE exang IS NOT NULL
        ORDER BY exang
        LIMIT 1
        OFFSET (SELECT (COUNT(*) - 1) / 2 FROM cut_heart_disease WHERE exang IS NOT NULL)
    )
)
WHERE exang IS NULL;

-- Replace NULLs in 'slope' with the median value
UPDATE cut_heart_disease
SET slope = (
    SELECT slope
    FROM (
        SELECT slope
        FROM cut_heart_disease
        WHERE slope IS NOT NULL
        ORDER BY slope
        LIMIT 1
        OFFSET (SELECT (COUNT(*) - 1) / 2 FROM cut_heart_disease WHERE slope IS NOT NULL)
    )
)
WHERE slope IS NULL;

DELETE FROM cut_heart_disease
WHERE age IS NULL OR sex IS NULL;

-- Update 'painloc' with the median of non-NULL values
UPDATE cut_heart_disease
SET painloc = (
    SELECT CASE WHEN SUM(painloc) >= COUNT(painloc) / 2 THEN 1 ELSE 0 END
    FROM cut_heart_disease
    WHERE painloc IS NOT NULL
)
WHERE painloc IS NULL;

-- Update 'painexer' with the median of non-NULL values
UPDATE cut_heart_disease
SET painexer = (
    SELECT CASE WHEN SUM(painexer) >= COUNT(painexer) / 2 THEN 1 ELSE 0 END
    FROM cut_heart_disease
    WHERE painexer IS NOT NULL
)
WHERE painexer IS NULL;

-- Fixing the smoke column 
--URL #1
ALTER TABLE cut_heart_disease
ADD COLUMN smoke_age INTEGER;


CREATE TABLE smoke_age_data (
    age_start INTEGER,
    age_end INTEGER,
    year_2022_percent NUMERIC
);

INSERT INTO smoke_age_data (age_start, age_end, year_2022_percent)
VALUES
(0, 17, 1.6),
(18, 24, 7.3),
(25, 34, 10.9),
(35, 44, 10.9),
(45, 54, 13.8),
(55, 64, 14.9),
(65, 74, 8.7),
(75, 100, 2.9);


UPDATE cut_heart_disease
SET smoke_age = (
    SELECT year_2022_percent
    FROM smoke_age_data
    WHERE cut_heart_disease.age BETWEEN smoke_age_data.age_start AND smoke_age_data.age_end
)
WHERE smoke IS NULL;

UPDATE cut_heart_disease
SET smoke_age = CASE
    WHEN random() % 100 < smoke_age THEN 1  -- Directly use the percentage as it is
    ELSE 0
END
WHERE smoke IS NULL;

--URL #2
ALTER TABLE cut_heart_disease
ADD COLUMN smoke_age_sex INTEGER;

CREATE TABLE smoke_age_sex_data (
    agestart INTEGER,
    ageend INTEGER,
    agerate NUMERIC,
    male_rate NUMERIC,
    female_rate NUMERIC
);

-- Inserting the smoking rates for each age range
INSERT INTO smoke_age_sex_data (agestart, ageend, agerate, male_rate, female_rate) VALUES
(18, 24, 5.3, 13.1, 10.1),   -- Rates for ages 18-24
(25, 44, 12.6, 13.1, 10.1),  -- Rates for ages 25-44
(45, 64, 14.9, 13.1, 10.1),  -- Rates for ages 45-64
(65, 100, 8.3, 13.1, 10.1);  -- Rates for ages 65+


UPDATE cut_heart_disease
SET smoke_age_sex = CASE
    WHEN sex = 0 AND smoke IS NULL THEN
        (SELECT agerate
         FROM smoke_age_sex_data
         WHERE age BETWEEN agestart AND ageend)
    WHEN sex = 1 AND smoke IS NULL THEN
        (SELECT agerate * (male_rate / female_rate)
         FROM smoke_age_sex_data
         WHERE age BETWEEN agestart AND ageend)
END
WHERE smoke IS NULL;

UPDATE cut_heart_disease
SET smoke_age_sex = CASE
    WHEN random() % 100 < smoke_age_sex THEN 1  -- Directly use the percentage as it is
    ELSE 0
END
WHERE smoke IS NULL;

UPDATE cut_heart_disease
SET smoke = CASE
    -- If smoke_age and smoke_age_sex are equal, use either (since they are equal)
    WHEN smoke IS NULL AND smoke_age = smoke_age_sex THEN smoke_age

    -- For male patients, if smoke is NULL and smoke_age is not equal to smoke_age_sex
    WHEN smoke IS NULL AND sex = 1 THEN smoke_age_sex

    -- For female patients, if smoke is NULL and smoke_age is not equal to smoke_age_sex
    WHEN smoke IS NULL AND sex = 0 THEN smoke_age

    -- If none of the above conditions are met, do not change the value
    ELSE smoke
END
WHERE smoke IS NULL;  -- Only attempt to update rows where smoke is NULL

ALTER TABLE cut_heart_disease DROP COLUMN smoke_age;
ALTER TABLE cut_heart_disease DROP COLUMN smoke_age_sex;
