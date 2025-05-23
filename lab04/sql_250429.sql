use classicmodels;

-- 문제 1.
-- 일별 매출액 조회
-- 테이블 orders, ordersdetails
select A.orderDate
, B.quantityordered * B.priceEach
from orders A
left join orderdetails B
on A.orderNumber = B.orderNumber
;
-- 최종적으로 하고자 하는 것
-- 최종목표 : 국가별 매출 순위, DENSE_RANK()
-- JOIN 개념, windows 함수, 인라인 뷰 서브쿼리
-- countr, sales, rnk
-- USA             1
-- Spain           2
-- 1. customer과 orders 테이블을 연결
select *
from customers c
left join orders o on c.customerNumber = o.customerNumber
;
-- 2. 국가별 매출 집계
-- country 별로 매출액 revenue 게산
select 
	c.country
    , sum(od.quantityordered * od.priceEach) as revenue
from customers c
left join orders o on c.customerNumber = o.customerNumber
left join orderdetails od on o.orderNumber = od.orderNumber
group by c.country
;
-- 3. 국가별 매출 순위 계산 후 상위 5개국 필터링
select *
from (
	select 
		c.country
		, sum(od.quantityordered * od.priceEach) as revenue
		, dense_rank() over (order by sum(od.quantityordered * od.priceEach)desc) as rnk
	from customers c
	left join orders o on c.customerNumber = o.customerNumber
	left join orderdetails od on o.orderNumber = od.orderNumber
	group by c.country
) A
where rnk <=5
;

-- 비슷한 개념
-- 미국이 가장 많이 팔리고 있는 것 확인
-- 차량 모델 관련된 DB
-- 미국에서 가장 많이 팔리는 차량 모델 5개 구하기
-- 차량모델, revenue, rnk
select 
    p.productName
    , sum(od.quantityordered * od.priceEach) as revenue
    , dense_rank() over (order by sum(od.quantityordered * od.priceEach)desc) as rnk
from products p
left join orderdetails od on p.productCode = od.productCode
left join orders o on od.orderNumber = o.orderNumber
left join customers c on o.customerNumber = c.customerNumber
where c.country = 'USA'
group by 1
order by rnk limit 5;

-- 윈도우(Window) 함수
CREATE TABLE sales(
    sales_employee VARCHAR(50) NOT NULL,
    fiscal_year INT NOT NULL,
    sale DECIMAL(14,2) NOT NULL,
    PRIMARY KEY(sales_employee,fiscal_year)
);

INSERT INTO sales(sales_employee,fiscal_year,sale)
VALUES('Bob',2016,100),
      ('Bob',2017,150),
      ('Bob',2018,200),
      ('Alice',2016,150),
      ('Alice',2017,100),
      ('Alice',2018,200),
       ('John',2016,200),
      ('John',2017,150),
      ('John',2018,250);

SELECT * FROM sales;

-- LAG() 함수 기본 : 이전 행의 값 가져오기
-- LAG() 함수를 활용한 매출 증가율 계산
-- 각 직원별로 전년 대비 매출 증가율 계산
-- Alic 2017 100.00 150.00
select
	sales_employee
    , fiscal_year
    , sale
    , LAG(sale) over(partition by sales_employee
				order by fiscal_year) as prev_year_sale
	, round((sale - LAG(sale) over(partition by sales_employee
				order by fiscal_year)) / LAG(sale) over(partition by sales_employee
                order by fiscal_year) * 100, 1) as growth_pct
from sales
order by 1, 2
;

-- 질문 : 증감률 (X)
-- 1년전, 2년전 매출과 비교하세요
-- sale, prev_year_sale, two_yeara_ago_sale, 2년전 매출과 비교
select sales_employee,
    lag(sale,1,0) over(partition by sales_employee
                        order by fiscal_year) as one_year_result,
    lag(sale,2,0) over(partition by sales_employee
                        order by fiscal_year) as two_year_result
from sales
order by 1,2;

