--Create a new database named "CompanyDB."
create database Company;

use Company;
--Design and create two tables Employees and Departments.

--Employees table should have fields: EmployeeID (int, primary key), FirstName (varchar), LastName (varchar), DepartmentID (int, foreign key to Departments table), and Salary (decimal).
CREATE TABLE Employees (
    EmployeeID INT not null unique identity,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
	gender varchar,
    Salary DECIMAL(10, 2),
		foreign key (DepartmentID) references Departments(DepartmentID)
	
	);

INSERT INTO Employees (FirstName, LastName, DepartmentID,gender, Salary)
VALUES
    ('Tayyaba', 'Muslim', 1,'F', 78000.00),
    ('Sawera', 'Ansari', 2,'F', 98000.00),
    ('Ayra', 'khan', 4,'F', 45000.00),
    ('Shahzain', 'Ali', 3,'M', 60000.00),
    ('Muhammad', 'Ahmed', 2,'M', 40000.00),
    ('Ahmed', 'Raza', 5, 'M',65000.00),
    ('Mishal', 'Khan', 3,'F', 85000.00),
    ('Sunny', 'Ansari', 5,'M', 43000.00),
    ('Ruhi', 'Imran', 1,'F', 57000.00),
    ('Shibra', 'Ikram', 4,'F', 77000.00);

	
--Departments table should have fields: DepartmentID (int, primary key), DepartmentName (varchar).
CREATE TABLE Departments (
    DepartmentID INT not null unique identity,
    DepartmentName VARCHAR(50)
);


INSERT INTO Departments (DepartmentName)
VALUES
    ('HR'),
    ( 'Marketing Department'),
	( 'Administration'),    
	( 'Finance'),
    ( 'Sales');
	select * from Departments;
	
	 --Aggregate function with group by clause
	 --rollup with inner join
   select Dept.DepartmentName,sum(salary) as total_salary from Employees Emp INNER JOIN Departments Dept on Emp.DepartmentID = Dept.DepartmentID group
   by (Dept.DepartmentName) with rollup;

   --cube with inner join
    select Dept.DepartmentName,sum(salary) as total_salary from Employees Emp INNER JOIN Departments Dept on Emp.DepartmentID = Dept.DepartmentID group
    by cube(Emp.firstname,Dept.DepartmentName);

   --with rollup
   select gender, sum(salary) as total_salary from Employees group by (gender) with rollup;

   --with cube
   select gender, sum(salary) as total_salary from Employees group by cube(gender, salary);
     
    --views
	create view emp_view 
	as
	select * from Employees;

	select * from emp_view;

	select FirstName, LastName,Salary from Employees;
	--join
	select  FirstName, LastName,Salary  from Departments as Dept join Employees as Emp on Dept.DepartmentID = Emp.DepartmentID; 
	--join select all 
    select  * from Departments as Dept join Employees as Emp on Dept.DepartmentID = Emp.DepartmentID; 




	--update
	update Employees set FirstName = 'Alyana', LastName = 'Fakhar' where DepartmentID =1;
	select * from Employees;

	--Display view function
	--method1
	Sp_helptext emp_view;

	--method2
	select definition from sys.sql_modules where object_id = object_id ('emp_view');

	--method3
	select object_definition(object_id('emp_view'));


		--login
	create login sawera with password ='sawera';

	--create user tayyaba for login tayyaba
	create user sawera for login sawera;
	GO
	--grant
	grant select, update, insert on dbo.employees to sawera;
	select * from employees;
	update employees set FirstName = 'ayrakhan' where EmployeeID= 3;
	INSERT INTO Employees (FirstName, LastName, DepartmentID,gender, Salary)
      VALUES
    ('Tayyaba', 'Muslim', 1,'F', 78000.00);

	delete from employees where EmployeeID = 11;

	--revoke
	revoke select, update  on dbo.employees from sawera;

	--deny
	deny delete on dbo.employees to sawera;
	--functions
	--FLOOR
	select FLOOR(4.4);

	--scalar function without parameters
	create function FullName()
	returns varchar(255)
	begin 

	return 'sawera ansari'
	end

	select dbo.FullName();

	--scalar function with parameters
	create function addition(@num1 as int, @num2 as int)
	returns int
	begin
	return (@num1 + @num2)
	end
	select dbo.addition(7,5) as addition;

	--function with variable
	create function students_name(@age as int)
	returns varchar(255)
	as
	begin
	declare @str varchar(100)
	if(@age >= 15)
	begin
	set @str = 'you are eligible'
	end
	else
	begin
	set @str = 'sorry! you are not eligible'
	end
	return @str
	end
	select dbo.students_name(20)  
	
	--table valued function
	create function emp()
	returns table
	as
	return select * from Employees

	select * from emp();

	--with parameter
	create function employee(@gender as varchar(20))
	returns table
	as
	return select * from Employees where gender = @gender

	select * from employee('M');

	--alter
	alter function employee()
	returns table
	as
	return select distinct FirstName from Employees

	select * from employee();
	--stored procedures--
	create procedure sptableEmp
	as
	begin
	select * from Employees;
	end
	go
	exec sptableEmp;
	--with join 
		create procedure spjoinprocedure
	as
	begin
	select emp.FirstName,LastName,Dept.DepartmentName from Employees as emp join Departments as Dept on Emp.DepartmentID = Dept.DepartmentID
	where emp.DepartmentID=1
	end
	go
	exec spjoinprocedure;
	--with alter join
	alter procedure spjoinprocedure
	as 
	begin
		select emp.FirstName,LastName,Dept.DepartmentName from Employees as emp join Departments as Dept on Emp.DepartmentID = Dept.DepartmentID
		end
		go
		exec spjoinprocedure;
		--benefit
		create procedure spwithID
		@id int
		as 
		begin
		select * from Employees where EmployeeID = @id
		end
		exec spwithID 2;
		exec spwithID @id=3;
		-- salary increment
	create procedure salaryincrementid1
	@id int,
	@fname varchar(255)
	as
	begin
	select FirstName,LastName,gender,((salary/100)*5) +Salary FROM Employees Where EmployeeID =@id
	end
	go
	exec salaryincrementid1 @id = 2, @fname = 'sawera'




