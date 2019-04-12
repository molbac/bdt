create sequence CART_seq; --��ٱ��� cart ���̺��� ������ ����

create table CART ( --��ٱ���
 ct_cd int not null --��ٱ��� �ڵ�
,md_cd varchar(20) not null --���ڵ�
,ms_cd varchar(30) not null --�������ڵ�
,mo_cd varchar(30) not null --�ɼ��ڵ�
,ct_count int default 0 --����
,primary key(ct_cd)
,foreign key(md_cd) references menu_detail(md_cd)
,foreign key(ms_cd) references menu_size(ms_cd)
,foreign key(mo_cd) references menu_option(mo_cd)
);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_01', '', 'ch0001n2_03.sw', 1);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_06', 'ch0001n2_06.rt', '', 1);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_07', 'ch0001n2_07.m', '', 2);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'jp0001n5_02', '', 'jp0001n5_02.so', 2);

���ڵ�fk			�������ڵ�fk		�ɼ��ڵ�fk			   ����	  ��ٱ����ڵ�pk
ch0001n2_01		null			ch0001n2_03.sw		1		1
ch0001n2_06		ch0001n2_06.rt	null				1		2
ch0001n2_07		ch0001n2_07.m	null				2		3
jp0001n5_02		null			jp0001n5_02.so		2		4


create table payment ( --��������
 py_info char(1) not null --�����ڵ�
,py_select varchar(36) not null --�����������
,primary key(py_info)
);

insert into payment(py_info, py_select)
values('1', '�޴��� ����');

insert into payment(py_info, py_select)
values('2', '�ſ�ī�� ����');

insert into payment(py_info, py_select)
values('3', '�������');

insert into payment(py_info, py_select)
values('4', '����ī�� ����');

insert into payment(py_info, py_select)
values('5', '��ǰ�� ����');

insert into payment(py_info, py_select)
values('6', '���� ����(��)');

insert into payment(py_info, py_select)
values('7', '�ſ�ī�� ����(��)');

�����������		��������
�޴��� ����		1
�ſ�ī�� ����		2
�������			3
����ī�� ����		4
��ǰ�� ����		5
���� ����(��)		6
�ſ�ī�� ����(��)	7


create table coupon ( --����
 cp_cd varchar(20) not null --�����ڵ� <��ü�ڵ�+s(��������)/m(��������)+cp+�����ڵ�2�ڸ�(max()�Լ��� Ȱ���Ͽ� ������ �ο�)>
,cp_name varchar(50) not null --��������
,cp_min int not null --�ּ� �ֹ��ݾ�
,cp_regdt date default sysdate --�����
,cp_end date --������
,cp_disc int not null --���αݾ�
,rs_cd varchar(15) not null --��ü�ڵ�
,primary key(cp_cd)
,foreign key(rs_cd) references rs_name(rs_cd)
);

insert into coupon(cp_cd, cp_name, cp_min, cp_regdt, cp_end, cp_disc, rs_cd)
values('mcp01jp0001', '����/���� ��ȯ��', 15000, sysdate, '', 0, 'jp0001');

insert into coupon(cp_cd, cp_name, cp_min, cp_regdt, cp_end, cp_disc, rs_cd)
values('scp01ch0001', '2õ�� ���α�', 12000, sysdate, '', 2000, 'ch0001');

��ü�ڵ�fk	 ��������		  �ּ��ֹ��ݾ�	    ������			������	 �����ڵ�pk		���αݾ�
jp0001	����/���� ��ȯ��	15000	  2018-10-24	2018-12-24	mcp01jp0001		0
ch0001	2õ�� ���α�	    12000	  2018-10-20	2018-10-21	scp01ch0001		2000


create table rs_category ( --��������
 cate_cd varchar(8) not null --�����ڵ�
,cate varchar(30) not null --����
,primary key(cate_cd)
);

create table rs_name ( --�Ǹž�ü����
 rs_cd varchar(15) not null --��ü�ڵ� �����ڵ�+4�ڸ� �Ϸù�ȣ
,sl_nick char(100) not null --��ü��
,cate_cd varchar(8) not null --�����ڵ�
,sl_ID varchar(13) not null --�Ǹ��ھ��̵�
,sl_cell char (11) not null --��ȭ��ȣ
,rs_point int default 0 --����Ʈ����
,rs_okcb int default 0 --okĳ����
,rs_st int not null --�������۽ð� 4�ڸ��ڵ�(HHMM)
,rs_end int not null --��������ð� 4�ڸ��ڵ�(HHMM)
,rs_local varchar(80) not null --��ް������� �����ȣ 5�ڸ�. ','�� ����.
,rs_money int default 0 --��ް��ɱݾ�
,rs_from varchar(1000) --����������
,primary key(rs_cd)
,foreign key(cate_cd) references rs_category(cate_cd)
,foreign key(sl_ID) references signup_my(sl_ID)
);

create sequence rs_rate_seq; --��ü�� rs_rate�� ������

create table rs_rate ( --��ü��
 rs_seq int not null --�Ϸù�ȣ ������(sq_rate) ����
,rs_cd varchar(15) not null --��ü�ڵ�
,by_ID varchar(13) not null --�����ھ��̵�
,rs_rate int not null --����
,rs_review varchar(1000) --�ı�
,rs_photo char(1000) --�ı���� ���ϸ� �Է�
,rs_regdt date default sysdate --�ۼ���
,primary key(rs_seq)
,foreign key(rs_cd) references rs_name(rs_cd)
,foreign key(by_ID) references signup(by_ID)
);

insert into rs_rate(rs_seq, rs_cd, by_ID, rs_rate, rs_review, rs_photo, rs_regdt)
values(rs_rate_seq.nextval, 'ch0001', 'soldesk', 4, '���ƿ�', 'photo.jpg', sysdate);

��ü�ڵ�fk 	����	  �ı�  	    �ۼ���	   �����̵�fk
ch0001	    4	 good job	43451		soldesk







