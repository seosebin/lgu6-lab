-- Chapter 9�� 
-- �ǽ� ������ �Ұ� 
USE lily_book_test;

-- ���̺� Ȯ�� 
SELECT * FROM sales;
SELECT * FROM customer;

-- ���̺� �⺻ ���� Ȯ���ϴ� ��ɾ�
exec sp_help 'sales'; 

/***********************************************************
�� ���� Ʈ���� (p.203)
invoiceNo : �ֹ��Ǽ�(�ŷ�������ȣ)
StockCode : ��ǰ������ȣ
Description : ��ǰ��
Quantity : �ŷ�����
InvoiceDate : �ŷ��Ͻ�
UnitPrice : ��ǰ�ܰ�
CustomerID : ������ ���� ��ȣ
Country : ���ű���
************************************************************/

-- �Ⱓ�� ���� ��Ȳ
-- ��� �÷� : invoicedate, �����, �ֹ�����, �ֹ��Ǽ�, �ֹ�����
-- Ȱ�� �Լ� : SUM(), COUNT()
select CONVERT(date, invoicedate) as invoicedate
	, sum(unitprice*quantity)as �����
	, sum(quantity) as �ֹ�����
	, count (distinct invoiceno) as �ֹ��Ǽ�
	, count (distinct customerid) as �ֹ�����
from sales group by convert(date, invoicedate)
order by invoicedate;

-- ������ ���� ��Ȳ
-- ��� �÷� : country, �����, �ֹ�����, �ֹ��Ǽ�, �ֹ�����
-- Ȱ�� �Լ� : SUM(), COUNT()
select country as ����
	, sum(unitprice*quantity) as �����
	, sum(quantity) as �ֹ�����
	, count (distinct invoiceno) as �ֹ��Ǽ�
	, count (distinct customerid) as �ֹ�����
from sales group by country;


-- ������ x ��ǰ�� ���� ��Ȳ 
-- ��� �÷� : country, stockcode, �����, �ֹ�����, �ֹ��Ǽ�, �ֹ�����
-- Ȱ�� �Լ� : SUM(), COUNT()
select country as ����
	, stockcode as ��ǰ
	, round(sum(unitprice*abs(quantity)),2 ) as �����
	, sum(quantity) as �ֹ�����
	, count (distinct invoiceno) as �ֹ��Ǽ�
	, count (distinct customerid) as �ֹ�����
from sales group by country, stockcode;


-- Ư�� ��ǰ ���� ��Ȳ
-- ��� �÷� : �����, �ֹ�����, �ֹ��Ǽ�, �ֹ�����
-- Ȱ�� �Լ� : SUM(), COUNT()
-- �ڵ�� : 21615
select round(sum(unitprice*abs(quantity)),2 ) as �����
	, sum(quantity) as �ֹ�����
	, count(distinct invoiceno) as �ֹ�����
from sales where stockcode = '21615';

-- Ư�� ��ǰ�� �Ⱓ�� ���� ��Ȳ 
-- ��� �÷� : invoicedate, �����, �ֹ�����, �ֹ��Ǽ�, �ֹ�����
-- Ȱ�� �Լ� : SUM(), COUNT()
-- �ڵ�� : 21615, 21731
select CONVERT(date, invoicedate) as invoicedate
	, round(sum(unitprice*quantity), 2)as �����
	, sum(quantity) as �ֹ�����
	, count (distinct invoiceno) as �ֹ��Ǽ�
	, count (distinct customerid) as �ֹ�����
from sales 
where stockcode in ('21615', '21731')
group by CONVERT(date, invoicedate)


/***********************************************************
�� �̺�Ʈ ȿ�� �м� (p.213)
************************************************************/

