-- Having �׷�ȭ ����� ���� ���ĸ� �������� ���͸�
-- where ���� �����͸� �������� ���͸�
select * from sales_ch5
select customer_id, SUM(sales_amount) as ���� from sales_ch5
-- sales_amount�� ��ü�� ����� having���� ������ ����� ��� ����
-- ���� ������ sales_amount�� ������ ����ص� ����
group by customer_id having  SUM(sales_amount)> 20000

-- ORDER BY
select customer_id, SUM(sales_amount) as ���� from sales_ch5
group by customer_id order by ���� desc -- desc�� ��������, ����Ʈ�� ��������, asc ��������

-- db�� �����͸� ó���ϴ� ����
-- from => where => group by - having => select => order by

-- 161p
-- ��ǰ ������ �ִ� product_info ���̺�
-- ��ǰ ī�װ��� �ִ� catefory_info ���̺�
-- �̺�Ʈ ��ǰ�� ���� ���� event_info ���̺�

-- ���� �ٸ� ���̺� ==> ���̺� ���� (�Ϲ����� ���)
-- �������� vs ���̺� ���� (�����Ͼ�, �ΰ� ���� ��)
-- �����ȹ ���ؼ�, �� ������ ������ ���� �� �־�� ��(�����Ͼ� �����)

select product_id, product_name, category_id, 
	(select category_name from category_info c where c.category_id = p.category_id)
from product_info p; -- �Ϲ������� ���̺� ���� ���̺��� �̸��� ALIAS ó��

-- FROM�� ��������
-- data1 = data.����
-- data2 = data1.����
-- select from (select from (select from))
-- product_info ���̺�, ī�װ����� ��ǰ�� ������ 5�� �̻��� ī�װ��� ���
select category_id, count(product_id) as count_of_product
from product_info
group by category_id
having count(product_id) >= 5;

-- ���� ���� ��� ������
select * from (select category_id, count(product_id) as count_of_product
from product_info
group by category_id) p where count_of_product >= 5;


-- where�� ��������
-- �������� ���ϰ� ���� : ���� �� ��ġ����
-- product_info T, ������ǰ ī�װ��� ����ϰ����
-- ��������, �������� �����ؼ� ó��
-- �������� : ������ǰ ī�װ��� ��ȸ
-- �������� : product_info ���̺� ��ȸ

select * from product_info;
-- ������ǰ ī�װ� id => c01
select category_id from category_info where category_name = '������ǰ';

select * from product_info where category_id = (
	select category_id from category_info where category_name = '�׼�����');

-- 168p
-- product_info T, event_id �÷��� e2�� ���Ե� ��ǰ�� ������ ���
-- �������� : product_info T ��ǰ�� ���� ���
-- �������� : event_id �÷��� e2�� �ش��ϴ� ��ǰ
select * from product_info where product_id in ('p003', 'p004', 'p005');

select product_id from event_info where event_id = 'e2';

-- ���̺��� ����
-- LEFT JOIN, RIGHT JOIN, OUTER JOIN (FULL JOIN), INNER JOIN
-- LEFT OUTER JOIN, RIGHT OUTER JOIN
-- 185p
select * from product_info pi 
left join category_info ci on pi.category_id = ci.category_id;

-- UNION ������ : ���̺� �Ʒ��� ���̱�
-- UNION(�ߺ��� ����) vs UNION ALL (�ߺ��� ���� ����)

-- �������� �߰� ����
use BikeStores;

-- ���̺�
select * from sales.orders;

-- ���� : 2017�⿡ ���� ���� �ֹ��� ó���� ������ ó���� ��� �ֹ� ��ȸ
-- 1. ��� �ֹ� ���� ǥ��
-- 2. where �������� ����ؼ� 2017�� �ִ� �ֹ� ó�� ���� ã��
-- 3. Top 1�� groupby ���
-- 4. Ȱ���Լ� : year, count(*)

-- �������� : ��� �ֹ� ���� ǥ��
select * from sales.orders where staff_id = 6;

-- �������� : 2017�⿡ ���� ���� �ֹ��� ó���� ���� ã��
-- staff_id ����ϰ� ������ ���� ã��
select staff_id, count(*) AS �ֹ��Ǽ�
from sales.orders
where year(order_date) = 2017
group by staff_id;

-- 
select top 1 staff_id
from sales.orders
where year(order_date) = 2017
group by staff_id
order by count(*) desc;

-- ��ġ��
-- 2017�⿡ ���� ���� �ֹ��� ó���� ������ ó���� ��� �ֹ� ��ȸ
select * from sales.orders
where staff_id = (
	select top 1 staff_id
	from sales.orders
	where year(order_date) = 2017
	group by staff_id
	order by count(*) desc
);

-- ���̺� 2��
select * from production.products;
select * from sales.order_items;

-- ���� : �ѹ��� �ֹ����� ���� ��ǰ���� ������ ��ȸ
-- �ߺ��� �����ϴ� ��� : select distinct

-- �������� : products ���̺� ��� �����͸� ��ȸ
select * from production.products;

-- �������� : �ѹ��� �ֹ����� ���� ��ǰ ����
select * from sales.order_items;

select distinct product_id from sales.order_items;

select * from production.products
where product_id not in (
	select distinct product_id from sales.order_items
);

