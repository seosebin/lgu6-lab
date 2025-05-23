import streamlit as st
import mysql.connector
from mysql.connector import Error
from database import get_db_connection, initialize_database

# 세션 상태 초기화
# 웹 관련 용어
if 'db_initialized' not in st.session_state:
    st.session_state.db_initialized = False

# 페이지 설정
st.set_page_config(
    page_title="Employee Salary Management",
    page_icon="💰",
    layout="wide"
)

# 헬퍼 함수들 => Web에서는 백엔드 처리
def get_employees():
    # 모든 직원 정보를 가져오는 함수
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM employees")
        employees = cursor.fetchall()
        return employees
    except Error as e:
        st.error(f"Error fetching employees: {e}")
        return []
    finally:
        if 'conn' in locals():
            conn.close()

def get_deletion_logs():
    # 삭제된 직원의 로그를 가져오는 함수
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT * FROM employee_deletion_logs
            ORDER BY deleted_at DESC
        """)
        logs = cursor.fetchall()
        return logs
    except Error as e:
        st.error(f"Error fetching deletion logs: {e}")
        return []
    finally:
        if 'conn' in locals():
            conn.close()

def add_employee(name: str, salary: float, department: str):
    # 새로운 직원을 추가하는 함수
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO employees (name, salary, department) VALUES (%s, %s, %s)",
            (name, salary, department)
        )
        conn.commit()
        return True
    except Error as e:
        st.error(f"Error adding employee: {e}")
        return False
    finally:
        if 'conn' in locals():
            conn.close()

def delete_employee(employee_id: int):
    # 직원을 삭제하는 함수
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM employees WHERE id = %s", (employee_id,))
        conn.commit()
        return True
    except Error as e:
        st.error(f"Error deleting employee: {e}")
        return False
    finally:
        if 'conn' in locals():
            conn.close()

def get_salary_logs():
    # 급여 변경 이력을 가져오는 함수
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT sl.*, e.name as employee_name 
            FROM salary_logs sl
            JOIN employees e ON sl.employee_id = e.id
            ORDER BY sl.change_date DESC
        """)
        logs = cursor.fetchall()
        return logs
    except Error as e:
        st.error(f"Error fetching salary logs: {e}")
        return []
    finally:
        if 'conn' in locals():
            conn.close()

def update_employee_salary(employee_id: int, new_salary: float):
    # 직원의 급여를 업데이트하는 함수
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "UPDATE employees SET salary = %s WHERE id = %s",
            (new_salary, employee_id)
        )
        conn.commit()
        return True
    except Error as e:
        st.error(f"Error updating salary: {e}")
        return False
    finally:
        if 'conn' in locals():
            conn.close()

# 메인 UI
st.title("💰 Employee Salary Management System")

# 사이드바 액션 메뉴 => 프론트엔드 처리하는 영역
with st.sidebar:
    st.header("Actions")
    
    # 데이터베이스 초기화 섹션
    st.subheader("Database Management")
    if st.button("🔄 Initialize Database", type="primary"):
        try:
            initialize_database()
            st.session_state.db_initialized = True
            st.success("Database initialized successfully!")
            st.rerun()
        except Error as e:
            st.error(f"Error initializing database: {e}")
    
    st.divider()
    
    # 메인 액션 섹션
    st.subheader("Main Actions")
    action = st.radio(
        "Choose an action:",
        ["View Employees", "Add Employee", "Update Salary", "View Salary History", "View Deleted Employees"]
    )

# 메인 콘텐츠 영역
if action == "View Employees":
    # 직원 목록 보기
    st.header("Employee List")
    employees = get_employees()
    if employees:
        # 삭제 버튼이 있는 상세 보기 생성
        for emp in employees:
            col1, col2, col3, col4, col5 = st.columns([2, 2, 2, 2, 1])
            with col1:
                st.write(f"**Name:** {emp['name']}")
            with col2:
                st.write(f"**Salary:** ${emp['salary']:,.2f}")
            with col3:
                st.write(f"**Department:** {emp['department']}")
            with col4:
                st.write(f"**Joined:** {emp['created_at']}")
            with col5:
                if st.button("Delete", key=f"del_{emp['id']}", type="secondary"):
                    if delete_employee(emp['id']):
                        st.success("Employee deleted successfully!")
                        st.rerun()
            st.divider()
    else:
        st.info("No employees found in the database.")

elif action == "Add Employee":
    # 새로운 직원 추가
    st.header("Add New Employee")
    with st.form("add_employee_form"):
        name = st.text_input("Employee Name")
        salary = st.number_input("Salary", min_value=0.0, step=1000.0)
        department = st.selectbox(
            "Department",
            ["Engineering", "Marketing", "Sales", "HR", "Finance", "Operations"]
        )
        
        if st.form_submit_button("Add Employee", type="primary"):
            if name and salary > 0:
                if add_employee(name, salary, department):
                    st.success(f"Employee {name} added successfully!")
                    st.rerun()
            else:
                st.error("Please fill in all fields correctly.")

elif action == "Update Salary":
    # 급여 업데이트
    st.header("Update Employee Salary")
    employees = get_employees()
    
    if employees:
        employee_options = {f"{emp['name']} (ID: {emp['id']})": emp['id'] for emp in employees}
        selected_employee = st.selectbox(
            "Select Employee",
            options=list(employee_options.keys())
        )
        
        employee_id = employee_options[selected_employee]
        current_salary = next(emp['salary'] for emp in employees if emp['id'] == employee_id)
        
        st.write(f"Current Salary: ${current_salary:,.2f}")
        new_salary = st.number_input(
            "New Salary",
            min_value=0.0,
            value=float(current_salary),
            step=1000.0
        )
        
        if st.button("Update Salary", type="primary"):
            if update_employee_salary(employee_id, new_salary):
                st.success(f"Salary updated successfully to ${new_salary:,.2f}")
                st.rerun()
    else:
        st.info("No employees found in the database.")

elif action == "View Salary History":
    # 급여 변경 이력 보기
    st.header("Salary Change History")
    logs = get_salary_logs()
    if logs:
        for log in logs:
            col1, col2, col3, col4 = st.columns([2, 2, 2, 2])
            with col1:
                st.write(f"**Employee:** {log['employee_name']}")
            with col2:
                st.write(f"**Old Salary:** ${log['old_salary']:,.2f}")
            with col3:
                st.write(f"**New Salary:** ${log['new_salary']:,.2f}")
            with col4:
                st.write(f"**Changed:** {log['change_date']}")
            st.divider()
    else:
        st.info("No salary changes recorded yet.")

elif action == "View Deleted Employees":
    # 삭제된 직원 이력 보기
    st.header("Deleted Employee History")
    deletion_logs = get_deletion_logs()
    if deletion_logs:
        for log in deletion_logs:
            col1, col2, col3, col4 = st.columns([2, 2, 2, 2])
            with col1:
                st.write(f"**Name:** {log['employee_name']}")
            with col2:
                st.write(f"**Last Salary:** ${log['salary']:,.2f}")
            with col3:
                st.write(f"**Department:** {log['department']}")
            with col4:
                st.write(f"**Deleted At:** {log['deleted_at']}")
            st.divider()
    else:
        st.info("No employee deletion records found.") 