-- �̺�Ʈ ȿ�� �м� (�ñ⿡ ���� ��)
-- 2011�� 9/10 ~ 2011�� 9/25���� �� 15�ϵ��� ������ �̺�Ʈ�� ���� Ȯ�� 
-- ��� �÷� : �Ⱓ ����, �����, �ֹ�����, �ֹ��Ǽ�, �ֹ����� 
-- Ȱ�� �Լ� : CASE WHEN, SUM(), COUNT()
-- �Ⱓ ���� �÷��� ���� ���� : �̺�Ʈ �Ⱓ, �̺�Ʈ �񱳱Ⱓ(�������Ⱓ)
SELECT 
    CASE 
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-09-10' AND '2011-09-25' THEN '�̺�Ʈ �Ⱓ'
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-08-10' AND '2011-08-25' THEN '�񱳱Ⱓ'
        ELSE '��Ÿ'
    END AS �Ⱓ����
	, SUM(unitprice*quantity) AS �����
	, sum(quantity) as �ֹ�����
	, count (distinct invoiceno) as �ֹ��Ǽ�
	, count (distinct customerid) as �ֹ�����
FROM sales
where invoicedate BETWEEN '2011-09-10' AND '2011-09-25'
	or invoicedate BETWEEN '2011-08-10' AND '2011-08-25'
GROUP BY CASE 
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-09-10' AND '2011-09-25' THEN '�̺�Ʈ �Ⱓ'
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-08-10' AND '2011-08-25' THEN '�񱳱Ⱓ'
        ELSE '��Ÿ'
    END
;


-- �̺�Ʈ ȿ�� �м� (�ñ⿡ ���� ��)
-- 2011�� 9/10 ~ 2011�� 9/25���� Ư�� ��ǰ�� �ǽ��� �̺�Ʈ�� ���� ���� Ȯ��
-- ��� �÷� : �Ⱓ ����, �����, �ֹ�����, �ֹ��Ǽ�, �ֹ����� 
-- Ȱ�� �Լ� : CASE WHEN, SUM(), COUNT()
-- �Ⱓ ���� �÷��� ���� ���� : �̺�Ʈ �Ⱓ, �̺�Ʈ �񱳱Ⱓ(�������Ⱓ)
-- ��ǰ�� : 17012A, 17012C, 17084N
SELECT 
    CASE 
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-09-10' AND '2011-09-25' THEN '�̺�Ʈ �Ⱓ'
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-08-10' AND '2011-08-25' THEN '�񱳱Ⱓ'
        ELSE '��Ÿ'
    END AS �Ⱓ����
	, SUM(unitprice*quantity) AS �����
	, sum(quantity) as �ֹ�����
	, count (distinct invoiceno) as �ֹ��Ǽ�
	, count (distinct customerid) as �ֹ�����
FROM sales
-- ������ �켱 ���� () > AND > OR
where (CONVERT(DATE, invoicedate) BETWEEN '2011-09-10' AND '2011-09-25'
	or CONVERT(DATE, invoicedate) BETWEEN '2011-08-10' AND '2011-08-25')
	and stockcode in ('17012A', '17012C', '17084N')
GROUP BY CASE 
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-09-10' AND '2011-09-25' THEN '�̺�Ʈ �Ⱓ'
        WHEN CONVERT(DATE, invoicedate) BETWEEN '2011-08-10' AND '2011-08-25' THEN '�񱳱Ⱓ'
        ELSE '��Ÿ'
    END
;


/***********************************************************
�� CRM �� Ÿ�� ��� (p.217)
************************************************************/

-- Ư�� ��ǰ ���� �� ����
-- ���� : 2010.12.1 - 2010.12.10�ϱ��� Ư�� ��ǰ ������ �� ���� ���
-- ��� �÷� : �� ID, �̸�, ����, �������, ���� ����, ���, ���� ä��
-- HINT : �ζ��� �� ��������, LEFT JOIN Ȱ��
-- Ȱ���Լ� : CONCAT()
-- �ڵ�� : 21730, 21615
-- Ư�� ��ǰ�� ������ �� ������ ����ϰ� ����
select * from sales;

