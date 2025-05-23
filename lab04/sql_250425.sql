-- Chapter 9장 
-- 실습 데이터 소개 
USE lily_book_test;

-- 테이블 확인 
SELECT * FROM sales;
SELECT * FROM customer;

-- 테이블 기본 정보 확인하는 명령어
exec sp_help 'sales'; 

/***********************************************************
■ 매출 트렌드 (p.203)
invoiceNo : 주문건수(거래고유번호)
StockCode : 상품고유번호
Description : 상품명
Quantity : 거래수량
InvoiceDate : 거래일시
UnitPrice : 상품단가
CustomerID : 구매자 고유 번호
Country : 구매국가
************************************************************/

-- 기간별 매출 현황
-- 출력 컬럼 : invoicedate, 매출액, 주문수량, 주문건수, 주문고객수
-- 활용 함수 : SUM(), COUNT()
select CONVERT(date, invoicedate) as invoicedate
	, sum(unitprice*quantity)as 매출액
	, sum(quantity) as 주문수량
	, count (distinct invoiceno) as 주문건수
	, count (distinct customerid) as 주문고객수
from sales group by convert(date, invoicedate)
order by invoicedate;

-- 국가별 매출 현황
-- 출력 컬럼 : country, 매출액, 주문수량, 주문건수, 주문고객수
-- 활용 함수 : SUM(), COUNT()
select country as 국가
	, sum(unitprice*quantity) as 매출액
	, sum(quantity) as 주문수량
	, count (distinct invoiceno) as 주문건수
	, count (distinct customerid) as 주문고객수
from sales group by country;


-- 국가별 x 제품별 매출 현황 
-- 출력 컬럼 : country, stockcode, 매출액, 주문수량, 주문건수, 주문고객수
-- 활용 함수 : SUM(), COUNT()
select country as 국가
	, stockcode as 제품
	, round(sum(unitprice*abs(quantity)),2 ) as 매출액
	, sum(quantity) as 주문수량
	, count (distinct invoiceno) as 주문건수
	, count (distinct customerid) as 주문고객수
from sales group by country, stockcode;


-- 특정 제품 매출 현황
-- 출력 컬럼 : 매출액, 주문수량, 주문건수, 주문고객수
-- 활용 함수 : SUM(), COUNT()
-- 코드명 : 21615
select round(sum(unitprice*abs(quantity)),2 ) as 매출액
	, sum(quantity) as 주문수량
	, count(distinct invoiceno) as 주문고객수
from sales where stockcode = '21615';

-- 특정 제품의 기간별 매출 현황 
-- 출력 컬럼 : invoicedate, 매출액, 주문수량, 주문건수, 주문고객수
-- 활용 함수 : SUM(), COUNT()
-- 코드명 : 21615, 21731
select CONVERT(date, invoicedate) as invoicedate
	, round(sum(unitprice*quantity), 2)as 매출액
	, sum(quantity) as 주문수량
	, count (distinct invoiceno) as 주문건수
	, count (distinct customerid) as 주문고객수
from sales 
where stockcode in ('21615', '21731')
group by CONVERT(date, invoicedate)


/***********************************************************
■ 이벤트 효과 분석 (p.213)
************************************************************/

-- 이벤트 효과 분석 (시기에 대한 비교)
-- 2011년 9/10 ~ 2011년 9/25까지 약 15일동안 진행한 이벤트의 매출 확인 
-- 출력 컬럼 : 기간 구분, 매출액, 주문수량, 주문건수, 주문고객수 
-- 활용 함수 : CASE WHEN, SUM(), COUNT()
-- 기간 구분 컬럼의 범주 구분 : 이벤트 기간, 이벤트 비교기간(전월동기간)
SELECT 
    CASE 
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-09-10' AND '2011-09-25' THEN '이벤트 기간'
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-08-10' AND '2011-08-25' THEN '비교기간'
        ELSE '기타'
    END AS 기간구분
	, SUM(unitprice*quantity) AS 매출액
	, sum(quantity) as 주문수량
	, count (distinct invoiceno) as 주문건수
	, count (distinct customerid) as 주문고객수
FROM sales
where invoicedate BETWEEN '2011-09-10' AND '2011-09-25'
	or invoicedate BETWEEN '2011-08-10' AND '2011-08-25'
GROUP BY CASE 
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-09-10' AND '2011-09-25' THEN '이벤트 기간'
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-08-10' AND '2011-08-25' THEN '비교기간'
        ELSE '기타'
    END
