import mysql.connector
from mysql.connector import Error
import os
from dotenv import load_dotenv

# .env 파일 로드
load_dotenv()

# MySQL 데이터베이스 연결을 생성하는 함수
def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host=os.getenv('DB_HOST'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD'),
            database=os.getenv('DB_NAME')
        )
        return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None

# 데이터베이스와 테이블을 초기화하는 함수
def initialize_database():
    try:
        # 데이터베이스 없이 MySQL 서버에 연결
        connection = mysql.connector.connect(
            host=os.getenv('DB_HOST'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD')
        )
        
        cursor = connection.cursor()
        
        # 데이터베이스 생성 (이미 존재하면 삭제 후 재생성)
        cursor.execute(f"DROP DATABASE IF EXISTS {os.getenv('DB_NAME')}")
        cursor.execute(f"CREATE DATABASE {os.getenv('DB_NAME')}")
        cursor.execute(f"USE {os.getenv('DB_NAME')}")
        
        # 직원 정보를 저장하는 테이블 생성
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS employees (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                salary DECIMAL(10,2) NOT NULL,
                department VARCHAR(50) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        # 급여 변경 이력을 저장하는 테이블 생성 (직원 삭제 시 함께 삭제되도록 CASCADE 설정)
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS salary_logs (
                id INT AUTO_INCREMENT PRIMARY KEY,
                employee_id INT,
                old_salary DECIMAL(10,2),
                new_salary DECIMAL(10,2),
                change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
            )
        """)

        # 직원 삭제 이력을 저장하는 테이블 생성
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS employee_deletion_logs (
                id INT AUTO_INCREMENT PRIMARY KEY,
                employee_id INT,
                employee_name VARCHAR(100),
                salary DECIMAL(10,2),
                department VARCHAR(50),
                deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        # 기존 트리거 삭제
        cursor.execute("DROP TRIGGER IF EXISTS before_salary_update")
        cursor.execute("DROP TRIGGER IF EXISTS before_employee_delete")
        
        # 급여 업데이트 전에 실행되는 트리거 생성
        trigger_sql = """
        CREATE TRIGGER before_salary_update
        BEFORE UPDATE ON employees
        FOR EACH ROW
        BEGIN
            IF NEW.salary != OLD.salary THEN
                INSERT INTO salary_logs (employee_id, old_salary, new_salary)
                VALUES (OLD.id, OLD.salary, NEW.salary);
            END IF;
        END;
        """
        cursor.execute(trigger_sql)

        # 직원 삭제 전에 실행되는 트리거 생성
        deletion_trigger_sql = """
        CREATE TRIGGER before_employee_delete
        BEFORE DELETE ON employees
        FOR EACH ROW
        BEGIN
            INSERT INTO employee_deletion_logs 
            (employee_id, employee_name, salary, department)
            VALUES 
            (OLD.id, OLD.name, OLD.salary, OLD.department);
        END;
        """
        cursor.execute(deletion_trigger_sql)
        
        connection.commit()
        return True
        
    except Error as e:
        print(f"Error initializing database: {e}")
        return False
    finally:
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close() 