-- �� ID : 16565
select * from customer where mem_no = '16565';

-- ������ �� ����, �⺻Ű�� �ܷ�Ű�� �׻� ����
-- ������ �Ǵ� ���̺��� �⺻Ű�� �ߺ����� ������ �־�� ��
-- sales �������� customerid �ߺ����� ��� �����ؼ� ��ġ �⺻Ű�� �����ϴ� ���̺� ���·� ����
select distinct  customerid from sales
where stockcode in ('21730', '21615')
	and CONVERT(DATE, invoicedate) BETWEEN '2010-12-01' AND '2010-12-18';

-- LEFT �������� Ǯ��
SELECT * 
FROM (
	SELECT DISTINCT customerid
	FROM sales
	WHERE stockcode IN ('21730', '21615')
		AND CONVERT(DATE, invoicedate) BETWEEN '2010-12-01' AND '2010-12-18'
	) s
LEFT 
JOIN (
	SELECT 
		mem_no
		, CONCAT(last_name, first_name) AS customer_name
		, gd
		, birth_dt
		, entr_dt
		, grade 
		, sign_up_ch
	FROM customer	
) c
ON s.customerid = c.mem_no;
 
 -- ���������� Ǯ��
SELECT 
    mem_no,
    CONCAT(last_name, first_name) AS customer_name,
    gd,
    birth_dt,
    entr_dt,
    grade,
    sign_up_ch
FROM 
    customer
WHERE 
    mem_no IN (
        SELECT DISTINCT customerid
        FROM sales
        WHERE stockcode IN ('21730', '21615')
          AND CONVERT(DATE, invoicedate) BETWEEN '2010-12-01' AND '2010-12-18'
    );

-- �̱��� �� ���� Ȯ��
-- ���� : ��ü ����� ���� �� �߿��� ���� �̷��� ���� ���� ���� �̷��� �ִ� �� ���� ���� 
-- ��� �÷� : non_purchaser, mem_no, last_name, first_name, invoiceno, stockcode, invoicedate, unitprice, customerid
-- HINT : LEFT JOIN
-- Ȱ���Լ� : CASE WHEN, IS NULL, 

-- customer left join sales
select 
	count(distinct case when s.customerid is null then c.mem_no end) as non_purchaser
	, count(distinct mem_no) as total_customer
from customer c
left join sales s on c.mem_no = s.customerid


-- ��ü ������ �̱��� ���� ��� 
-- ��� �÷� : non_purchaser, total_customer
-- HINT : LEFT JOIN
-- Ȱ�� �Լ� : COUNT(), IS NULL


/***********************************************************
�� �� ��ǰ ���� ���� (p.227)
************************************************************/

-- ���� ��� ��ǥ Ȱ���ϱ� 
-- ���� �����ǥ ���� : ATV, AMV, Avg.Frq, Avg.Units
-- ���� : sales �������� ���� �����ǥ, ATV, AMV, Avg.Frq, Avg.Units �˰� ����
-- ��� �÷� : �����, �ֹ�����, �ֹ��Ǽ�, �ֹ�����, ATV, AMV, Avg.Frq, Avg.Units
-- Ȱ���Լ� : SUM(), COUNT()
select
	round(sum(unitprice * quantity) / count(distinct invoiceno), 2) as atv -- �ֹ� �Ǽ�
	, round(sum(unitprice * quantity) / count(distinct customerid), 2) as amv -- �ֹ� ����
	, count(distinct invoiceno) * 1.00 / count(distinct customerid) as AvgFrq
from sales;


-- ���� : ���� : ���� �� ���� ���� �����ǥ, ATV, AMV, Avg.Frq, Avg.Units �˰� ����
-- ��� �÷� : ����, ��, �����, �ֹ�����, �ֹ��Ǽ�, �ֹ�����, ATV, AMV, Avg.Frq, Avg.Units
-- Ȱ���Լ� : SUM(), COUNT(), YEAR, MONTH
SELECT 
	YEAR(invoicedate) AS ���� 
	, month(invoicedate) as ��
	, round(sum(unitprice * quantity) / count(distinct invoiceno), 2) as atv -- �ֹ� �Ǽ�
