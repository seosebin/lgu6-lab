-- 현재 데이터베이스 확인
SELECT DB_NAME();

-- 데이터베이스 > 테이블(pandas 데이터프레임)
-- 데이터베이스 안에 있는 것
---- 테이블 외에도, view, 프로시저, 트리거, 사용자 정의 함수 등 포함
-- SQL, SQEL : E - English
-- 문법이 영어 문법과 매우 흡사함
-- 표준 SQL, 99% 비슷, 1% 다름 => 데이터타입 할 때 차이가 좀 있음 (DB 종류마다)

-- 데이터 확인
USE lily_book;
SELECT * FROM staff;
SELECT * FROM lily_book.dbo.staff;

USE BikeStores;
SELECT * FROM production.brands;

-- 데이터분석의 모든 것
-- SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY
-- FROM pandas dataframe SELECT column
-- p.42 SELECT 절과 FROM 절
SELECT employee_id, employee_name, birth_date FROM staff;

-- 강사님 추천
SELECT 
	employee_id
	, employee_name
	, birth_date
FROM staff
; -- 해당 쿼리 코드 작성 완료

SELECT * FROM staff; -- 좋은 쿼리 작성 방법은 아님
SELECT employee_id, employee_name, birth_date FROM staff; -- 컬럼 순서 변경 가능

-- 컬럼 별칭
-- 컬럼명 지정할 때는, 영어 약어로 지정 ==> 데이터 정의서 관리
-- ALIAS (AS)
SELECT employee_id, birth_date
FROM staff
;

SELECT employee_id, birth_date AS 생년월일
FROM staff
;

-- DISTINCT 중복값 제거
SELECT * FROM staff;

SELECT DISTINCT gender FROM staff;

SELECT gender FROM staff;

SELECT employee_name, gender, position FROM staff;
SELECT DISTINCT position, employee_name, gender FROM staff;

-- 문자열 함수 : 다른 DBMS와 문법 유사, 블로그에 정리
SELECT * FROM apparel_product_info;

-- LEFT 함수 확인
SELECT product_id, LEFT(product_id, 2) AS 약어
FROM apparel_product_info;

-- SUBSTRING 문자열 중간 N번째 자리부터 N개만 출력
-- SUBSTRING(컬럼명, 숫자(N start), 숫자(N end))
-- 파이썬, 다른 프로그래밍 언어는 인덱스가 0번째부터 시작
-- MS-SQL은 인덱스가 0번째부터 하니깐, ?
-- MS-SQL은 인덱스가 1번째부터 시작함
SELECT product_id, SUBSTRING(product_id, 1, 1) AS 약어
FROM apparel_product_info;

-- CONCAT 문자열과 문자열 이어서 출력
SELECT CONCAT(category1, '>', category2, '=', '옷', price) AS 테스트
FROM apparel_product_info;

-- REPLACE : 문자열에서 특정 문자 변경
-- p58
SELECT product_id, REPLACE(product_id, 'F', 'A')AS 결과
FROM apparel_product_info;

-- ISNULL 중요함
-- WHERE절과 함께 쓰일 때 자주 활용되는 방법
-- 데이터상에 결측치가 존재할 때 꼭, 필요한 함수
SELECT * FROM apparel_product_info;

-- 숫자함수 : ABS, CEILING, FLOOR, ROUND, POWER, SQRT
-- 다른 DBMS, MySQL, Oracle, 
SELECT ROUND(CAST (748.58 AS DECIMAL (6,2)), -3);

-- SIGN
SELECT SIGN(-125), SIGN(0), SIGN(564);

-- CEILING : 특정 숫자를 올림처리
SELECT * FROM sales;
SELECT
	sales_amount_usd
	, CEILING(sales_amount_usd) AS 결과
FROM sales;

-- 날짜함수 : 공식문서 무조건 참조
-- GETDATE : 공식문서 참조
-- DATEADD : 공식문서 참조
-- DATEDIFF : p255 두 날짜 사이의 기간 및 시간 차이 -> 이탈율, 재구매율 구할 때 사용
SELECT
	order_date
	, DATEADD(YEAR, -1, order_date) AS 결과1
	, DATEADD(YEAR, +2, order_date) AS 결과2
	, DATEADD(DAY, +40, order_date) AS 결과3
FROM sales;

-- DATEDIFF (p72)
SELECT
	order_date
	, DATEDIFF(MONTH, order_date, '2025-04-22') 함수적용결과1
	, DATEDIFF(DAY, order_date, '2025-04-22') 함수적용결과2
FROM sales;

SELECT DATEDIFF(DAY, '2002-04-27', '2025-04-22');

-- 순위함수 (p74) (=윈도우 함수) ==> 살짝 난해함
SELECT * FROM student_math_score;
SELECT
	학생
	, 수학점수
	, RANK() OVER(ORDER BY 수학점수 DESC) AS rank등수
	, DENSE_RANK() OVER(ORDER BY 수학점수 DESC) AS dense_rank등수
	, ROW_NUMBER() OVER(ORDER BY 수학점수 DESC) AS row_number등수
FROM student_math_score;

-- PARTITION BY
-- OVER(ORDER BY) : 전체중에서 몇 등
-- OVER(PARTITION BY class ORDER BY) : 반별로 나웠을 때 반에서 몇 등?
SELECT
	학생
	, Class
	, 수학점수
	, DENSE_RANK() OVER(ORDER BY 수학점수 DESC) AS 전교등수
	, DENSE_RANK() OVER(PARTITION BY Class ORDER BY 수학점수 DESC) AS 반등수
FROM student_math_score;

-- CASE문, 조건문 (IF문 대신 사용)
-- SELECT문 작성 시, 조회용
-- PL/SQL 쓸 경우에는, IF문 사용 가능

-- 값이 0보다 작다면 '환불거래', 0보다 크다면 '정상거래'로 분류
SELECT 
	sales_amount
	, CASE WHEN sales_amount < 0 THEN '환불거래'
		   WHEN sales_amount > 0 THEN '정상거래'
	 END AS 적용결과
from sales;