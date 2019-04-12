--------------------------�ڡ�Create Tables�ڡ�---------------------
--------------------------------------------------ȸ��sheet
CREATE TABLE SIGNUP( --ȸ������_������
	by_ID	    varchar2(13)                  NOT NULL --�����̵�	
	,by_nick	varchar2(24)  UNIQUE       	  NOT NULL --�г���
	,by_PW	    varchar2(24)	              NOT NULL --��й�ȣ
	,by_cell	char(11)	                  NOT NULL --�޴��� ��ȣ
	,by_regdt	date	      DEFAULT sysdate NOT NULL --�����
	,PRIMARY KEY(by_ID)
);

CREATE TABLE SIGNUP_MY( --ȸ������_�Ǹ���			
	sl_ID	    varchar2(13)   NOT NULL --�Ǿ��̵�
	,sl_PW  	varchar2(24)   NOT NULL --��й�ȣ
	,sl_nick	varchar2(1000) NOT NULL --�̸�
	,sl_email	varchar2(40)   NOT NULL --�̸���
	,sl_cell	char(11)   	   NOT NULL --��ȭ��ȣ
	,sl_cerNO	char(10)	   NOT NULL --����ڵ�Ϲ�ȣ
	,sl_name	char(21)	   NOT NULL --��ǥ�ڸ�
	,sl_regdt	date	       DEFAULT sysdate --�����
	,PRIMARY KEY(sl_ID)
);

--------------------------------------------------sheet end
--------------------------------------------------��ü����sheet
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
--------------------------------------------------sheet end

--------------------------------------------------�޴�sheet
CREATE TABLE menu (
	mn_cd varchar2(10) NOT NULL
	, mn_name varchar2(50) not null
	, rs_cd varchar2(15) not null
	, primary key(mn_cd)
	, foreign key(rs_cd) references rs_name(rs_cd)
);


CREATE TABLE menu_detail (
	md_cd varchar2(20) NOT NULL
	, md_name varchar2(50) NOT NULL
	, mn_photo varchar2(40)
	, md_price int
	, mn_cd varchar2(100) NOT NULL
	, primary key(md_cd)
	, foreign key(mn_cd) references menu(mn_cd)
);


CREATE TABLE menu_size (
	ms_cd varchar2(30) NOT NULL
	, ms_name varchar2(50) NOT NULL
	, ms_price int
	, md_cd varchar2(20) NOT NULL
	, primary key(ms_cd)
	, foreign key(md_cd) references menu_detail(md_cd)
);


CREATE TABLE menu_option (
	mo_cd varchar2(30) NOT NULL
	, mo_name varchar2(50) NOT NULL
	, mo_price int
	, md_cd varchar2(20) NOT NULL
	, primary key(mo_cd)
	, foreign key(md_cd) references menu_detail(md_cd)
);

--------------------------------------------------sheet end

--------------------------------------------------��ٱ���sheet
create sequence CART_seq; --��ٱ��� cart ���̺��� ������ ����

create table CART ( --��ٱ���
 ct_cd int not null --��ٱ��� �ڵ�
,md_cd varchar(20) not null --���ڵ�
,ms_cd varchar(30) --�������ڵ�
,mo_cd varchar(30) --�ɼ��ڵ�
,ct_count int default 0 --����
,primary key(ct_cd)
,foreign key(md_cd) references menu_detail(md_cd)
,foreign key(ms_cd) references menu_size(ms_cd)
,foreign key(mo_cd) references menu_option(mo_cd)
);


create table payment ( --��������
 py_info char(1) not null --�����ڵ�
,py_select varchar(36) not null --�����������
,primary key(py_info)
);


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

CREATE SEQUENCE coupon_seq;