FROM sales
group by year(invoicedate), month(invoicedate)
having round(sum(unitprice * quantity) / count(distinct invoiceno), 2) >= 400
order by 1,2
;

/***********************************************************
�� �� ��ǰ ���� ���� (p.230)
************************************************************/

-- Ư�� ���� ����Ʈ���� ��ǰ Ȯ��
-- ���� : 2011�⿡ ���� ���� �Ǹŵ� ��ǰ TOP 10�� ���� Ȯ�� 
-- ��� �÷� : stockcode, description, qty
-- Ȱ���Լ� : TOP 10, SUM(), YEAR()
/* �Ϲ����� SQL ����
select from group by ~~ �������� �ǸŰ��� ==> A1
select row_member() from (A1) ==> A2
select ~~ from (A2) where rnk <= 10 */
SELECT TOP 10
	stockcode 
	, CONVERT(VARCHAR(255), description) AS description
	, SUM(quantity) as qty 
FROM sales 
WHERE YEAR(invoicedate) = '2011'
GROUP BY stockcode, CONVERT(VARCHAR(255), description)
ORDER BY qty DESC
;



-- ������ ����Ʈ���� ��ǰ Ȯ��
-- ���� : �������� ���� ���� �Ǹŵ� ��ǰ ������ ������ ���ϰ� ����
-- ��� �÷� : RNK, country, stockcode, description, qty
-- HINT : �ζ��� �� ��������
-- Ȱ���Լ� : ROW_NUMBER() OVER(PARTITION BY...), SUM()
SELECT 
	ROW_NUMBER() OVER(PARTITION BY country ORDER BY qty DESC) as rnk
	, a.*
FROM (
	SELECT 
		country
		, stockcode 
		, CONVERT(VARCHAR(255), description) AS description
		, SUM(quantity) as qty 
	FROM sales 
	WHERE YEAR(invoicedate) = '2011'
	GROUP BY country, stockcode, CONVERT(VARCHAR(255), description)
) a
ORDER BY 2, 1
;

-------------------------- ���� ���� --------------------------
-- 20�� ���� ���� ����Ʈ���� ��ǰ Ȯ�� 
-- ���� : 20�� ���� ���� ���� ���� ������ TOP 10�� ���� Ȯ�� 
-- ��� �÷� : RNK, country, stockcode, description, qty
-- HINT : �ζ��� �� ��������, �ζ��� �� �������� �ۼ� ��, LEFT JOIN �ʿ�
-- Ȱ���Լ� : ROW_NUMBER() OVER(PARTITION BY...), SUM(), YEAR()
SELECT * 
FROM (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY qty DESC) AS rnk
        , stockcode
        , description
        , qty
    FROM (
        SELECT 
            stockcode
            , CONVERT(VARCHAR(255), description) AS description 
            , SUM(quantity) AS qty
        FROM sales s 
        LEFT 
        JOIN customer c 
          ON s.customerid = c.mem_no
        WHERE c.gd = 'F'
            AND 2025-YEAR(c.birth_dt) BETWEEN '20' AND '29'
        GROUP BY stockcode, CONVERT(VARCHAR(255), description) 
    ) a
) aa
WHERE rnk <= 10
;

select 2025-year('1995-04-01');


/***********************************************************
�� �� ��ǰ ���� ���� (p.238)
************************************************************/

-- Ư�� ��ǰ�� �Բ� ���� ���� ������ ��ǰ Ȯ�� 
-- ���� : Ư�� ��ǰ(stockcode='20725')�� �Բ� ���� ���� ������ TOP 10�� ���� Ȯ��
-- ��� �÷� : stockcode, description, qty 
-- HINT : INNER JOIN
-- Ȱ���Լ� : SUM()