;


-- 이벤트 효과 분석 (시기에 대한 비교)
-- 2011년 9/10 ~ 2011년 9/25까지 특정 제품에 실시한 이벤트에 대해 매출 확인
-- 출력 컬럼 : 기간 구분, 매출액, 주문수량, 주문건수, 주문고객수 
-- 활용 함수 : CASE WHEN, SUM(), COUNT()
-- 기간 구분 컬럼의 범주 구분 : 이벤트 기간, 이벤트 비교기간(전월동기간)
-- 제품군 : 17012A, 17012C, 17084N
SELECT 
    CASE 
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-09-10' AND '2011-09-25' THEN '이벤트 기간'
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-08-10' AND '2011-08-25' THEN '비교기간'
        ELSE '기타'
    END AS 기간구분
	, SUM(unitprice*quantity) AS 매출액
	, sum(quantity) as 주문수량
	, count (distinct invoiceno) as 주문건수
	, count (distinct customerid) as 주문고객수
FROM sales
-- 연산자 우선 순위 () > AND > OR
where (CONVERT(DATE, invoicedate) BETWEEN '2011-09-10' AND '2011-09-25'
	or CONVERT(DATE, invoicedate) BETWEEN '2011-08-10' AND '2011-08-25')
	and stockcode in ('17012A', '17012C', '17084N')
GROUP BY CASE 
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-09-10' AND '2011-09-25' THEN '이벤트 기간'
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-08-10' AND '2011-08-25' THEN '비교기간'
        ELSE '기타'
    END
;


/***********************************************************
■ CRM 고객 타깃 출력 (p.217)
************************************************************/

-- 특정 제품 구매 고객 정보
-- 문제 : 2010.12.1 - 2010.12.10일까지 특정 제품 구매한 고객 정보 출력
-- 출력 컬럼 : 고객 ID, 이름, 성별, 생년월일, 가입 일자, 등급, 가입 채널
-- HINT : 인라인 뷰 서브쿼리, LEFT JOIN 활용
-- 활용함수 : CONCAT()
-- 코드명 : 21730, 21615
-- 특정 제품을 구매한 고객 정보만 출력하고 싶음
select * from sales;

-- 고객 ID : 16565
select * from customer where mem_no = '16565';

-- 조인을 할 때는, 기본키와 외래키가 항상 존재
-- 기준이 되는 테이블의 기본키는 중복값이 무조건 있어야 함
-- sales 데이터의 customerid 중복값을 모두 제거해서 마치 기본키가 존재하는 테이블 형태로 변형
select distinct  customerid from sales
where stockcode in ('21730', '21615')
	and CONVERT(DATE, invoicedate) BETWEEN '2010-12-01' AND '2010-12-18';

-- LEFT 조인으로 풀이
SELECT * 
FROM (
	SELECT DISTINCT customerid
	FROM sales
	WHERE stockcode IN ('21730', '21615')
		AND CONVERT(DATE, invoicedate) BETWEEN '2010-12-01' AND '2010-12-18'
	) s
LEFT 
JOIN (
	SELECT 
		mem_no
		, CONCAT(last_name, first_name) AS customer_name
		, gd
		, birth_dt
		, entr_dt
		, grade 
		, sign_up_ch
	FROM customer	
) c
ON s.customerid = c.mem_no;
 
 -- 서브쿼리로 풀이
SELECT 
    mem_no,
    CONCAT(last_name, first_name) AS customer_name,
    gd,
    birth_dt,
    entr_dt,
    grade,
    sign_up_ch
FROM 
    customer
WHERE 
    mem_no IN (
        SELECT DISTINCT customerid
        FROM sales
        WHERE stockcode IN ('21730', '21615')
          AND CONVERT(DATE, invoicedate) BETWEEN '2010-12-01' AND '2010-12-18'
    );

-- 미구매 고객 정보 확인
-- 문제 : 전체 멤버십 가입 고객 중에서 구매 이력이 없는 고객과 구매 이력이 있는 고객 정보 구분 
-- 출력 컬럼 : non_purchaser, mem_no, last_name, first_name, invoiceno, stockcode, invoicedate, unitprice, customerid
-- HINT : LEFT JOIN
-- 활용함수 : CASE WHEN, IS NULL, 

-- customer left join sales
select 
	count(distinct case when s.customerid is null then c.mem_no end) as non_purchaser
	, count(distinct mem_no) as total_customer
from customer c
left join sales s on c.mem_no = s.customerid