CREATE TABLE COUPON_HAVE( --��������
	cph_seq	 int	      NOT NULL--�Ϸù�ȣ
	,by_ID   varchar2(13) NOT NULL --�����̵�
	,cp_cd   varchar2(20) NOT NULL --�����ڵ�
	,PRIMARY KEY(cph_seq)
	,FOREIGN KEY(by_ID) REFERENCES SIGNUP(by_ID)
	,FOREIGN KEY(cp_cd) REFERENCES COUPON(cp_cd)
);
--------------------------------------------------sheet end
--------------------------------------------------����sheet
CREATE table ORDER_DETAIL( --�ֹ��󼼳�����
    or_num   varchar2(30)  NOT NULL --�ֹ�����ȣ
    ,by_ID    varchar2(13)  NOT NULL   --�����̵�
    ,ct_cd    int           NOT NULL   --��ٱ����ڵ�
    ,md_cd    varchar2(20)  NOT NULL   --���ڵ�
    ,ms_cd    varchar2(30)             --�������ڵ�
    ,mo_cd    varchar2(30)             --�ɼ��ڵ�
    ,ct_count int default 0            --����
    ,cp_cd    varchar2(20)  NOT NULL   --�����ڵ�
    ,py_info  char(1)       NOT NULL   --�����ڵ�
    ,primary key(or_num)
    ,foreign key(by_ID)    references SIGNUP(by_ID)
    ,foreign key(ct_cd)    references CART(ct_cd)
    ,foreign key(md_cd)    references MENU_DETAIL(md_cd)
    ,foreign key(ms_cd)    references MENU_SIZE(ms_cd)
    ,foreign key(mo_cd)    references MENU_OPTION(mo_cd)
    ,foreign key(py_info)  references PAYMENT(py_info)
    );
    
create sequence ORDER_sh_seq;  --���������� �Ϸù�ȣ
   
CREATE table ORDER_sh( --�ֹ���
    or_seq    int           NOT NULL            --�Ϸù�ȣ
    ,by_ID     varchar2(13)  NOT NULL           --�����̵� 
    ,or_num    varchar2(30)  NOT NULL           --�ֹ�����ȣ   
    ,cp_cd     varchar2(20)                     --�����ڵ�
    ,cpu_disc  int           NOT NULL           --���αݾ�
    ,or_pay    int           NOT NULL           --�����ݾ�
    ,or_tot    int           NOT NULL           --���������ݾ�
    ,py_info   char(1)       NOT NULL           --�����ڵ� 
    ,primary key(or_seq)
    ,foreign key(by_ID)     references SIGNUP(by_ID)
    ,foreign key(cp_cd)     references COUPON(cp_cd)    
   );
       

 CREATE table ORDER_DETAILG(                 --��ȸ���ֹ��󼼳�����
     or_num   varchar2(30)        NOT NULL   --�ֹ�����ȣ
    ,or_cell  varchar2(13) unique NOT NULL   --��ȸ���޴�����ȣ
    ,ct_cd    int                 NOT NULL   --��ٱ����ڵ�
    ,md_cd    varchar2(20)        NOT NULL   --���ڵ�
    ,ms_cd    varchar2(30)                   --�������ڵ�
    ,mo_cd    varchar2(30)                   --�ɼ��ڵ�
    ,ct_count int default 0                  --����
    ,cp_cd    varchar2(20)                   --�����ڵ�
    ,py_info  char(1)             NOT NULL   --�����ڵ�
    ,primary key(or_num)
    ,foreign key(ct_cd)    references CART(ct_cd)
    ,foreign key(md_cd)    references MENU_DETAIL(md_cd)
    ,foreign key(ms_cd)    references MENU_SIZE(ms_cd)
    ,foreign key(mo_cd)    references MENU_OPTION(mo_cd)
    ,foreign key(cp_cd)    references COUPON(cp_cd)
    ,foreign key(py_info)  references PAYMENT(py_info)
    );
    
  
create sequence ORDER_shg_seq;  --���������� �Ϸù�ȣ

CREATE table ORDER_shg(                               --��ȸ���ֹ���
     or_seq    int                                    --�Ϸù�ȣ
    ,or_cell   varchar2(13) unique NOT NULL           --��ȸ���޴�����ȣ
    ,or_num    varchar2(30)        NOT NULL           --�ֹ�����ȣ   
    ,cp_cd     varchar2(20)                           --�����ڵ�
    ,cpu_disc  int                 NOT NULL           --���αݾ�
    ,or_pay    int                 NOT NULL           --�����ݾ�
    ,or_tot    int                 NOT NULL           --���������ݾ�
    ,py_info   char(1)             NOT NULL           --�����ڵ� 
    ,primary key(or_seq)
    ,foreign key(or_cell)   references ORDER_DETAILG(or_cell)
    ,foreign key(cp_cd)     references COUPON(cp_cd)    
   );
 