-- 문제 1.
-- 1. 각 주문의 현재 주문금액과 이전 주문금액의 차이를 계산하시오. 
-- 1. 각 주문의 현재 주문금액과 이전 주문금액의 차이를 계산
-- 1) orders와 orderdetails 테이블을 조인하여 주문별 총액을 계산하는 서브쿼리 작성
-- 2) LAG 함수를 사용하여 이전 주문 금액을 가져옴 (orderDate 기준)
-- 3) 현재 주문금액 - 이전 주문금액으로 차이 계산
SELECT 
    orderNumber,
    orderDate,
    totalAmount,
    LAG(totalAmount) OVER (ORDER BY orderDate) as prev_amount,
    totalAmount - LAG(totalAmount) OVER (ORDER BY orderDate) as amount_difference
FROM (
    SELECT 
        o.orderNumber,
        o.orderDate,
        SUM(quantityOrdered * priceEach) as totalAmount
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY o.orderNumber, o.orderDate
) A
ORDER BY orderDate;

-- 문제 2.
-- 2. 각 고객별로 주문금액과 직전 주문금액을 비교하여 증감률을 계산하시오
-- 2. 각 고객별 주문금액과 직전 주문금액의 증감률 계산
-- 1) orders, orderdetails 테이블 조인하여 고객별, 주문일자별 총 주문금액 계산 (서브쿼리)
-- 2) LAG 함수로 각 고객별 이전 주문금액 가져오기 (PARTITION BY customerNumber)
-- 3) (현재주문금액 - 이전주문금액) / 이전주문금액 * 100 으로 증감률 계산
-- 4) ROUND 함수로 소수점 2자리까지 표시
SELECT 
    customerNumber,
    orderDate,
    orderAmount,
    LAG(orderAmount) OVER (PARTITION BY customerNumber ORDER BY orderDate) as prev_amount,
    ROUND(((orderAmount - LAG(orderAmount) OVER (PARTITION BY customerNumber ORDER BY orderDate)) / 
    LAG(orderAmount) OVER (PARTITION BY customerNumber ORDER BY orderDate) * 100), 2) as growth_rate
FROM (
    SELECT 
        o.customerNumber,
        o.orderDate,
        SUM(quantityOrdered * priceEach) as orderAmount
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY o.customerNumber, o.orderDate
) A
ORDER BY customerNumber, orderDate;

-- 문제 3.
-- 3. 각 제품라인별로 3개월 이동평균 매출액을 계산하시오
-- 3. 각 제품라인별 3개월 이동평균 매출액 계산
-- 1) products, orderdetails, orders 테이블 조인하여 제품라인별, 월별 매출액 계산 (서브쿼리)
-- 2) DATE_FORMAT 함수로 orderDate를 월 단위로 그룹화
-- 3) AVG 함수와 OVER절을 사용하여 3개월 이동평균 계산
--    - PARTITION BY로 제품라인별 그룹화
--    - ROWS BETWEEN 2 PRECEDING AND CURRENT ROW로 현재행 포함 이전 2개 행까지의 평균 계산
-- 4) ROUND 함수로 소수점 2자리까지 표시
SELECT 
    productLine,
    orderDate,
    monthly_sales,
    ROUND(AVG(monthly_sales) OVER (
        PARTITION BY productLine 
        ORDER BY orderDate 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) as moving_average_3months
FROM (
    SELECT 
        p.productLine,
        DATE_FORMAT(o.orderDate, '%Y-%m-01') as orderDate,
        SUM(od.quantityOrdered * od.priceEach) as monthly_sales
    FROM products p
    JOIN orderdetails od ON p.productCode = od.productCode
    JOIN orders o ON od.orderNumber = o.orderNumber
    GROUP BY p.productLine, DATE_FORMAT(o.orderDate, '%Y-%m-01')
) A
ORDER BY productLine, orderDate;

-- 연습 미리 해보기 -- 누적 합계
SELECT 
    o.orderNumber,
    o.orderDate,
    SUM(od.quantityOrdered * od.priceEach) as orderValue,
    SUM(SUM(od.quantityOrdered * od.priceEach)) OVER (
        ORDER BY o.orderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as running_total
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY o.orderNumber, o.orderDate
ORDER BY o.orderDate
LIMIT 10;
