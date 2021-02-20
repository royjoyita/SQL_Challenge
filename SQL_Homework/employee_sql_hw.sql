CREATE TABLE titles (
  title_id VARCHAR NOT NULL,
  title VARCHAR NOT NULL,
  PRIMARY KEY(title_id)
);

copy titles from '/Users/joyitaroy/public/titles.csv'
delimiter ',' csv header;

select * from titles


CREATE TABLE employees (
  emp_no INT NOT NULL,
  emp_title_id VARCHAR NOT NULL,
  birth_date DATE NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name  VARCHAR NOT NULL,
  sex VARCHAR(30) NOT NULL,
  hire_date DATE NOT NULL,
  FOREIGN KEY (emp_title_id) REFERENCES titles(title_id),
  PRIMARY KEY (emp_no)
);

copy employees from '/Users/joyitaroy/public/employees.csv'
delimiter ',' csv header;

select * from employees

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  PRIMARY KEY (emp_no)
);

copy salaries from '/Users/joyitaroy/public/salaries.csv'
delimiter ',' csv header;

select * from salaries

CREATE TABLE departments (
 dept_no VARCHAR NOT NULL,
  dept_name VARCHAR NOT NULL,
  PRIMARY KEY(dept_no)
);

copy departments from '/Users/joyitaroy/public/departments.csv'
delimiter ',' csv header;

select * from departments

CREATE TABLE dept_manager (
  dept_no VARCHAR NOT NULL,
  FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
  emp_no INT NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
  PRIMARY KEY (dept_no, emp_no)
);

copy dept_manager from '/Users/joyitaroy/public/dept_manager.csv'
delimiter ',' csv header;

select * from dept_manager

CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
  dept_no VARCHAR NOT NULL,
  FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
  PRIMARY KEY(dept_no, emp_no)
);

copy dept_emp from '/Users/joyitaroy/public/dept_emp.csv'
delimiter ',' csv header;

select * from dept_emp


#Q - 1 : -- employee number, last name, first name, sex, and salary

select employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
from salaries 
inner join employees on 
employees.emp_no=salaries.emp_no;

# Q - 2 : List first name, last name, and hire date for employees who were hired in 1986.

select * from(select first_name, last_name, date_part('year', hire_date)
			 as hire_year from employees) aa
			 where hire_year = '1986'
             
# Q - 3 : -- -- manager: department number, department name, the manager’s employee number, last name, first name

SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
 FROM dept_manager
 LEFT JOIN departments
 ON (departments.dept_no = dept_manager.dept_no)
 LEFT JOIN employees
 ON (employees.emp_no = dept_manager.emp_no);

# Q - 4 : -- DEPARTMENT : employee number, last name, first name, and department name.

SELECT dept_emp.emp_no, dept_emp.dept_no, departments.dept_name, employees.last_name, employees.first_name
FROM dept_emp
INNER JOIN departments
ON (dept_emp.dept_no = departments.dept_no)
INNER JOIN employees
ON (employees.emp_no = dept_emp.emp_no);

# Q - 5 : -- -- List first name, last name, and sex for employees whose 
#-- first name is “Hercules” and last names begin with “B.”

SELECT first_name, last_name, sex
FROM employees
WHERE last_name LIKE 'B%' AND first_name = 'Hercules';

# Q -- 6

SELECT  employees.emp_no,
        employees.last_name,
        employees.first_name,
        departments.dept_name
FROM employees
    INNER JOIN dept_emp
        ON (employees.emp_no = dept_emp.emp_no)
    INNER JOIN departments
        ON (dept_emp.dept_no = departments.dept_no)
WHERE departments.dept_name = 'Sales'
ORDER BY employees.emp_no;

# Q -- 7

SELECT  employees.emp_no,
        employees.last_name,
        employees.first_name,
        departments.dept_name
FROM employees
    INNER JOIN dept_emp
        ON (employees.emp_no = dept_emp.emp_no)
    INNER JOIN departments
        ON (dept_emp.dept_no = departments.dept_no)
WHERE departments.dept_name = 'Sales' OR departments.dept_name = 'Development'
ORDER BY employees.emp_no;

#Q 8 - -- In descending order, list the frequency count of employee last names, 
#i.e., how many employees share each last name.

select last_name, count(last_name)as frequency
from employees
group by last_name
order by count(last_name)desc