-- self join
-- �츮�� �ƴ� join�� ���´� �ΰ��� ���� �ٸ� ���̺�
-- �������� Ȯ���ϰ� ���� �� �ַ� ���
-- �������̺� (�μ���, ���) ���� ���踦 �ľ��� �� �ַ� Ȱ��

-- �� �ڵ忡��, ��ǰ�� LUNCH�� ���Ե� ��ǰ�� ���� 
SELECT TOP 10
	s.stockcode
	, CONVERT(VARCHAR(255), s.description)
	, SUM(quantity) as qty 
FROM sales s 
INNER 
JOIN (
	SELECT DISTINCT invoiceno 
	FROM sales 
	WHERE stockcode = '20725'
) i
ON s.invoiceno = i.invoiceno
WHERE s.stockcode <> '20725'
	AND CONVERT(VARCHAR(255), s.description) NOT LIKE '%LUNCH%'
GROUP BY s.stockcode, CONVERT(VARCHAR(255), s.description)
ORDER BY qty DESC 

/***********************************************************
�� �� ��ǰ ���� ���� (p.244)
************************************************************/

-- �籸�� ���� ���� Ȯ��
-- ��� 1 : ������ ������ �� ���� ���
-- ���� : ���θ��� �籸�� ���� Ȯ�� 
-- ��� �÷� : repurchaser_count
-- HINT : �ζ��� ��
-- Ȱ�� �Լ� : COUNT()
select
	customerid
	, count(distinct invoicedate) as freq
from sales
where customerid <> '' -- ��ȸ���� �ش��ϴ� ���� �����ϴ� ����
group by customerid
having count(distinct invoicedate) >= 2
;

-- �� ����
select count(distinct customerid) as �籸�Ű���
	from (
	select
		customerid
		, count(distinct invoicedate) as freq
		from sales
	where customerid <> '' -- ��ȸ���� �ش��ϴ� ���� �����ϴ� ����
	group by customerid
	having count(distinct invoicedate) >= 2
) a
;


-- ��� 2 : ������ ������ �ϼ��� ������ �ű�� ���
-- ���� : ���θ��� �籸�� ���� Ȯ�� 
-- ��� �÷� : repurchaser_count
-- HINT : �ζ��� ��
-- Ȱ�� �Լ� : COUNT(), DENSE_RANK() OVER(PARTITION BY...)


-- ���ټ� �� ��ȣƮ �м�
-- 2010�� ���� �̷��� �ִ� 2011�� ������ Ȯ�� 
SELECT COUNT(DISTINCT customerid) AS rentention_cnt
FROM sales
WHERE customerid <> ''
	AND customerid IN (
	SELECT DISTINCT customerid FROM sales 
	WHERE customerid <> ''
		AND YEAR(invoicedate) = '2010'
)
	AND YEAR(invoicedate) = '2011'
;


SELECT DISTINCT customerid
FROM sales 
WHERE customerid <> ''
	AND YEAR(invoicedate) = '2010'
;
select 820 * 1.00 / 948 * 1.00;

SELECT 
	customerid 
	, invoicedate 
	, DENSE_RANK() OVER(PARTITION BY customerid ORDER BY invoicedate) AS day_no 
FROM (
	SELECT customerid, invoicedate 
	FROM sales 
	WHERE customerid <> ''
	GROUP BY customerid, invoicedate
) a
;

-- ù ���ſ� �籸�� �Ⱓ�� ���� ���
-- DATEDIFF()

-- ����
-- �ַ� �ٷ� �� : �м��� ���� ��ȸ
-- ���� ������ ����, ���� �ͼ����� ����

-- ������ ���� ����
-- ��������, ������ �Լ�
-- ���̺� ����, �Է�, ������Ʈ, ���� (CRUD, CREATE, READ, UPDATE, DELETE)
-- ERD�� ��������
-- Ʈ���� ���� ���� (streamlit)