--------------------------------------------------sheet end


--------------------------------------------------���sheet
CREATE TABLE DEL_MEM( --�������_ȸ��			
	del_cd	    varchar2(50)	NOT NULL --����ڵ�
	,or_num	    varchar2(30)	NOT NULL --�ֹ�����ȣ
	,by_ID	    varchar2(13)	NOT NULL --�����̵�
	,del_addr	varchar2(500)	NOT NULL --����ּ�
	,del_plz	varchar2(36)	NULL     --��޿�û����
	,by_nick	varchar2(24)	NOT NULL --�޴»��
	,PRIMARY KEY(del_cd)
	,FOREIGN KEY(or_num) REFERENCES ORDER_DETAIL(or_num)
	,FOREIGN KEY(by_ID) REFERENCES SIGNUP(by_ID)
	,FOREIGN KEY(by_nick) REFERENCES SIGNUP(by_nick)
);



CREATE TABLE DEL_GST( --�������_��ȸ��			
	del_cd	    varchar2(50)	NOT NULL --����ڵ�
	,or_num	    varchar2(30)	NOT NULL --�ֹ�����ȣ
	,del_addr	varchar2(500)	NOT NULL --����ּ�
	,del_plz	varchar2(36)	NULL     --��޿�û����
	,del_rec	varchar2(20)	NOT NULL --�޴»��
	,del_cell	char(12)	    NOT NULL --�޴�����ȣ
	,del_pw	    varchar2(6)	    NOT NULL --��й�ȣ
	,PRIMARY KEY(del_cd)
	,FOREIGN KEY(or_num) REFERENCES ORDER_DETAILG(or_num)
);

--------------------------------------------------sheet end


----------------------�ڡ�Inserts�ڡ�--------------------------------
--------------------------------------------------ȸ��sheet
INSERT INTO SIGNUP (by_ID, by_nick, by_PW, by_cell)
VALUES ('soldesk',	'sold',	'soldesk', '01012341234');

INSERT INTO SIGNUP (by_ID, by_nick, by_PW, by_cell)
VALUES ('hmgyng2017',	'hm',	'123456',	'01038943984');

INSERT INTO SIGNUP (by_ID, by_nick, by_PW, by_cell)
VALUES ('ejks34',	'ejks',	'2kj9',	'01034257256');


 
INSERT INTO SIGNUP_MY( sl_nick, sl_ID, sl_email, sl_PW, sl_cell, sl_cerNO, sl_name)
VALUES ('�ľƹٺ�ť','whobbq','whobbq@gmail.com',	'soldesk',	'1234125',	'1234512315',	'�Ӽҿ�');

INSERT INTO SIGNUP_MY( sl_nick, sl_ID, sl_email, sl_PW, sl_cell, sl_cerNO, sl_name)
VALUES ('���̶���',	'laelae',	'laelae@naver.com',	'ale385',	'3854536',	'3456273456',	'��μ�');

INSERT INTO SIGNUP_MY( sl_nick, sl_ID, sl_email, sl_PW, sl_cell, sl_cerNO, sl_name)
VALUES ('���ھ���',	'pizzakd',	'pizzakd@daum.net',	'piz234',	'2346452',	'7357356375'	,'���ؿ�');

INSERT INTO SIGNUP_MY( sl_nick, sl_ID, sl_email, sl_PW, sl_cell, sl_cerNO, sl_name)
VALUES ('���þ߹���ȣ��ġ����',	'sushimiz',	'sushimiz@gmail.com',	'sushi99',	'3453869',	'2342695785',	'�̰�ȭ');

--------------------------------------------------sheet end

--------------------------------------------------��ü����sheet
INSERT INTO rs_category (cate, cate_cd)
values ('ġŲ', 'ch');

INSERT INTO rs_category (cate, cate_cd)
values ('�߱���', 'jja');

INSERT INTO rs_category (cate, cate_cd)
values ('����', 'piz');

INSERT INTO rs_category (cate, cate_cd)
values ('����/����', 'jb');

INSERT INTO rs_category (cate, cate_cd)
values ('�߽�', 'ya');

