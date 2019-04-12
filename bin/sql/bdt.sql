create sequence CART_seq; --장바구니 cart 테이블의 시퀀스 생성

create table CART ( --장바구니
 ct_cd int not null --장바구니 코드
,md_cd varchar(20) not null --상세코드
,ms_cd varchar(30) not null --사이즈코드
,mo_cd varchar(30) not null --옵션코드
,ct_count int default 0 --수량
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

상세코드fk			사이즈코드fk		옵션코드fk			   수량	  장바구니코드pk
ch0001n2_01		null			ch0001n2_03.sw		1		1
ch0001n2_06		ch0001n2_06.rt	null				1		2
ch0001n2_07		ch0001n2_07.m	null				2		3
jp0001n5_02		null			jp0001n5_02.so		2		4


create table payment ( --결제수단
 py_info char(1) not null --결제코드
,py_select varchar(36) not null --결제방법선택
,primary key(py_info)
);

insert into payment(py_info, py_select)
values('1', '휴대폰 결제');

insert into payment(py_info, py_select)
values('2', '신용카드 결제');

insert into payment(py_info, py_select)
values('3', '간편결제');

insert into payment(py_info, py_select)
values('4', '교통카드 결제');

insert into payment(py_info, py_select)
values('5', '상품권 결제');

insert into payment(py_info, py_select)
values('6', '현금 결제(현)');

insert into payment(py_info, py_select)
values('7', '신용카드 결제(현)');

결제방법선택		결제정보
휴대폰 결제		1
신용카드 결제		2
간편결제			3
교통카드 결제		4
상품권 결제		5
현금 결제(현)		6
신용카드 결제(현)	7


create table coupon ( --쿠폰
 cp_cd varchar(20) not null --쿠폰코드 <업체코드+s(할인쿠폰)/m(증정쿠폰)+cp+숫자코드2자리(max()함수를 활용하여 시퀀스 부여)>
,cp_name varchar(50) not null --쿠폰종류
,cp_min int not null --최소 주문금액
,cp_regdt date default sysdate --등록일
,cp_end date --만료일
,cp_disc int not null --할인금액
,rs_cd varchar(15) not null --업체코드
,primary key(cp_cd)
,foreign key(rs_cd) references rs_name(rs_cd)
);

insert into coupon(cp_cd, cp_name, cp_min, cp_regdt, cp_end, cp_disc, rs_cd)
values('mcp01jp0001', '음료/음식 교환권', 15000, sysdate, '', 0, 'jp0001');

insert into coupon(cp_cd, cp_name, cp_min, cp_regdt, cp_end, cp_disc, rs_cd)
values('scp01ch0001', '2천원 할인권', 12000, sysdate, '', 2000, 'ch0001');

업체코드fk	 쿠폰종류		  최소주문금액	    시작일			만료일	 쿠폰코드pk		할인금액
jp0001	음료/음식 교환권	15000	  2018-10-24	2018-12-24	mcp01jp0001		0
ch0001	2천원 할인권	    12000	  2018-10-20	2018-10-21	scp01ch0001		2000


create table rs_category ( --음식종류
 cate_cd varchar(8) not null --종류코드
,cate varchar(30) not null --종류
,primary key(cate_cd)
);

create table rs_name ( --판매업체정보
 rs_cd varchar(15) not null --업체코드 종류코드+4자리 일련번호
,sl_nick char(100) not null --업체명
,cate_cd varchar(8) not null --종류코드
,sl_ID varchar(13) not null --판매자아이디
,sl_cell char (11) not null --전화번호
,rs_point int default 0 --포인트적립
,rs_okcb int default 0 --ok캐쉬백
,rs_st int not null --영업시작시간 4자리코드(HHMM)
,rs_end int not null --영업종료시간 4자리코드(HHMM)
,rs_local varchar(80) not null --배달가능지역 우편번호 5자리. ','로 구분.
,rs_money int default 0 --배달가능금액
,rs_from varchar(1000) --원산지정보
,primary key(rs_cd)
,foreign key(cate_cd) references rs_category(cate_cd)
,foreign key(sl_ID) references signup_my(sl_ID)
);

create sequence rs_rate_seq; --업체평가 rs_rate의 시퀀스

create table rs_rate ( --업체평가
 rs_seq int not null --일련번호 시퀀스(sq_rate) 생성
,rs_cd varchar(15) not null --업체코드
,by_ID varchar(13) not null --구매자아이디
,rs_rate int not null --평점
,rs_review varchar(1000) --후기
,rs_photo char(1000) --후기사진 파일명 입력
,rs_regdt date default sysdate --작성일
,primary key(rs_seq)
,foreign key(rs_cd) references rs_name(rs_cd)
,foreign key(by_ID) references signup(by_ID)
);

insert into rs_rate(rs_seq, rs_cd, by_ID, rs_rate, rs_review, rs_photo, rs_regdt)
values(rs_rate_seq.nextval, 'ch0001', 'soldesk', 4, '좋아용', 'photo.jpg', sysdate);

업체코드fk 	평점	  후기  	    작성일	   구아이디fk
ch0001	    4	 good job	43451		soldesk