-- 전체 고객수와 미구매 고객수 계산 
-- 출력 컬럼 : non_purchaser, total_customer
-- HINT : LEFT JOIN
-- 활용 함수 : COUNT(), IS NULL


/***********************************************************
■ 고객 상품 구매 패턴 (p.227)
************************************************************/

-- 매출 평균 지표 활용하기 
-- 매출 평균지표 종류 : ATV, AMV, Avg.Frq, Avg.Units
-- 문제 : sales 데이터의 매출 평균지표, ATV, AMV, Avg.Frq, Avg.Units 알고 싶음
-- 출력 컬럼 : 매출액, 주문수량, 주문건수, 주문고객수, ATV, AMV, Avg.Frq, Avg.Units
-- 활용함수 : SUM(), COUNT()
select
	round(sum(unitprice * quantity) / count(distinct invoiceno), 2) as atv -- 주문 건수
	, round(sum(unitprice * quantity) / count(distinct customerid), 2) as amv -- 주문 고객수
	, count(distinct invoiceno) * 1.00 / count(distinct customerid) as AvgFrq
from sales;


-- 문제 : 문제 : 연도 및 월별 매출 평균지표, ATV, AMV, Avg.Frq, Avg.Units 알고 싶음
-- 출력 컬럼 : 연도, 월, 매출액, 주문수량, 주문건수, 주문고객수, ATV, AMV, Avg.Frq, Avg.Units
-- 활용함수 : SUM(), COUNT(), YEAR, MONTH
SELECT 
	YEAR(invoicedate) AS 연도 
	, month(invoicedate) as 월
	, round(sum(unitprice * quantity) / count(distinct invoiceno), 2) as atv -- 주문 건수
FROM sales
group by year(invoicedate), month(invoicedate)
having round(sum(unitprice * quantity) / count(distinct invoiceno), 2) >= 400
order by 1,2
;

/***********************************************************
■ 고객 상품 구매 패턴 (p.230)
************************************************************/

-- 특정 연도 베스트셀링 상품 확인
-- 문제 : 2011년에 가장 많이 판매된 제품 TOP 10의 정보 확인 
-- 출력 컬럼 : stockcode, description, qty
-- 활용함수 : TOP 10, SUM(), YEAR()
/* 일반적인 SQL 구조
select from group by ~~ 연도별로 판매개수 ==> A1
select row_member() from (A1) ==> A2
select ~~ from (A2) where rnk <= 10 */
SELECT TOP 10
	stockcode 
	, CONVERT(VARCHAR(255), description) AS description
	, SUM(quantity) as qty 
FROM sales 
WHERE YEAR(invoicedate) = '2011'
GROUP BY stockcode, CONVERT(VARCHAR(255), description)
ORDER BY qty DESC
;



-- 국가별 베스트셀링 상품 확인
-- 문제 : 국가별로 가장 많이 판매된 제품 순으로 실적을 구하고 싶음
-- 출력 컬럼 : RNK, country, stockcode, description, qty
-- HINT : 인라인 뷰 서브쿼리
-- 활용함수 : ROW_NUMBER() OVER(PARTITION BY...), SUM()
SELECT 
	ROW_NUMBER() OVER(PARTITION BY country ORDER BY qty DESC) as rnk
	, a.*
FROM (
	SELECT 
		country
		, stockcode 
		, CONVERT(VARCHAR(255), description) AS description
		, SUM(quantity) as qty 
	FROM sales 
	WHERE YEAR(invoicedate) = '2011'
	GROUP BY country, stockcode, CONVERT(VARCHAR(255), description)
) a
ORDER BY 2, 1
;

-------------------------- 좋은 문제 --------------------------
-- 20대 여성 고객의 베스트셀링 상품 확인 
-- 문제 : 20대 여성 고객이 가장 많이 구매한 TOP 10의 정보 확인 
-- 출력 컬럼 : RNK, country, stockcode, description, qty
-- HINT : 인라인 뷰 서브쿼리, 인라인 뷰 서브쿼리 작성 시, LEFT JOIN 필요
-- 활용함수 : ROW_NUMBER() OVER(PARTITION BY...), SUM(), YEAR()
SELECT * 
FROM (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY qty DESC) AS rnk
        , stockcode
        , description
        , qty
    FROM (
        SELECT 
            stockcode
            , CONVERT(VARCHAR(255), description) AS description 
            , SUM(quantity) AS qty
        FROM sales s 
        LEFT 
        JOIN customer c 
          ON s.customerid = c.mem_no
        WHERE c.gd = 'F'
            AND 2025-YEAR(c.birth_dt) BETWEEN '20' AND '29'
        GROUP BY stockcode, CONVERT(VARCHAR(255), description) 
    ) a
) aa
WHERE rnk <= 10
;