INSERT INTO rs_category (cate, cate_cd)
values ('��/��', 'jjt');

INSERT INTO rs_category (cate, cate_cd)
values ('�ѽ�/�н�/��', 'kor');

INSERT INTO rs_category (cate, cate_cd)
values ('���/ȸ/�Ͻ�', 'jp');

INSERT INTO rs_category (cate, cate_cd)
values ('���ö�/�н�ƮǪ��', 'fast');

INSERT INTO rs_category (cate, cate_cd)
values ('�ɹ��', 'flw');

INSERT INTO rs_category (cate, cate_cd)
values ('��޴���', 'dlv');

INSERT INTO rs_category (cate, cate_cd)
values ('��Ȱ����', 'cvn');


INSERT INTO rs_name (cate_cd, sl_nick, rs_cd, sl_ID, sl_cell, rs_point, rs_okcb, rs_st, rs_end, rs_local, rs_money, rs_from)
values ('ch', '�ľƹٺ�ť', 'ch0001', 'whobbq', '1234125', 500, 200, 0000, 2400, '10371, 12151', 10000, '������');

INSERT INTO rs_name (cate_cd, sl_nick, rs_cd, sl_ID, sl_cell, rs_point, rs_okcb, rs_st, rs_end, rs_local, rs_money, rs_from)
values ('jja', '���̶���', 'jja0001', 'laelae', '3854536', 500, 200, 1030, 2130, '10629, 10630', 8000, '������');

INSERT INTO rs_name (cate_cd, sl_nick, rs_cd, sl_ID, sl_cell, rs_point, rs_okcb, rs_st, rs_end, rs_local, rs_money, rs_from)
values ('piz', '���ھ���', 'piz0001', 'pizzakd', '2346452', 500, 200, 1100, 0400, '10955, 10956', 13900, '������');

INSERT INTO rs_name (cate_cd, sl_nick, rs_cd, sl_ID, sl_cell, rs_point, rs_okcb, rs_st, rs_end, rs_local, rs_money, rs_from)
values ('jp', '���þ߹���ȣ��ġ����', 'jp0001', 'sushimiz', '3453869', 500, 200, 1000, 2200, '13212, 19283, 10930', 10000, '�븣���̻�');


insert into rs_rate(rs_seq, rs_cd, by_ID, rs_rate, rs_review, rs_photo, rs_regdt)
values(rs_rate_seq.nextval, 'ch0001', 'soldesk', 4, '���ƿ�', 'photo.jpg', sysdate);

--------------------------------------------------sheet end

--------------------------------------------------�޴�sheet
insert into menu(rs_cd, mn_name, mn_cd)
values('ch0001', '�ٺ�ť �ø���', 'ch0001n1');

insert into menu(rs_cd, mn_name, mn_cd)
values('ch0001', '�Ķ��̵� �ø���', 'ch0001n2');

insert into menu(rs_cd, mn_name, mn_cd)
values('ch0001', '���̵�޴�', 'ch0001n3');

insert into menu(rs_cd, mn_name, mn_cd)
values('ch0001', '������', 'ch0001n4');

insert into menu(rs_cd, mn_name, mn_cd)
values('ch0001', '�߰��޴�', 'ch0001n5');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '�ΰ��� ��', 'jja0001n1');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '��õ��Ʈ�丮', 'jja0001n2');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '����ȼ�Ʈ', 'jja0001n3');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '�α�޴���', 'jja0001n4');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '�����޴�', 'jja0001n5');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '�ѽĺ���', 'jja0001n6');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '���', 'jja0001n7');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '���', 'jja0001n8');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '�丮��', 'jja0001n9');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '��Ƽ����', 'jp0001n1');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '�ʱ��̽���', 'jp0001n2');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '���긮����', 'jp0001n3');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '��������ý���', 'jp0001n4');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', 'ġŲ����ưԽ���', 'jp0001n5');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '��ǰ����', 'jp0001n6');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '���', 'jp0001n7');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', 'ź������', 'jp0001n8');


insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '�������', 18000, 'ch0001n2_01.jpg', 'ch0001n2_01');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '����Ķ��̵�', 16000, 'ch0001n2_02.jpg', 'ch0001n2_02');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '����Ķ��̵�', 17000, 'ch0001n2_03.jpg', 'ch0001n2_03');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '��������Ķ��̵�', 18000, 'ch0001n2_04.jpg', 'ch0001n2_04');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '�������Ķ��̵�', 19000, 'ch0001n2_05.jpg', 'ch0001n2_05');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '�ػ罺 ��n��', 17000, 'ch0001n2_06.jpg', 'ch0001n2_06');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '�Ƚ�������', 17000, 'ch0001n2_07.jpg', 'ch0001n2_07');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jja0001n1', '������', 9000, 'jja0001n1_01.jpg', 'jja0001n1_01');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jja0001n1', '��¥��', 9000, 'jja0001n1_02.jpg', 'jja0001n1_02');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jja0001n1', '��«��', 9000, 'jja0001n1_03.jpg', 'jja0001n1_03');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jja0001n1', '��¥��', 8000, 'jja0001n1_04.jpg', 'jja0001n1_04');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jja0001n1', '��«��', 8000, 'jja0001n1_05.jpg', 'jja0001n1_05');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jja0001n1', '«¥��', 8000, 'jja0001n1_06.jpg', 'jja0001n1_06');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jp0001n5', 'ġŲ����ưԸ��긮A', 9500, 'jp0001n5_01.jpg', 'jp0001n5_01');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jp0001n5', 'ġŲ����ưԸ��긮B', 10500, 'jp0001n5_022.jpg', 'jp0001n5_02');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jp0001n5', 'ġŲ����ưԸ��긮C', 8500, 'jp0001n5_03.jpg', 'jp0001n5_03');


insert into menu_size(md_cd, ms_name, ms_price, ms_cd)
values('ch0001n2_06', 'Ƣ���', 0, 'ch0001n2_06.fr');

insert into menu_size(md_cd, ms_name, ms_price, ms_cd)
values('ch0001n2_06', '����', 0, 'ch0001n2_06.rt');

insert into menu_size(md_cd, ms_name, ms_price, ms_cd)
values('ch0001n2_07', '��', 0, 'ch0001n2_07.s');

insert into menu_size(md_cd, ms_name, ms_price, ms_cd)
values('ch0001n2_07', '��', 7000, 'ch0001n2_07.m');

insert into menu_size(md_cd, ms_name, ms_price, ms_cd)
values('ch0001n2_07', '��', 16000, 'ch0001n2_07.l');



insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_03', '�����Ѹ�', 0, 'ch0001n2_03.sw');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_03', '�����', 0, 'ch0001n2_03.nr');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_03', '�����Ѹ�', 0, 'ch0001n2_03.ht');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_03', '�ſ��', 0, 'ch0001n2_03.sht');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_03', '���ָſ��', 0, 'ch0001n2_03.sfht');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_05', '�����Ѹ�', 0, 'ch0001n2_05.sw');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_05', '�����', 0, 'ch0001n2_05.nr');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_05', '�����Ѹ�', 0, 'ch0001n2_05.ht');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_05', '�ſ��', 0, 'ch0001n2_05.sht');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_05', '���ָſ��', 0, 'ch0001n2_05.sfht');


insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jja0001n1_01', '������', 2000, 'jja0001n1_01.gop');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jja0001n1_02', '������', 2000, 'jja0001n1_02.gop');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jja0001n1_03', '������', 2000, 'jja0001n1_03.gop');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jja0001n1_04', '������', 1000, 'jja0001n1_04.gop');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jja0001n1_05', '������', 1000, 'jja0001n1_05.gop');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jja0001n1_06', '������', 1000, 'jja0001n1_06.gop');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jp0001n5_01', '�Ұ����ʹ��߰�', 2000, 'jp0001n5_01.so');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jp0001n5_02', '�Ұ����ʹ��߰�', 2000, 'jp0001n5_02.so');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jp0001n5_03', '�Ұ����ʹ��߰�', 2000, 'jp0001n5_03.so');


--------------------------------------------------sheet end

