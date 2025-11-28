select * from books;

select * from branch;

select * from employees;

select * from issued_status;

select * from members;

select * from return_status;

-- Project task

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
insert into books (isbn, book_title, category, rental_price, status, author, publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');


-- Task 2: Update an Existing Member's Address
select * from members;

update members
	set member_address = '125 Main Street'
	where member_id = 'C101';

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
	
select * from issued_status;

delete from issued_status
	where issued_id = 'IS121'

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select *
	from issued_status
	where issued_emp_id = 'E101' ;

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
Select 
		issued_emp_id,
		count(issued_book_isbn) as No_issued
	from issued_status
	group by issued_emp_id
	having count(issued_book_isbn)>1
	order by No_issued desc;

-- CTAS (Create Table As Select Statement)
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
	create table  book_counts
	as
		select 
				bk.isbn,
				bk.book_title,
				count(ist.issued_id) as no_issued
			from books as bk
				JOIN
				issued_status as ist
					ON ist.issued_book_isbn = bk.isbn
			group by bk.isbn, bk.book_title
			order by no_issued desc;

	select * 
		from book_counts;

-- DATA ANALYSIS

-- Task 7. Retrieve All Books in a Specific Category:
	Select 	
			category,
			book_title,
			count(isbn)
		from books
		group by category, book_title
		order by 1;

	select *
	 from books
	 where category = 'Children';

-- Task 8: Find Total Rental Income by Category:
	select 
		bk.category,
		sum(bk.rental_price) as revenue,
		count(*) as units
		from books as bk
		JOIN
			issued_status as ist
			ON
			bk.isbn = ist.issued_book_isbn
		group by bk.category
		order by revenue desc;


-- Task 9: List Members Who Registered in the Last 180 Days:
	select *
		from members
		where reg_date >= current_date - interval '3200 days';

	insert into members (member_id, member_name, member_address, reg_date)
		values ('C115','Shabz','124 Kitale Ln', '2025-10-18'),
				('C116','Saluu','425 PSTC Ln', '2025-11-18');

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:
select*
	from branch;
select*
	from employees;

select 
	em.emp_id,
	em.emp_name,
	em2.emp_name as manager,
	em2.position,
	em2.salary,
	br.branch_id
	from employees as em
		join
		branch as br
			on em.branch_id = br.branch_id
		join
		employees as em2
			on br.manager_id = em2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
Create table books_above_5
as
	select *
		from books
		where rental_price >= 5.5
		order by rental_price;


-- Task 12: Retrieve the List of Books Not Yet Returned
select *
	from books;

select*
	from issued_status;

select *
	from return_status;

select *
		-- ist.issued_id,
		-- ist.issued_book_isbn,
		-- ist.issued_book_name,
		-- ist.issued_date,
		-- ist.issued_member_id,
		-- rst.return_id,
		-- rst.return_date
	from issued_status as ist
		left join
		return_status as rst
			on ist.issued_id = rst.issued_id
		where rst.return_id is null;