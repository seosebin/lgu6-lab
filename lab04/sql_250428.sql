use testdb;
/*-------------------------
---------CH01 기분키---------
-------------------------*/
-- 테이블 생성 코드
create table products(
	id int primary key
    , name varchar(255) not null
);
-- 조회
select * from products;

-- 테이블 삭제
drop table products;

-- 조회 ==> 결과 : None
select * from products;

-- 데이터 추가 : insert Data
insert into products(id, name)
values
	(1, '노트북'),
    (2, '모바일폰')
;

select * from products;

-- AUTO_INCREMENT 옵션 추가
drop table products;
create table products(
	id int auto_increment primary key
    , name varchar(255) not null
);

-- 데이터 입력 방식 문법이 달라짐
insert into products(name)
values
	('노트북'),
    ('모바일폰')
;

select * from products;

-- 두개의 테이블 생성
-- 기본키를 하나만 생성하는 것이 아닌, 다중 필드를 기본키로 설정
-- 시나리오 : 고객 테이블, 제품선호도 테이블
create table customers(
	id int auto_increment primary key
    , name varchar(255) not null
);

-- favor
create table favor(
	customer_id int
    , product_id int
    , favor_at timestamp default current_timestamp
    , primary key(customer_id, product_id)
);

-- 기본키를 추가할 것
-- ALTER 명령어
create table tags(
	id int
    , name varchar(225) not null
);

alter table tags
add primary key(id)
;

desc tags;

-- key 값 제거
alter table tags
drop primary key
;

desc tags;

/*-------------------------
---------CH02 외래키---------
-------------------------*/

-- 관계형 : 부모와 자식간의 관계 설정
-- 부모 테이블 생성: departments
create table departments (
	department_id int auto_increment primary key -- 부서ID, 기본키
    , departments_name varchar(100) not null -- 부서명, 필수 입력
);

-- 자식 테이블 생성 : employees
create table employees (
	employee_id int auto_increment primary key -- 직원ID, 기본키
    , employee_name varchar(255) not null -- 직원명, 필수입력
    , department_id int -- 부서 ID
    
    -- 외래 키 설정
    , foreign key (department_id)
		references departments(department_id)
		on delete set null -- 부서를 삭제 시, 직원의 department_id를 null로 변경
        on update cascade -- 부서ID 변경시, employee 테이블에도 변경 반영
);

INSERT INTO departments (departments_name) VALUES ('HR');
INSERT INTO departments (departments_name) VALUES ('IT');
INSERT INTO departments (departments_name) VALUES ('Sales');

INSERT INTO employees (employee_name, department_id) 
VALUES ('Alice', 1), ('Bob', 2), ('Charlie', 3);

select * from departments;
select * from employees;

-- 부서 삭제 (row)
delete from departments where department_id=2;

-- 직원 테이블에 영향이 가서, employee_id 2의 부서는 null
select * from departments;
select * from employees;

/*-------------------------
--------CH03 제약조건--------
-------------------------*/

-- unique 제약조건
-- 특정 컬럼이 중복되지 않도록 보장하는 제약 조건

-- 테이블 생성 : users
create table users(
	id int auto_increment primary key
    , username varchar(50) not null -- 사용자 이름 필수
    , email varchar(100) unique -- null 값 허용, 중복 금지
);

-- 정상 입력
insert into users (username, email) values('eavn', 'evan@example.com');
insert into users (username, email) values('eva', null);
insert into users (username, email) values('yuna'); -- null 값이라도 표시해라

insert into users (username, email) values('yuna', 'evan@example.com');

-- phone, name 둘 다 같을 때에만 추가 입력 불가
create table users2(
	id int auto_increment primary key
    , username varchar(50) not null -- 사용자 이름 필수
    , email varchar(100) 
    , phone varchar(20)
    , unique(email, phone)
);

insert into users2 (username, email, phone)
values('yuna', 'evan@example.com', '010-0000-1111');

-- 
select * from users2;

/*-------------------------
----------CH04 수정---------
-------------------------*/
-- alter table, 테이블의 구조를 변경
-- update : 테이블 안의 기존 데이터를 수정(update) 할 때 사용하는 명령어
-- 특정 행(row)이나 여러 행을 동시에 변경

-- employees 테이블 예시
-- id, name, salary, department
-- 3개 정도 데이터 추가
drop table employees;
create table employees(
	id smallint
    , name tinytext
    , salary float
    , department char(30)
);

insert into employees (id, name, salary, department)
values(1, 'evan', 1000000.0, 'HR');
insert into employees (id, name, salary, department)
values(2, 'evan2', 2000000.0, 'IT');

select * from employees;

-- update ~ set ~ where
SET SQL_SAFE_UPDATES = 0;

update employees
set salary = 3000
where name = 'evan';

-- 하고자 하는 시나리오
-- 특정 부서의 급여만 인상 (where 필수)

-- where을 안쓰면, 전 직원 급여 인상
update employees
set salary = salary * 1.1;

select * from employees;

update employees
set salary = salary * 1.1
where department = 'IT';

-- 여러 컬럼 동시 수정
update employees
set salary =10000, department = 'Marketing'
where name = 'evan2';

-- 여러 행 동시 수정
update employees
set salary = case
when id = 1 then 5000
when id = 2 then 6000
end
where id in(1,2);

select * from employees;

-- 서브쿼리
use classicmodels;
select * from customers;
select * from orders;

-- 첫번째 문제 : 주문을 한건도 하지 않은 customerName을 조회하세요
-- HINT : where절 서브쿼리 이용
-- 메인쿼리 : customerName을 조회하는것
-- 서브쿼리 : 주문을 한건도 하지 않은 사람

-- not in 연산자
select customerNumber, customerName from customers;
select distinct customerNumber from orders; -- 주문을 한건이라도 한 사람
-- 주문을 안한 사람을 조회하면 됨
select customerNumber, customerName
from customers
where customerName not in (
	select distinct customerNumber from orders -- 주문을 한 사람
);

-- 주문별 주문 항목 수 통계 구하기
-- orderNumber 주문 항목 수 통계 구하기
-- max, min, avg
-- from 인라인 뷰
select * from orderdetails;
select count(*) from orderdetails;
-- 주문번호당 주문 건수
select  
	max(cnt) as 최대건수
    , min(cnt) as 최소건수
    , floor(avg(cnt)) as 평균건수
from (
	select ordernumber, count(orderNumber) as cnt
	from orderdetails
	group by orderNumber
) A
;