--------------------------------------------------��ٱ���sheet
insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_01', '', 'ch0001n2_03.sw', 1);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'jp0001n5_02', '', 'jp0001n5_02.so', 2);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_03',	'',	'ch0001n2_03.ht',	5);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_03',	'',	'ch0001n2_03.ht',	4);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_03',	'',	'ch0001n2_03.ht',	2);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_05',	'',	'ch0001n2_05.ht',	3);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_05',	'',	'ch0001n2_05.ht',	1);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_05',	'',	'ch0001n2_05.ht',	1);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_05',	'',	'ch0001n2_05.ht',	6);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_05',	'',	'ch0001n2_05.ht',	47);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_03',	'',	'ch0001n2_03.ht',	1);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_03',	'',	'ch0001n2_03.ht',	2);

--��ȸ�� ���ڵ�
insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_06', 'ch0001n2_06.rt', '', 1);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_07', 'ch0001n2_07.m', '', 2);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_03',	'',	'ch0001n2_03.ht',	1);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_05',	'',	'ch0001n2_05.ht',	2);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_05',	'',	'ch0001n2_05.ht',	8);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_05',	'',	'ch0001n2_05.ht',	4);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_05',	'',	'ch0001n2_05.ht',	3);

insert into cart(ct_cd, md_cd, ms_cd, mo_cd, ct_count)
values(cart_seq.nextval, 'ch0001n2_05',	'',	'ch0001n2_05.ht',	10);



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


insert into coupon(cp_cd, cp_name, cp_min, cp_regdt, cp_end, cp_disc, rs_cd)
values('mcp01jp0001', '����/���� ��ȯ��', 15000, sysdate, '', 0, 'jp0001');

insert into coupon(cp_cd, cp_name, cp_min, cp_regdt, cp_end, cp_disc, rs_cd)
values('scp01ch0001', '2õ�� ���α�', 12000, sysdate, '', 2000, 'ch0001');




INSERT INTO COUPON_HAVE (cph_seq, by_ID, cp_cd)
VALUES (coupon_seq.nextval, 'soldesk',	'scp01ch0001');

INSERT INTO COUPON_HAVE (cph_seq, by_ID, cp_cd)
VALUES (coupon_seq.nextval, 'hmgyng2017',	'mcp01jp0001');

INSERT INTO COUPON_HAVE (cph_seq, by_ID, cp_cd)
VALUES (coupon_seq.nextval, 'ejks34',	'mcp01jp0001');

--------------------------------------------------sheet end

--------------------------------------------------����sheet
--�ءءءءءءءءءءءء�<ORDER_DETAIL>,<ORDER_DETAILG> INSERT �� ct_cd Ȯ�Ρءءءءءءءءءءءءءءءءء�
SELECT ct_cd, md_cd, ms_cd, mo_cd, ct_count
FROM CART
ORDER BY ct_cd;

INSERT INTO ORDER_DETAIL(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, by_ID, py_info)
VALUES ( 1,	'ch0001n2_01',	'',	'ch0001n2_03.sw',	1,	'scp01ch0001',	'2018-12-17011110',	'soldesk', '2');

INSERT INTO ORDER_DETAIL(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, by_ID, py_info)
VALUES (2,	'jp0001n5_02',	'',	'jp0001n5_02.so',	1,	'mcp01jp0001',	'2018-12-18011110',	'hmgyng2017', '4');

INSERT INTO ORDER_DETAIL(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, by_ID, py_info)
VALUES (3,	'ch0001n2_03',	'',	'ch0001n2_03.ht',	5,	'scp01ch0001',	'2018-12-19000001',	'soldesk', '5');

INSERT INTO ORDER_DETAIL(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, by_ID, py_info)
VALUES (4,	'ch0001n2_03',	'',	'ch0001n2_03.ht',	4,	'scp01ch0001',	'2018-12-19000002',	'soldesk', '5');

INSERT INTO ORDER_DETAIL(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, by_ID, py_info)
VALUES (5,	'ch0001n2_03',	'',	'ch0001n2_03.ht',	2,	'scp01ch0001',	'2018-12-19000003',	'hmgyng2017', '5');

INSERT INTO ORDER_DETAIL(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, by_ID, py_info)
VALUES (6,	'ch0001n2_05',	'',	'ch0001n2_05.ht',	3,	'scp01ch0001',	'2018-12-19000004',	'hmgyng2017', '5');

