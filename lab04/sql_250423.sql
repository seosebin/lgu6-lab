-- 교재
-- WHERE 절
-- 조건과 일치하는 데이터 조회 (필터링)
-- pandas, iloc, loc 비교연산자 등 같이 상기
-- 94p
use lily_book;

-- 문법에 주의. "" 큰 따옴표 안됨. '' 작은 따옴표만 가능
select * from dbo.customer where customer_id = 'c002';

-- where절 안에서 비교연산자를 통해서 필터링
-- <>, != : 좌우식이 서로 같지 않음
select * from sales;

-- sales_amount의 값이 양수인것만 조회
select * from sales where sales_amount > 0;

-- 숫자를 입력할 때 근사하게 입력해보자
select * from sales where sales_amount = 41000;

-- 데이터가 아예 없을 때도 NULL 형태로 출력
-- 조회를 할 때, 정확하게 입력하지 않아도 NULL 형태로 출력

select * from dbo.customer where customer_id = 'z002';

-- p100, BETWEEN 연산자, 자주 쓰임
-- 30000과 40000 사이의 조건을 만족하는 행 출력
select * from sales where sales_amount between 30000 and 40000;

select * from customer where customer_id between 'c001' and 'c003';

-- between을 사용할 때 한글로도 조회할 수도 있음
select * from customer where last_name between '가' and '아';

-- IN 연산자, 매우매우매우 자주 사용됨
-- OR 연산자 반복해서 쓰기 싫어서 In 사용함
select * from sales where product_name in ('신발', '책');
-- OR 연산자로 풀어서 사용할 경우
SELECT * FROM sales WHERE product_name = '신발' OR product_name = '책';

-- 103p
-- Like 연산자
use BikeStores;
-- lastname이 letter z로 시작하는 모든 행을 필터링
select * from sales.customers where last_name like 'z%';

select * from sales.customers where last_name like '%z';

select * from sales.customers where last_name like '%z%';

-- IS NULL 연산자 (중요함)
-- 데이터가 NULL 값인 행만 필터링
-- 정상적으로 조회
select * from sales.customers where phone IS NULL;

-- 조회 안됨
select * from sales.customers where phone = NULL;
select * from sales.customers where phone = 'NULL';

-- p109
-- AND 연산자 / OR 연산자
CREATE TABLE distribution_center
(
  center_no                VARCHAR(5),
  status                VARCHAR(10),
  permission_date        DATE,
  facility_equipment    VARCHAR(50),
  address                VARCHAR(100)
)

INSERT INTO distribution_center VALUES('1','영업중','2022-07-04','화물자동차','경기도 이천시 마장면 덕평로 123')
INSERT INTO distribution_center VALUES('2','영업중','2021-06-10','지게차,화물자동차','경기도 용인시 기흥구 언동로 987-2')
INSERT INTO distribution_center VALUES('3','영업중','2022-05-26','항온항습기,지게차','서울시 중구 통일로 555')
INSERT INTO distribution_center VALUES('4','영업종료','2022-07-07',NULL,'경기도 여주시 대신면 대신로 6-1')
INSERT INTO distribution_center VALUES('5','영업종료','2021-02-02',NULL,'경기도 용인시 수지구 손곡로 29')

select * from distribution_center;

-- AND 연산자
select * from distribution_center
where permission_date > '2022-05-01' and permission_date < '2022-07-31' and status = '영업중';

-- p113
-- OR 연산자
-- LIKE 연산자와 같이 응용한 쿼리
-- 연산자 우선순위 : () > AND > OR
select * from distribution_center
where address like '경기도 용인시%' or address like '서울시%';

-- 부정연산자
-- IN, NOT IN 같이 공부
-- IS NULL , IS NOT NULL 같이 공부
select * from distribution_center where center_no in (1, 2);
select * from distribution_center where center_no not in (1, 2);

DROP TABLE sales

CREATE TABLE sales
(
  날짜        VARCHAR(10),
  제품명    VARCHAR(10),
  수량        INT,
  금액        INT
)

INSERT INTO sales VALUES('01월01일','마우스',1,1000)
INSERT INTO sales VALUES('01월01일','마우스',2,2000)
INSERT INTO sales VALUES('01월01일','키보드',1,10000)
INSERT INTO sales VALUES('03월01일','키보드',1,10000)

select * from sales;

-- 127p
-- 일별로 판매된 수량과 금액
select sum(수량) as 수량 from sales;

-- 문법 주의
select 날짜, sum(수량) as 수량 from sales group by 날짜;

select 제품명, sum(수량) as 수량 from sales group by 제품명;

select 날짜, 제품명, sum(수량) as 수량 from sales group by 날짜, 제품명;

-- 131p (매우 중요)
-- 수행한 코드, 이미 중복값이 존재한 상태
-- 월별 총 매출액
select month(order_date), sum(매출액)
from 테이블
group by month(order_date);
