from dataclasses import dataclass
from datetime import datetime
from typing import Optional

@dataclass
class Employee:
    id: Optional[int] = None
    name: str = ""
    salary: float = 0.0
    department: str = ""
    created_at: Optional[datetime] = None

@dataclass
class SalaryLog:
    id: Optional[int] = None
    employee_id: Optional[int] = None
    old_salary: float = 0.0
    new_salary: float = 0.0
    change_date: Optional[datetime] = None 