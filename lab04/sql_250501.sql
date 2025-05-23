-- MySQL 급여 관리 시스템 트리거

SET SQL_SAFE_UPDATES = 0; -- 수정 삭제 가능

-- 1. DB 생성 및 초기화
drop database if exists trigger_demo;
create schema `trigger_demo`;
use trigger_demo;

-- 2. 테이블 생성
-- 직원 테이블 생성
create table employees(
	id int auto_increment primary key
    , name varchar(100) not null
    , salary decimal(10, 2) not null
    , department varchar(50) not null
    , created_at timestamp default current_timestamp -- 생성 시간, 기본 값은 현재 시간
)
;

-- 급여 변경 이력 테이블 생성
-- 외래키 참조를 해서 테이블 생성
create table salary_logs (
	id int auto_increment primary key
    , employee_id int -- employees 테이블 ID 참조
    , old_salary decimal(10, 2)
    , new_salary decimal(10, 2)
    , change_date timestamp default current_timestamp
    -- 중요 : 해당 직원이 삭제되면 연쇄적으로 삭제를 함
    , foreign key (employee_id) references employees(id) on delete cascade
)
;
drop table employees;
drop table salary_logs;
drop table employee_deletion_logs;
-- 삭제된 직원 기록 테이블 생성
-- 여기서는 관계형을 안 만들었음
-- 이유는 employees 테이블의 복제본 느낌
create table employee_deletion_logs (
	id int auto_increment primary key
    , employee_id int
    , employee_name varchar(100)
    , salary decimal(10, 2) -- 삭제되기 직전 직원 급여
    , department varchar(50) -- 부서명
    , deleted_at timestamp default current_timestamp -- 삭제 시간
)
;

-- 트리거 생성
-- 3.1 급여 변경 트리거
/*
- BEFORE UPDATE: employees 테이블에서 수정이 일어나기 직전에 발동.
- IF NEW.salary != OLD.salary THEN: 급여(salary)가 변경되었을 때만 작동.
- 급여가 변경된 경우 salary_logs 테이블에 직원의 ID, 이전 급여, 새로운 급여를 기록한다.
*/

-- 구분자(DELIMITER)를 //로 변경 (트리거 안에 세미콜론(;)이 있기 때문)
DELIMITER //
-- employees 테이블에서 급여가 변경되기 직전에 작동하는 트리거 생성
CREATE TRIGGER before_salary_update
BEFORE UPDATE ON employees      -- employees 테이블의 UPDATE 전에 작동
FOR EACH ROW                    -- 업데이트되는 각 행(row)마다 실행
BEGIN
    -- 급여가 변경된 경우에만 동작
    IF NEW.salary != OLD.salary THEN
        -- 변경 전 급여(OLD.salary)와 변경 후 급여(NEW.salary)를 salary_logs 테이블에 기록
        INSERT INTO salary_logs (employee_id, old_salary, new_salary)
        VALUES (OLD.id, OLD.salary, NEW.salary);
    END IF;
END//
-- 다시 구분자(DELIMITER)를 기본값(;)으로 복원
DELIMITER ;

-- 3.2 직원 삭제 트리거
/*
- BEFORE DELETE: employees 테이블에서 직원이 삭제되기 직전에 발동.
- OLD: 삭제되기 전의 데이터를 참조.
- employee_deletion_logs 테이블에 삭제되는 직원의 ID, 이름, 급여, 부서 정보를 기록한다.
- deleted_at 컬럼은 테이블 설정상 자동으로 현재 시간이 들어가므로 별도로 INSERT하지 않아도 된다. 
*/

-- 구분자(DELIMITER)를 //로 변경 (트리거 내부에 세미콜론(;)이 있기 때문)
DELIMITER //
-- employees 테이블에서 삭제되기 전에 작동하는 트리거 생성
CREATE TRIGGER before_employee_delete
BEFORE DELETE ON employees       -- employees 테이블의 DELETE 전에 실행
FOR EACH ROW                     -- 삭제되는 각 행(row)마다 실행
BEGIN
    -- 삭제될 직원의 정보를 employee_deletion_logs 테이블에 기록
    INSERT INTO employee_deletion_logs 
    (employee_id, employee_name, salary, department)
    VALUES 
    (OLD.id, OLD.name, OLD.salary, OLD.department);
END//
-- 구분자(DELIMITER)를 기본값(;)으로 복원
DELIMITER ;

-- 트리거 목록 확인
show triggers;

-- 트리거 삭제
drop trigger if exists before_salary_update;
drop trigger if exists before_employee_delete;

-- 4. 데이터 추가
INSERT INTO employees (name, salary, department) VALUES
    ('홍길동', 50000.00, 'Engineering'),
    ('김철수', 45000.00, 'Marketing'),
    ('이영희', 55000.00, 'Sales');
    
-- 5. 데이터 조회
select * from employees;

select * from salary_logs;
select * from employee_deletion_logs;

-- 6. 데이터 수정
-- 급여 인상
update employees
set salary = salary * 1.1
where department = 'Engineering'
;

-- 부서 이동
update employeesemployee_deletion_logs
set department = 'Sales'
where name = '김철수'
;

-- 데이터 삭제
-- 직원 삭제
delete from employees
where name ='이영희'
;