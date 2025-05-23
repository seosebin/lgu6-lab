-- Having 그룹화 계산이 끝난 이후를 기준으로 필터링
-- where 원본 데이터를 기준으로 필터링
select * from sales_ch5
select customer_id, SUM(sales_amount) as 매출 from sales_ch5
-- sales_amount를 대체한 매출로 having절의 변수로 사용할 경우 오류
-- 기존 변수인 sales_amount를 변수로 사용해도 오류
group by customer_id having  SUM(sales_amount)> 20000

-- ORDER BY
select customer_id, SUM(sales_amount) as 매출 from sales_ch5
group by customer_id order by 매출 desc -- desc는 내림차순, 디폴트는 오름차순, asc 오름차순

-- db가 데이터를 처리하는 순서
-- from => where => group by - having => select => order by

-- 161p
-- 제품 정보가 있는 product_info 테이블
-- 제품 카테고리가 있는 catefory_info 테이블
-- 이벤트 제품에 대한 정보 event_info 테이블

-- 서로 다른 테이블 ==> 테이블 조인 (일반적인 방법)
-- 서브쿼리 vs 테이블 조인 (엔지니어, 두개 성능 비교)
-- 실행계획 통해서, 두 쿼리의 성능을 비교할 수 있어야 함(엔지니어 희망자)

select product_id, product_name, category_id, 
	(select category_name from category_info c where c.category_id = p.category_id)
from product_info p; -- 일반적으로 테이블 조인 테이블의 이름을 ALIAS 처리

-- FROM절 서브쿼리
-- data1 = data.가공
-- data2 = data1.가공
-- select from (select from (select from))
-- product_info 테이블, 카테고리별로 제품의 개수가 5개 이상인 카테고리만 출력
select category_id, count(product_id) as count_of_product
from product_info
group by category_id
having count(product_id) >= 5;

-- 위랑 실행 결과 동일함
select * from (select category_id, count(product_id) as count_of_product
from product_info
group by category_id) p where count_of_product >= 5;


-- where절 서브쿼리
-- 서브쿼리 잘하고 싶음 : 분할 후 합치세요
-- product_info T, 가전제품 카테고리만 출력하고싶음
-- 서브쿼리, 메인쿼리 분할해서 처리
-- 서브쿼리 : 가전제품 카테고리만 조회
-- 메인쿼리 : product_info 테이블 조회

select * from product_info;
-- 가전제품 카테고리 id => c01
select category_id from category_info where category_name = '가전제품';

select * from product_info where category_id = (
	select category_id from category_info where category_name = '액세서리');

-- 168p
-- product_info T, event_id 컬럼의 e2에 포함된 제품의 정보만 출력
-- 메인쿼리 : product_info T 제품의 정보 출력
-- 서브쿼리 : event_id 컬럼의 e2에 해당하는 제품
select * from product_info where product_id in ('p003', 'p004', 'p005');

select product_id from event_info where event_id = 'e2';

-- 테이블의 결합
-- LEFT JOIN, RIGHT JOIN, OUTER JOIN (FULL JOIN), INNER JOIN
-- LEFT OUTER JOIN, RIGHT OUTER JOIN
-- 185p
select * from product_info pi 
left join category_info ci on pi.category_id = ci.category_id;

-- UNION 연산자 : 테이블 아래로 붙이기
-- UNION(중복값 제거) vs UNION ALL (중복값 제거 안함)

-- 서브쿼리 추가 질문
use BikeStores;

-- 테이블
select * from sales.orders;

-- 문제 : 2017년에 가장 많은 주문을 처리한 직원이 처리한 모든 주문 조회
-- 1. 모든 주문 정보 표시
-- 2. where 서브쿼리 사용해서 2017년 최다 주문 처리 직원 찾기
-- 3. Top 1과 groupby 사용
-- 4. 활용함수 : year, count(*)

-- 메인쿼리 : 모든 주문 정보 표시
select * from sales.orders where staff_id = 6;

-- 서브쿼리 : 2017년에 가장 많은 주문을 처리한 직원 찾기
-- staff_id 빈번하게 등장한 직원 찾기
select staff_id, count(*) AS 주문건수
from sales.orders
where year(order_date) = 2017
group by staff_id;

-- 
select top 1 staff_id
from sales.orders
where year(order_date) = 2017
group by staff_id
order by count(*) desc;

-- 합치기
-- 2017년에 가장 많은 주문을 처리한 직원이 처리한 모든 주문 조회
select * from sales.orders
where staff_id = (
	select top 1 staff_id
	from sales.orders
	where year(order_date) = 2017
	group by staff_id
	order by count(*) desc
);

-- 테이블 2개
select * from production.products;
select * from sales.order_items;

-- 질문 : 한번도 주문되지 않은 제품들의 정보를 조회
-- 중복을 제거하는 방법 : select distinct

-- 메인쿼리 : products 테이블에 모든 데이터를 조회
select * from production.products;

-- 서브쿼리 : 한번도 주문되지 않은 제품 정보
select * from sales.order_items;

select distinct product_id from sales.order_items;

select * from production.products
where product_id not in (
	select distinct product_id from sales.order_items
);

