-- MySQL 직원 급여 관리 시스템 강의

SET SQL_SAFE_UPDATES = 0;

-- 1. 데이터베이스 생성 및 초기화
DROP DATABASE IF EXISTS trigger_demo;
CREATE DATABASE trigger_demo;
USE trigger_demo;

-- 2. 테이블 생성
-- 2.1 직원(employees) 테이블 생성
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,             -- 직원 ID, 자동 증가, 기본 키
    name VARCHAR(100) NOT NULL,                    -- 직원 이름, 최대 100자, 필수 입력
    salary DECIMAL(10,2) NOT NULL,                 -- 급여, 소수점 2자리까지 지원하는 10자리 숫자, 필수 입력
    department VARCHAR(50) NOT NULL,               -- 부서 이름, 최대 50자, 필수 입력
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- 생성 시간, 기본값은 현재 시간
);

-- 2.2 급여 변경 이력(salary_logs) 테이블 생성
CREATE TABLE salary_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,                                   -- 로그 ID, 자동 증가, 기본 키
    employee_id INT,                                                     -- 직원 ID (employees 테이블의 id를 참조)
    old_salary DECIMAL(10,2),                                            -- 변경 전 급여
    new_salary DECIMAL(10,2),                                            -- 변경 후 급여
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                     -- 급여 변경 시각, 기본값은 현재 시간
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE -- employee_id는 employees 테이블의 id를 참조하며, 직원 삭제 시 연쇄 삭제
);

-- 2.3 삭제된 직원 기록(employee_deletion_logs) 테이블 생성
CREATE TABLE employee_deletion_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,                -- 로그 ID, 자동 증가, 기본 키
    employee_id INT,                                  -- 삭제된 직원의 ID
    employee_name VARCHAR(100),                       -- 삭제된 직원의 이름
    salary DECIMAL(10,2),                             -- 삭제되기 전 직원의 급여
    department VARCHAR(50),                           -- 삭제되기 전 직원의 부서명
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP    -- 삭제 시각, 기본값은 현재 시간
);

-- 3. 트리거 생성
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

-- 4. 샘플 데이터 삽입
-- 4.1 직원 추가
INSERT INTO employees (name, salary, department) VALUES
    ('홍길동', 50000.00, 'Engineering'),
    ('김철수', 45000.00, 'Marketing'),
    ('이영희', 55000.00, 'Sales');

-- 5. 데이터 조회 예제
-- 5.1 전체 직원 조회
SELECT * FROM employees;

-- 5.2 부서별 평균 급여 조회
SELECT 
    department,
    COUNT(*) as 직원수,
    AVG(salary) as 평균급여,
    MAX(salary) as 최고급여,
    MIN(salary) as 최저급여
FROM employees
GROUP BY department;

-- 5.3 급여 변경 이력 조회
-- 결과 : None
SELECT 
    sl.*,
    e.name as employee_name
FROM salary_logs sl
JOIN employees e ON sl.employee_id = e.id
ORDER BY sl.change_date DESC;

-- 5.4 삭제된 직원 기록 조회
SELECT * FROM employee_deletion_logs
ORDER BY deleted_at DESC;
-- 결과 : None

-- 6. 데이터 수정 예제
-- 6.1 급여 인상
UPDATE employees
SET salary = salary * 1.1
WHERE department = 'Engineering';

-- 6.2 부서 이동
UPDATE employees
SET department = 'Sales'
WHERE name = '김철수';

-- 7. 데이터 삭제 예제
-- 7.1 직원 삭제
DELETE FROM employees
WHERE name = '이영희';

-- 8. 고급 쿼리 예제
-- 8.1 부서별, 월별 평균 급여 변동 추이
SELECT 
    e.department,
    DATE_FORMAT(sl.change_date, '%Y-%m') as month,
    AVG(sl.new_salary) as avg_new_salary
FROM salary_logs sl
JOIN employees e ON sl.employee_id = e.id
GROUP BY e.department, DATE_FORMAT(sl.change_date, '%Y-%m')
ORDER BY e.department, month;

-- 8.2 가장 많은 급여 변경이 있었던 직원 TOP 5
SELECT 
    e.name,
    e.department,
    COUNT(*) as salary_change_count
FROM salary_logs sl
JOIN employees e ON sl.employee_id = e.id
GROUP BY sl.employee_id
ORDER BY salary_change_count DESC
LIMIT 5;

-- 9. 뷰 생성 예제
-- 9.1 직원 상세 정보 뷰
CREATE VIEW employee_details AS
SELECT 
    e.*,
    (SELECT COUNT(*) FROM salary_logs WHERE employee_id = e.id) as salary_change_count,
    (SELECT MAX(change_date) FROM salary_logs WHERE employee_id = e.id) as last_salary_change
FROM employees e;

-- 9.2 최근 급여 변경일이 있는 지원 조회 
SELECT 
    id, name, department, salary_change_count, last_salary_change
FROM employee_details
WHERE salary_change_count > 0
ORDER BY last_salary_change DESC;

-- 9.3 급여 변경 이력이 없는 직원 찾기
SELECT 
    id, name, department
FROM employee_details
WHERE salary_change_count = 0;


-- 10. 인덱스 생성 예제
-- 10.1 급여 검색 최적화를 위한 인덱스
CREATE INDEX idx_employee_salary ON employees(salary);

-- 10.1.1 급여가 5000 이상인 직원 조회 (급여 인덱스 활용)
SELECT id, name, salary
FROM employees
WHERE salary >= 5000
ORDER BY salary DESC;

-- 10.2 부서별 검색 최적화를 위한 인덱스
CREATE INDEX idx_employee_department ON employees(department);

-- 10.2.1 특정 부서(예: 'Engineering') 직원 조회 (부서 인덱스 활용)
SELECT id, name, department
FROM employees
WHERE department = 'Engineering'
ORDER BY name;

-- 10.2.2 부서별 평균 급여 구하기 (부서 인덱스 활용)
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;