select 2025-year('1995-04-01');


/***********************************************************
■ 고객 상품 구매 패턴 (p.238)
************************************************************/

-- 특정 제품과 함께 가장 많이 구매한 제품 확인 
-- 문제 : 특정 제품(stockcode='20725')과 함께 가장 많이 구매한 TOP 10의 정보 확인
-- 출력 컬럼 : stockcode, description, qty 
-- HINT : INNER JOIN
-- 활용함수 : SUM()

-- self join
-- 우리가 아는 join의 형태는 두개의 서로 다른 테이블
-- 계층구조 확인하고 싶을 때 주로 사용
-- 직원테이블 (부서장, 사원) 과의 관계를 파악할 때 주로 활용

-- 위 코드에서, 제품명에 LUNCH가 포함된 제품은 제외 
SELECT TOP 10
	s.stockcode
	, CONVERT(VARCHAR(255), s.description)
	, SUM(quantity) as qty 
FROM sales s 
INNER 
JOIN (
	SELECT DISTINCT invoiceno 
	FROM sales 
	WHERE stockcode = '20725'
) i
ON s.invoiceno = i.invoiceno
WHERE s.stockcode <> '20725'
	AND CONVERT(VARCHAR(255), s.description) NOT LIKE '%LUNCH%'
GROUP BY s.stockcode, CONVERT(VARCHAR(255), s.description)
ORDER BY qty DESC 

/***********************************************************
■ 고객 상품 구매 패턴 (p.244)
************************************************************/

-- 재구매 고객의 비율 확인
-- 방법 1 : 고객별로 구매일 수 세는 방법
-- 문제 : 쇼핑몰의 재구매 고객수 확인 
-- 출력 컬럼 : repurchaser_count
-- HINT : 인라인 뷰
-- 활용 함수 : COUNT()
select
	customerid
	, count(distinct invoicedate) as freq
from sales
where customerid <> '' -- 비회원에 해당하는 값은 제외하는 문법
group by customerid
having count(distinct invoicedate) >= 2
;

-- 총 고객수
select count(distinct customerid) as 재구매고객수
	from (
	select
		customerid
		, count(distinct invoicedate) as freq
		from sales
	where customerid <> '' -- 비회원에 해당하는 값은 제외하는 문법
	group by customerid
	having count(distinct invoicedate) >= 2
) a
;


-- 방법 2 : 고객별로 구매한 일수에 순서를 매기는 방법
-- 문제 : 쇼핑몰의 재구매 고객수 확인 
-- 출력 컬럼 : repurchaser_count
-- HINT : 인라인 뷰
-- 활용 함수 : COUNT(), DENSE_RANK() OVER(PARTITION BY...)


-- 리텐션 및 코호트 분석
-- 2010년 구매 이력이 있는 2011년 유지율 확인 
SELECT COUNT(DISTINCT customerid) AS rentention_cnt
FROM sales
WHERE customerid <> ''
	AND customerid IN (
	SELECT DISTINCT customerid FROM sales 
	WHERE customerid <> ''
		AND YEAR(invoicedate) = '2010'
)
	AND YEAR(invoicedate) = '2011'
;


SELECT DISTINCT customerid
FROM sales 
WHERE customerid <> ''
	AND YEAR(invoicedate) = '2010'
;
select 820 * 1.00 / 948 * 1.00;

SELECT 
	customerid 
	, invoicedate 
	, DENSE_RANK() OVER(PARTITION BY customerid ORDER BY invoicedate) AS day_no 
FROM (
	SELECT customerid, invoicedate 
	FROM sales 
	WHERE customerid <> ''
	GROUP BY customerid, invoicedate
) a
;

-- 첫 구매와 재구매 기간의 차이 계산
-- DATEDIFF()

-- 정리
-- 주로 다룬 것 : 분석을 위한 조회
-- 서브 쿼리가 메인, 아직 익숙하지 않음

-- 다음주 수업 내용
-- 서브쿼리, 윈도우 함수
-- 테이블 생성, 입력, 업데이트, 삭제 (CRUD, CREATE, READ, UPDATE, DELETE)
-- ERD의 개념이해
-- 트리거 관련 예제 (streamlit)