INSERT INTO ORDER_DETAIL(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, by_ID, py_info)
VALUES (7,	'ch0001n2_05',	'',	'ch0001n2_05.ht',	1,	'scp01ch0001',	'2018-12-19000005',	'hmgyng2017', '5');

INSERT INTO ORDER_DETAIL(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, by_ID, py_info)
VALUES (8,	'ch0001n2_05',	'',	'ch0001n2_05.ht',	1,	'scp01ch0001',	'2018-12-19000006',	'hmgyng2017', '5');

INSERT INTO ORDER_DETAIL(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, by_ID, py_info)
VALUES (9,	'ch0001n2_05',	'',	'ch0001n2_05.ht',	6,	'scp01ch0001',	'2018-12-19000007',	'hmgyng2017', '5');

INSERT INTO ORDER_DETAIL(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, by_ID, py_info)
VALUES (10,	'ch0001n2_05',	'',	'ch0001n2_05.ht',	47,	'scp01ch0001',	'2018-12-19000008',	'hmgyng2017', '5');

   
INSERT INTO ORDER_sh(or_seq, or_pay, cpu_disc, or_tot, or_num, py_info, cp_cd, by_ID)
VALUES (ORDER_sh_seq.nextval, 16000,	2000,	14000,	'2018-12-17011110',	'2',	'scp01ch0001',	'soldesk');
  
INSERT INTO ORDER_sh(or_seq, or_pay, cpu_disc, or_tot, or_num, py_info, cp_cd, by_ID)
VALUES (ORDER_sh_seq.nextval, 25000, 0,	25000,	'2018-12-18011110',	'4',	'mcp01jp0001',	'hmgyng2017');
  

INSERT INTO ORDER_DETAILG(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, or_cell, py_info)
VALUES (13,	'ch0001n2_06',	'ch0001n2_06.rt',	'',	1,	'',	'2018-12-17011111',	'01054655468', '5');

INSERT INTO ORDER_DETAILG(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, or_cell, py_info)
VALUES (14,	'ch0001n2_07',	'ch0001n2_07.m',	'',	2,	'',	'2018-12-17011112',	'01034257256', '3');

INSERT INTO ORDER_DETAILG(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, or_cell, py_info)
VALUES (11,	'ch0001n2_03',	'',	'ch0001n2_03.ht', 1, '',	'2018-12-19100001',	'01065464866',	'4');

INSERT INTO ORDER_DETAILG(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, or_cell, py_info)
VALUES (12,	'ch0001n2_03',	'',	'ch0001n2_03.ht',	2,	'',	'2018-12-19100002',	'01054624582',	'5');

INSERT INTO ORDER_DETAILG(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, or_cell, py_info)
VALUES (15,	'ch0001n2_03',	'',	'ch0001n2_03.ht',	1,	'',	'2018-12-19100003',	'01055686534',	'5');

INSERT INTO ORDER_DETAILG(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, or_cell, py_info)
VALUES (16, 'ch0001n2_05',	'',	'ch0001n2_05.ht',	2,	'',	'2018-12-19100004',	'01046559456',	'5');

INSERT INTO ORDER_DETAILG(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, or_cell, py_info)
VALUES (17,	'ch0001n2_05',	'',	'ch0001n2_05.ht',	8,	'',	'2018-12-19100005',	'01046559457',	'5');

INSERT INTO ORDER_DETAILG(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, or_cell, py_info)
VALUES (18,	'ch0001n2_05',	'', 'ch0001n2_05.ht',	4,	'',	'2018-12-19100006',	'01046559458',	'5');

INSERT INTO ORDER_DETAILG(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, or_cell, py_info)
VALUES (19,	'ch0001n2_05',	'',	'ch0001n2_05.ht',	3,	'',	'2018-12-19100007',	'01046559459',	'5');

INSERT INTO ORDER_DETAILG(ct_cd, md_cd, ms_cd, mo_cd, ct_count, cp_cd, or_num, or_cell, py_info)
VALUES (20,	'ch0001n2_05',	'',	'ch0001n2_05.ht',	10,	'',	'2018-12-19100008',	'01046559460',	'5');



