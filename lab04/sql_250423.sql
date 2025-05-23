-- ����
-- WHERE ��
-- ���ǰ� ��ġ�ϴ� ������ ��ȸ (���͸�)
-- pandas, iloc, loc �񱳿����� �� ���� ���
-- 94p
use lily_book;

-- ������ ����. "" ū ����ǥ �ȵ�. '' ���� ����ǥ�� ����
select * from dbo.customer where customer_id = 'c002';

-- where�� �ȿ��� �񱳿����ڸ� ���ؼ� ���͸�
-- <>, != : �¿���� ���� ���� ����
select * from sales;

-- sales_amount�� ���� ����ΰ͸� ��ȸ
select * from sales where sales_amount > 0;

-- ���ڸ� �Է��� �� �ٻ��ϰ� �Է��غ���
select * from sales where sales_amount = 41000;

-- �����Ͱ� �ƿ� ���� ���� NULL ���·� ���
-- ��ȸ�� �� ��, ��Ȯ�ϰ� �Է����� �ʾƵ� NULL ���·� ���

select * from dbo.customer where customer_id = 'z002';

-- p100, BETWEEN ������, ���� ����
-- 30000�� 40000 ������ ������ �����ϴ� �� ���
select * from sales where sales_amount between 30000 and 40000;

select * from customer where customer_id between 'c001' and 'c003';

-- between�� ����� �� �ѱ۷ε� ��ȸ�� ���� ����
select * from customer where last_name between '��' and '��';

-- IN ������, �ſ�ſ�ſ� ���� ����
-- OR ������ �ݺ��ؼ� ���� �Ⱦ In �����
select * from sales where product_name in ('�Ź�', 'å');
-- OR �����ڷ� Ǯ� ����� ���
SELECT * FROM sales WHERE product_name = '�Ź�' OR product_name = 'å';

-- 103p
-- Like ������
use BikeStores;
-- lastname�� letter z�� �����ϴ� ��� ���� ���͸�
select * from sales.customers where last_name like 'z%';

select * from sales.customers where last_name like '%z';

select * from sales.customers where last_name like '%z%';

-- IS NULL ������ (�߿���)
-- �����Ͱ� NULL ���� �ุ ���͸�
-- ���������� ��ȸ
select * from sales.customers where phone IS NULL;

-- ��ȸ �ȵ�
select * from sales.customers where phone = NULL;
select * from sales.customers where phone = 'NULL';

-- p109
-- AND ������ / OR ������
CREATE TABLE distribution_center
(
  center_no                VARCHAR(5),
  status                VARCHAR(10),
  permission_date        DATE,
  facility_equipment    VARCHAR(50),
  address                VARCHAR(100)
)

INSERT INTO distribution_center VALUES('1','������','2022-07-04','ȭ���ڵ���','��⵵ ��õ�� ����� ����� 123')
INSERT INTO distribution_center VALUES('2','������','2021-06-10','������,ȭ���ڵ���','��⵵ ���ν� ���ﱸ �𵿷� 987-2')
INSERT INTO distribution_center VALUES('3','������','2022-05-26','�׿��׽���,������','����� �߱� ���Ϸ� 555')
INSERT INTO distribution_center VALUES('4','��������','2022-07-07',NULL,'��⵵ ���ֽ� ��Ÿ� ��ŷ� 6-1')
INSERT INTO distribution_center VALUES('5','��������','2021-02-02',NULL,'��⵵ ���ν� ������ �հ�� 29')

select * from distribution_center;

-- AND ������
select * from distribution_center
where permission_date > '2022-05-01' and permission_date < '2022-07-31' and status = '������';

-- p113
-- OR ������
-- LIKE �����ڿ� ���� ������ ����
-- ������ �켱���� : () > AND > OR
select * from distribution_center
where address like '��⵵ ���ν�%' or address like '�����%';

-- ����������
-- IN, NOT IN ���� ����
-- IS NULL , IS NOT NULL ���� ����
select * from distribution_center where center_no in (1, 2);
select * from distribution_center where center_no not in (1, 2);

DROP TABLE sales

CREATE TABLE sales
(
  ��¥        VARCHAR(10),
  ��ǰ��    VARCHAR(10),
  ����        INT,
  �ݾ�        INT
)

INSERT INTO sales VALUES('01��01��','���콺',1,1000)
INSERT INTO sales VALUES('01��01��','���콺',2,2000)
INSERT INTO sales VALUES('01��01��','Ű����',1,10000)
INSERT INTO sales VALUES('03��01��','Ű����',1,10000)

select * from sales;

-- 127p
-- �Ϻ��� �Ǹŵ� ������ �ݾ�
select sum(����) as ���� from sales;

-- ���� ����
select ��¥, sum(����) as ���� from sales group by ��¥;

select ��ǰ��, sum(����) as ���� from sales group by ��ǰ��;

select ��¥, ��ǰ��, sum(����) as ���� from sales group by ��¥, ��ǰ��;

-- 131p (�ſ� �߿�)
-- ������ �ڵ�, �̹� �ߺ����� ������ ����
-- ���� �� �����
select month(order_date), sum(�����)
from ���̺�
group by month(order_date);
