-- 전체 데이터 추출

select *
from meteorite_landings_changed_data

-- 연도별 착륙 횟수

SELECT year, COUNT(*) AS landing_count
FROM meteorite_landings_changed_data
GROUP BY year
ORDER BY landing_count desc;

-- 상위 30개 운석 종류별 빈도수

SELECT recclass, COUNT(*) AS frequency
FROM meteorite_landings_changed_data
GROUP BY recclass
ORDER BY frequency DESC
LIMIT 30;

-- 1950년부터 2013년까지 연도별 운석 착륙 횟수

SELECT year, COUNT(*) AS landing_count
FROM meteorite_landings_changed_data
WHERE year >= 1950 AND year <= 2013
GROUP BY year
ORDER BY year;

-- 운석 종류별 분포

SELECT recclass, COUNT(*) AS count,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM meteorite_landings_changed_data)) AS percentage
FROM meteorite_landings_changed_data
GROUP BY recclass
ORDER BY count DESC;

-- 가장 무게가 많이 나오는 운석 이름

SELECT recclass
FROM meteorite_landings_changed_data
ORDER BY mass DESC
LIMIT 1;

-- 상위 15개 운석 종류별로 질량 비율

SELECT recclass, 
       SUM(mass) AS total_mass_kg,
       (SUM(mass) * 100.0 / (SELECT SUM(mass) FROM meteorite_landings_changed_data)) AS mass_percentage
FROM meteorite_landings_changed_data
GROUP BY recclass
ORDER BY total_mass_kg DESC
LIMIT 15;

-- 상위 20개국/지역의 운석 추락 수

SELECT region, COUNT(*) AS fall_count
FROM meteorite_landings_changed_data
WHERE fall IS NOT NULL
   AND recclass IS NOT NULL
GROUP BY region
ORDER BY fall_count DESC
LIMIT 20;

-- 남극에서 떨어진 상위 10개 운석 종류별 운석 수

SELECT recclass, COUNT(*) AS meteorite_count
FROM meteorite_landings_changed_data
WHERE region = 'Antarctica'
GROUP BY recclass
ORDER BY meteorite_count DESC
LIMIT 10;

-- 남극에서의 연도별 운석 착륙 횟수

SELECT year, COUNT(*) AS landings_count
FROM meteorite_landings_changed_data
WHERE region = 'Antarctica'
GROUP BY year
ORDER BY year;


-- 가장 빈도가 높은 운석 클래스의 국가 및 연도별 발생 횟수

WITH MostCommonClass AS (
    SELECT region, COUNT(*) AS class_count
    FROM meteorite_landings_changed_data
    WHERE fall = 'Fell'
    GROUP BY region
    ORDER BY class_count DESC
    LIMIT 1
)

SELECT m.region AS most_common_class, y.year, COUNT(*) AS yearly_count
FROM meteorite_landings_changed_data m
JOIN (SELECT year FROM meteorite_landings_changed_data GROUP BY year) y
ON m.year = y.year
WHERE m.region = (SELECT region FROM MostCommonClass)
GROUP BY m.region, y.year
ORDER BY y.year;


-- 상위 10개 국가/지역에서 발생한 "Fell" 클래스의 운석 추락 수

SELECT region, COUNT(*) AS fell_count
FROM meteorite_landings_changed_data
WHERE fall = 'Fell'
GROUP BY region
ORDER BY fell_count DESC
LIMIT 10;


-- 남극에 떨어진 'Fell' 클래스 운석 수

SELECT COUNT(*) AS fell_count
FROM meteorite_landings_changed_data
WHERE fall = 'Fell' AND region = 'Antarctica';

-- 남극에 떨어진 'Found' 클래스 운석 수

SELECT COUNT(*) AS fell_count
FROM meteorite_landings_changed_data
WHERE fall = 'Found' AND region = 'Antarctica';

-- 남극에 떨어진 모든 운석 수

SELECT COUNT(*) AS antarctica_count
FROM meteorite_landings_changed_data
WHERE region = 'Antarctica';

-- 낙하 운석(Fell) 대 수거 운석(Found) 비율

WITH TotalCounts AS (
    SELECT
        COUNT(*) AS total_count,
        COUNT(CASE WHEN fall = 'Fell' THEN 1 END) AS fell_count,
        COUNT(CASE WHEN fall = 'Found' THEN 1 END) AS found_count
    FROM meteorite_landings_changed_data
)

SELECT
    fell_count AS Fell_Count,
    found_count AS Found_Count,
    ((fell_count * 100.0) / total_count) AS Fell_Percentage,
    ((found_count * 100.0) / total_count) AS Found_Percentage
FROM TotalCounts;


-- 운석 종류별로 낙하(발견) 수와 평균 질량 찾기

SELECT
    m.recclass,
    COUNT(*) AS meteorite_count,
    AVG(m.mass) AS average_mass
FROM meteorite_landings_changed_data m
GROUP BY m.recclass
ORDER BY meteorite_count DESC;


-- 국가별로 낙하(발견) 수와 평균 질량 찾기

SELECT
    region AS country,
    SUM(CASE WHEN fall = 'Fell' THEN 1 ELSE 0 END) AS fall_count,
    SUM(CASE WHEN fall = 'Found' THEN 1 ELSE 0 END) AS found_count,
    AVG(mass) AS average_mass
FROM meteorite_landings_changed_data
GROUP BY region
ORDER BY country;