INSERT INTO ORDER_shg(or_seq, or_pay, cpu_disc, or_tot, or_num, py_info, cp_cd, or_cell)
VALUES (ORDER_shg_seq.nextval, 17000,	0,	17000,	'2018-12-17011111',	'5',	'',	'01054655468');
  
INSERT INTO ORDER_shg(or_seq, or_pay, cpu_disc, or_tot, or_num, py_info, cp_cd, or_cell)
VALUES (ORDER_sh_seq.nextval, 48000, 0,	48000,	'2018-12-17011112',	'3',	'',	'01034257256');
 
--------------------------------------------------sheet end

--------------------------------------------------���sheet
INSERT INTO DEL_MEM(by_nick, del_addr, del_plz, or_num, by_ID, del_cd)
VALUES('sold',	'����� ����',	'',	'2018-12-17011110',	'soldesk',	'2018121701');

INSERT INTO DEL_MEM(by_nick, del_addr, del_plz, or_num, by_ID, del_cd)
VALUES('hm',	'����� ���α�',	'����',	'2018-12-18011110',	'hmgyng2017',	'2018121702');


INSERT INTO DEL_GST(del_rec, del_cell, del_pw, del_addr, del_plz, or_num, del_cd)
VALUES('������',	'01034257256',	'7635',	'����� ���ı�',	'õõ��',	'2018-12-17011112',	'2018121703');

INSERT INTO DEL_GST(del_rec, del_cell, del_pw, del_addr, del_plz, or_num, del_cd)
VALUES('�����',	'01054655468',	'23465',	'����� ���α�',	'',	'2018-12-17011111',	'2018121801');
--------------------------------------------------sheet end





--------------�ڡ��ľƹٺ�ť(ch0001)�� �α� �޴� TOP5(ȸ��)�ڡ�--------------------------------
select hap, ff.md_name, ff.rs_cd, ff.sl_nick, ff.md_price, rnum
from(
select hap, ee.md_name, ee.rs_cd, ee.sl_nick, ee.md_price, rownum rnum
from(
select sum(dd.ct_count) hap, dd.md_name, dd.rs_cd, dd.sl_nick, dd.md_price
from(
select cc.rs_cd, cc.sl_nick, cc.md_name, cc.md_price, od.md_cd, od.ct_count
from(
select bb.rs_cd, bb.sl_nick, md.mn_cd, md.md_name, md.md_price, md.md_cd
from(
select aa.rs_cd, aa.sl_nick, menu.mn_cd
from(
	select rs_cd, sl_nick
	from rs_name
	where rs_cd = 'ch0001' 
    ) aa join menu
on aa.rs_cd = menu.rs_cd
) bb join menu_detail md
on bb.mn_cd = md.mn_cd
) cc join order_detail od
on cc.md_cd = od.md_cd
) dd
group by dd.md_name, dd.rs_cd, dd.sl_nick, dd.md_price
order by hap desc
) ee
) ff
where rnum >= 1 and rnum <= 5;


--------------�ڡ��ľƹٺ�ť(ch0001)�� �α� �޴� TOP5(��ȸ��)�ڡ�--------------------------------
select hap, ff.md_name, ff.rs_cd, ff.sl_nick, ff.md_price, rnum
from(
select hap, ee.md_name, ee.rs_cd, ee.sl_nick, ee.md_price, rownum rnum
from(
select sum(dd.ct_count) hap, dd.md_name, dd.rs_cd, dd.sl_nick, dd.md_price
from(
select cc.rs_cd, cc.sl_nick, cc.md_name, cc.md_price, odg.md_cd, odg.ct_count
from(
select bb.rs_cd, bb.sl_nick, md.mn_cd, md.md_name, md.md_price, md.md_cd
from(
select aa.rs_cd, aa.sl_nick, menu.mn_cd
from(
	select rs_cd, sl_nick
	from rs_name
	where rs_cd = 'ch0001' 
    ) aa join menu
on aa.rs_cd = menu.rs_cd
) bb join menu_detail md
on bb.mn_cd = md.mn_cd
) cc join order_detailg odg
on cc.md_cd = odg.md_cd
) dd
group by dd.md_name, dd.rs_cd, dd.sl_nick, dd.md_price
order by hap desc
) ee
) ff
where rnum >= 1 and rnum <= 5;





