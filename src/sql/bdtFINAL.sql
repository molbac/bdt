--------------------------★★Create Tables★★---------------------
--------------------------------------------------회원sheet
CREATE TABLE SIGNUP( --회원가입_구매자
	by_ID	    varchar2(13)                  NOT NULL --구아이디	
	,by_nick	varchar2(24)  UNIQUE       	  NOT NULL --닉네임
	,by_PW	    varchar2(24)	              NOT NULL --비밀번호
	,by_cell	char(11)	                  NOT NULL --휴대폰 번호
	,by_regdt	date	      DEFAULT sysdate NOT NULL --등록일
	,PRIMARY KEY(by_ID)
);

CREATE TABLE SIGNUP_MY( --회원가입_판매자			
	sl_ID	    varchar2(13)   NOT NULL --판아이디
	,sl_PW  	varchar2(24)   NOT NULL --비밀번호
	,sl_nick	varchar2(1000) NOT NULL --이름
	,sl_email	varchar2(40)   NOT NULL --이메일
	,sl_cell	char(11)   	   NOT NULL --전화번호
	,sl_cerNO	char(10)	   NOT NULL --사업자등록번호
	,sl_name	char(21)	   NOT NULL --대표자명
	,sl_regdt	date	       DEFAULT sysdate --등록일
	,PRIMARY KEY(sl_ID)
);

--------------------------------------------------sheet end
--------------------------------------------------업체정보sheet
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
--------------------------------------------------sheet end

--------------------------------------------------메뉴sheet
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

--------------------------------------------------장바구니sheet
create sequence CART_seq; --장바구니 cart 테이블의 시퀀스 생성

create table CART ( --장바구니
 ct_cd int not null --장바구니 코드
,md_cd varchar(20) not null --상세코드
,ms_cd varchar(30) --사이즈코드
,mo_cd varchar(30) --옵션코드
,ct_count int default 0 --수량
,primary key(ct_cd)
,foreign key(md_cd) references menu_detail(md_cd)
,foreign key(ms_cd) references menu_size(ms_cd)
,foreign key(mo_cd) references menu_option(mo_cd)
);


create table payment ( --결제수단
 py_info char(1) not null --결제코드
,py_select varchar(36) not null --결제방법선택
,primary key(py_info)
);


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

CREATE SEQUENCE coupon_seq;

CREATE TABLE COUPON_HAVE( --보유쿠폰
	cph_seq	 int	      NOT NULL--일련번호
	,by_ID   varchar2(13) NOT NULL --구아이디
	,cp_cd   varchar2(20) NOT NULL --쿠폰코드
	,PRIMARY KEY(cph_seq)
	,FOREIGN KEY(by_ID) REFERENCES SIGNUP(by_ID)
	,FOREIGN KEY(cp_cd) REFERENCES COUPON(cp_cd)
);
--------------------------------------------------sheet end
--------------------------------------------------결제sheet
CREATE table ORDER_DETAIL( --주문상세내역서
    or_num   varchar2(30)  NOT NULL --주문서번호
    ,by_ID    varchar2(13)  NOT NULL   --구아이디
    ,ct_cd    int           NOT NULL   --장바구니코드
    ,md_cd    varchar2(20)  NOT NULL   --상세코드
    ,ms_cd    varchar2(30)             --사이즈코드
    ,mo_cd    varchar2(30)             --옵션코드
    ,ct_count int default 0            --수량
    ,cp_cd    varchar2(20)  NOT NULL   --쿠폰코드
    ,py_info  char(1)       NOT NULL   --결제코드
    ,primary key(or_num)
    ,foreign key(by_ID)    references SIGNUP(by_ID)
    ,foreign key(ct_cd)    references CART(ct_cd)
    ,foreign key(md_cd)    references MENU_DETAIL(md_cd)
    ,foreign key(ms_cd)    references MENU_SIZE(ms_cd)
    ,foreign key(mo_cd)    references MENU_OPTION(mo_cd)
    ,foreign key(py_info)  references PAYMENT(py_info)
    );
    
create sequence ORDER_sh_seq;  --시퀀스생성 일련번호
   
CREATE table ORDER_sh( --주문서
    or_seq    int           NOT NULL            --일련번호
    ,by_ID     varchar2(13)  NOT NULL           --구아이디 
    ,or_num    varchar2(30)  NOT NULL           --주문서번호   
    ,cp_cd     varchar2(20)                     --쿠폰코드
    ,cpu_disc  int           NOT NULL           --할인금액
    ,or_pay    int           NOT NULL           --결제금액
    ,or_tot    int           NOT NULL           --최종결제금액
    ,py_info   char(1)       NOT NULL           --결제코드 
    ,primary key(or_seq)
    ,foreign key(by_ID)     references SIGNUP(by_ID)
    ,foreign key(cp_cd)     references COUPON(cp_cd)    
   );
       

 CREATE table ORDER_DETAILG(                 --비회원주문상세내역서
     or_num   varchar2(30)        NOT NULL   --주문서번호
    ,or_cell  varchar2(13) unique NOT NULL   --비회원휴대폰번호
    ,ct_cd    int                 NOT NULL   --장바구니코드
    ,md_cd    varchar2(20)        NOT NULL   --상세코드
    ,ms_cd    varchar2(30)                   --사이즈코드
    ,mo_cd    varchar2(30)                   --옵션코드
    ,ct_count int default 0                  --수량
    ,cp_cd    varchar2(20)                   --쿠폰코드
    ,py_info  char(1)             NOT NULL   --결제코드
    ,primary key(or_num)
    ,foreign key(ct_cd)    references CART(ct_cd)
    ,foreign key(md_cd)    references MENU_DETAIL(md_cd)
    ,foreign key(ms_cd)    references MENU_SIZE(ms_cd)
    ,foreign key(mo_cd)    references MENU_OPTION(mo_cd)
    ,foreign key(cp_cd)    references COUPON(cp_cd)
    ,foreign key(py_info)  references PAYMENT(py_info)
    );
    
  
create sequence ORDER_shg_seq;  --시퀀스생성 일련번호

CREATE table ORDER_shg(                               --비회원주문서
     or_seq    int                                    --일련번호
    ,or_cell   varchar2(13) unique NOT NULL           --비회원휴대폰번호
    ,or_num    varchar2(30)        NOT NULL           --주문서번호   
    ,cp_cd     varchar2(20)                           --쿠폰코드
    ,cpu_disc  int                 NOT NULL           --할인금액
    ,or_pay    int                 NOT NULL           --결제금액
    ,or_tot    int                 NOT NULL           --최종결제금액
    ,py_info   char(1)             NOT NULL           --결제코드 
    ,primary key(or_seq)
    ,foreign key(or_cell)   references ORDER_DETAILG(or_cell)
    ,foreign key(cp_cd)     references COUPON(cp_cd)    
   );
 
--------------------------------------------------sheet end


--------------------------------------------------배송sheet
CREATE TABLE DEL_MEM( --배송정보_회원			
	del_cd	    varchar2(50)	NOT NULL --배송코드
	,or_num	    varchar2(30)	NOT NULL --주문서번호
	,by_ID	    varchar2(13)	NOT NULL --구아이디
	,del_addr	varchar2(500)	NOT NULL --배달주소
	,del_plz	varchar2(36)	NULL     --배달요청사항
	,by_nick	varchar2(24)	NOT NULL --받는사람
	,PRIMARY KEY(del_cd)
	,FOREIGN KEY(or_num) REFERENCES ORDER_DETAIL(or_num)
	,FOREIGN KEY(by_ID) REFERENCES SIGNUP(by_ID)
	,FOREIGN KEY(by_nick) REFERENCES SIGNUP(by_nick)
);



CREATE TABLE DEL_GST( --배송정보_비회원			
	del_cd	    varchar2(50)	NOT NULL --배송코드
	,or_num	    varchar2(30)	NOT NULL --주문서번호
	,del_addr	varchar2(500)	NOT NULL --배달주소
	,del_plz	varchar2(36)	NULL     --배달요청사항
	,del_rec	varchar2(20)	NOT NULL --받는사람
	,del_cell	char(12)	    NOT NULL --휴대폰번호
	,del_pw	    varchar2(6)	    NOT NULL --비밀번호
	,PRIMARY KEY(del_cd)
	,FOREIGN KEY(or_num) REFERENCES ORDER_DETAILG(or_num)
);

--------------------------------------------------sheet end


----------------------★★Inserts★★--------------------------------
--------------------------------------------------회원sheet
INSERT INTO SIGNUP (by_ID, by_nick, by_PW, by_cell)
VALUES ('soldesk',	'sold',	'soldesk', '01012341234');

INSERT INTO SIGNUP (by_ID, by_nick, by_PW, by_cell)
VALUES ('hmgyng2017',	'hm',	'123456',	'01038943984');

INSERT INTO SIGNUP (by_ID, by_nick, by_PW, by_cell)
VALUES ('ejks34',	'ejks',	'2kj9',	'01034257256');


 
INSERT INTO SIGNUP_MY( sl_nick, sl_ID, sl_email, sl_PW, sl_cell, sl_cerNO, sl_name)
VALUES ('후아바베큐','whobbq','whobbq@gmail.com',	'soldesk',	'1234125',	'1234512315',	'임소연');

INSERT INTO SIGNUP_MY( sl_nick, sl_ID, sl_email, sl_PW, sl_cell, sl_cerNO, sl_name)
VALUES ('라이라이',	'laelae',	'laelae@naver.com',	'ale385',	'3854536',	'3456273456',	'장민수');

INSERT INTO SIGNUP_MY( sl_nick, sl_ID, sl_email, sl_PW, sl_cell, sl_cerNO, sl_name)
VALUES ('피자아이',	'pizzakd',	'pizzakd@daum.net',	'piz234',	'2346452',	'7357356375'	,'임준원');

INSERT INTO SIGNUP_MY( sl_nick, sl_ID, sl_email, sl_PW, sl_cell, sl_cerNO, sl_name)
VALUES ('스시야미즈호대치본점',	'sushimiz',	'sushimiz@gmail.com',	'sushi99',	'3453869',	'2342695785',	'이경화');

--------------------------------------------------sheet end

--------------------------------------------------업체정보sheet
INSERT INTO rs_category (cate, cate_cd)
values ('치킨', 'ch');

INSERT INTO rs_category (cate, cate_cd)
values ('중국집', 'jja');

INSERT INTO rs_category (cate, cate_cd)
values ('피자', 'piz');

INSERT INTO rs_category (cate, cate_cd)
values ('족발/보쌈', 'jb');

INSERT INTO rs_category (cate, cate_cd)
values ('야식', 'ya');

INSERT INTO rs_category (cate, cate_cd)
values ('찜/탕', 'jjt');

INSERT INTO rs_category (cate, cate_cd)
values ('한식/분식/죽', 'kor');

INSERT INTO rs_category (cate, cate_cd)
values ('돈까스/회/일식', 'jp');

INSERT INTO rs_category (cate, cate_cd)
values ('도시락/패스트푸드', 'fast');

INSERT INTO rs_category (cate, cate_cd)
values ('꽃배달', 'flw');

INSERT INTO rs_category (cate, cate_cd)
values ('배달대행', 'dlv');

INSERT INTO rs_category (cate, cate_cd)
values ('생활편의', 'cvn');


INSERT INTO rs_name (cate_cd, sl_nick, rs_cd, sl_ID, sl_cell, rs_point, rs_okcb, rs_st, rs_end, rs_local, rs_money, rs_from)
values ('ch', '후아바베큐', 'ch0001', 'whobbq', '1234125', 500, 200, 0000, 2400, '10371, 12151', 10000, '국내산');

INSERT INTO rs_name (cate_cd, sl_nick, rs_cd, sl_ID, sl_cell, rs_point, rs_okcb, rs_st, rs_end, rs_local, rs_money, rs_from)
values ('jja', '라이라이', 'jja0001', 'laelae', '3854536', 500, 200, 1030, 2130, '10629, 10630', 8000, '국내산');

INSERT INTO rs_name (cate_cd, sl_nick, rs_cd, sl_ID, sl_cell, rs_point, rs_okcb, rs_st, rs_end, rs_local, rs_money, rs_from)
values ('piz', '피자아이', 'piz0001', 'pizzakd', '2346452', 500, 200, 1100, 0400, '10955, 10956', 13900, '국내산');

INSERT INTO rs_name (cate_cd, sl_nick, rs_cd, sl_ID, sl_cell, rs_point, rs_okcb, rs_st, rs_end, rs_local, rs_money, rs_from)
values ('jp', '스시야미즈호대치본점', 'jp0001', 'sushimiz', '3453869', 500, 200, 1000, 2200, '13212, 19283, 10930', 10000, '노르웨이산');


insert into rs_rate(rs_seq, rs_cd, by_ID, rs_rate, rs_review, rs_photo, rs_regdt)
values(rs_rate_seq.nextval, 'ch0001', 'soldesk', 4, '좋아용', 'photo.jpg', sysdate);

--------------------------------------------------sheet end

--------------------------------------------------메뉴sheet
insert into menu(rs_cd, mn_name, mn_cd)
values('ch0001', '바베큐 시리즈', 'ch0001n1');

insert into menu(rs_cd, mn_name, mn_cd)
values('ch0001', '후라이드 시리즈', 'ch0001n2');

insert into menu(rs_cd, mn_name, mn_cd)
values('ch0001', '사이드메뉴', 'ch0001n3');

insert into menu(rs_cd, mn_name, mn_cd)
values('ch0001', '샐러드', 'ch0001n4');

insert into menu(rs_cd, mn_name, mn_cd)
values('ch0001', '추가메뉴', 'ch0001n5');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '두가지 맛', 'jja0001n1');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '추천세트요리', 'jja0001n2');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '스페셜세트', 'jja0001n3');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '인기메뉴류', 'jja0001n4');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '계절메뉴', 'jja0001n5');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '한식별미', 'jja0001n6');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '면류', 'jja0001n7');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '밥류', 'jja0001n8');

insert into menu(rs_cd, mn_name, mn_cd)
values('jja0001', '요리부', 'jja0001n9');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '파티스시', 'jp0001n1');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '훗까이스시', 'jp0001n2');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '마쯔리스시', 'jp0001n3');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '연어지라시스시', 'jp0001n4');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '치킨가라아게스시', 'jp0001n5');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '단품스시', 'jp0001n6');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '면류', 'jp0001n7');

insert into menu(rs_cd, mn_name, mn_cd)
values('jp0001', '탄산음료', 'jp0001n8');


insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '시장통닭', 18000, 'ch0001n2_01.jpg', 'ch0001n2_01');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '허브후라이드', 16000, 'ch0001n2_02.jpg', 'ch0001n2_02');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '양념후라이드', 17000, 'ch0001n2_03.jpg', 'ch0001n2_03');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '순살허브후라이드', 18000, 'ch0001n2_04.jpg', 'ch0001n2_04');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '순살양념후라이드', 19000, 'ch0001n2_05.jpg', 'ch0001n2_05');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '텍사스 윙n봉', 17000, 'ch0001n2_06.jpg', 'ch0001n2_06');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('ch0001n2', '안심탕수육', 17000, 'ch0001n2_07.jpg', 'ch0001n2_07');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jja0001n1', '탕볶밥', 9000, 'jja0001n1_01.jpg', 'jja0001n1_01');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jja0001n1', '탕짜면', 9000, 'jja0001n1_02.jpg', 'jja0001n1_02');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jja0001n1', '탕짬면', 9000, 'jja0001n1_03.jpg', 'jja0001n1_03');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jja0001n1', '볶짜면', 8000, 'jja0001n1_04.jpg', 'jja0001n1_04');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jja0001n1', '볶짬면', 8000, 'jja0001n1_05.jpg', 'jja0001n1_05');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jja0001n1', '짬짜면', 8000, 'jja0001n1_06.jpg', 'jja0001n1_06');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jp0001n5', '치킨가라아게마쯔리A', 9500, 'jp0001n5_01.jpg', 'jp0001n5_01');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jp0001n5', '치킨가라아게마쯔리B', 10500, 'jp0001n5_022.jpg', 'jp0001n5_02');

insert into menu_detail(mn_cd, md_name, md_price, mn_photo, md_cd)
values('jp0001n5', '치킨가라아게마쯔리C', 8500, 'jp0001n5_03.jpg', 'jp0001n5_03');


insert into menu_size(md_cd, ms_name, ms_price, ms_cd)
values('ch0001n2_06', '튀기기', 0, 'ch0001n2_06.fr');

insert into menu_size(md_cd, ms_name, ms_price, ms_cd)
values('ch0001n2_06', '굽기', 0, 'ch0001n2_06.rt');

insert into menu_size(md_cd, ms_name, ms_price, ms_cd)
values('ch0001n2_07', '소', 0, 'ch0001n2_07.s');

insert into menu_size(md_cd, ms_name, ms_price, ms_cd)
values('ch0001n2_07', '중', 7000, 'ch0001n2_07.m');

insert into menu_size(md_cd, ms_name, ms_price, ms_cd)
values('ch0001n2_07', '대', 16000, 'ch0001n2_07.l');



insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_03', '달콤한맛', 0, 'ch0001n2_03.sw');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_03', '보통맛', 0, 'ch0001n2_03.nr');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_03', '매콤한맛', 0, 'ch0001n2_03.ht');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_03', '매운맛', 0, 'ch0001n2_03.sht');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_03', '아주매운맛', 0, 'ch0001n2_03.sfht');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_05', '달콤한맛', 0, 'ch0001n2_05.sw');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_05', '보통맛', 0, 'ch0001n2_05.nr');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_05', '매콤한맛', 0, 'ch0001n2_05.ht');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_05', '매운맛', 0, 'ch0001n2_05.sht');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('ch0001n2_05', '아주매운맛', 0, 'ch0001n2_05.sfht');


insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jja0001n1_01', '곱빼기', 2000, 'jja0001n1_01.gop');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jja0001n1_02', '곱빼기', 2000, 'jja0001n1_02.gop');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jja0001n1_03', '곱빼기', 2000, 'jja0001n1_03.gop');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jja0001n1_04', '곱빼기', 1000, 'jja0001n1_04.gop');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jja0001n1_05', '곱빼기', 1000, 'jja0001n1_05.gop');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jja0001n1_06', '곱빼기', 1000, 'jja0001n1_06.gop');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jp0001n5_01', '소고기불초밥추가', 2000, 'jp0001n5_01.so');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jp0001n5_02', '소고기불초밥추가', 2000, 'jp0001n5_02.so');

insert into menu_option(md_cd, mo_name, mo_price, mo_cd)
values('jp0001n5_03', '소고기불초밥추가', 2000, 'jp0001n5_03.so');


--------------------------------------------------sheet end

--------------------------------------------------장바구니sheet
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

--비회원 레코드
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


insert into coupon(cp_cd, cp_name, cp_min, cp_regdt, cp_end, cp_disc, rs_cd)
values('mcp01jp0001', '음료/음식 교환권', 15000, sysdate, '', 0, 'jp0001');

insert into coupon(cp_cd, cp_name, cp_min, cp_regdt, cp_end, cp_disc, rs_cd)
values('scp01ch0001', '2천원 할인권', 12000, sysdate, '', 2000, 'ch0001');




INSERT INTO COUPON_HAVE (cph_seq, by_ID, cp_cd)
VALUES (coupon_seq.nextval, 'soldesk',	'scp01ch0001');

INSERT INTO COUPON_HAVE (cph_seq, by_ID, cp_cd)
VALUES (coupon_seq.nextval, 'hmgyng2017',	'mcp01jp0001');

INSERT INTO COUPON_HAVE (cph_seq, by_ID, cp_cd)
VALUES (coupon_seq.nextval, 'ejks34',	'mcp01jp0001');

--------------------------------------------------sheet end

--------------------------------------------------결제sheet
--※※※※※※※※※※※※※<ORDER_DETAIL>,<ORDER_DETAILG> INSERT 시 ct_cd 확인※※※※※※※※※※※※※※※※※※
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

--------------------------------------------------배송sheet
INSERT INTO DEL_MEM(by_nick, del_addr, del_plz, or_num, by_ID, del_cd)
VALUES('sold',	'서울시 은평구',	'',	'2018-12-17011110',	'soldesk',	'2018121701');

INSERT INTO DEL_MEM(by_nick, del_addr, del_plz, or_num, by_ID, del_cd)
VALUES('hm',	'서울시 종로구',	'당장',	'2018-12-18011110',	'hmgyng2017',	'2018121702');


INSERT INTO DEL_GST(del_rec, del_cell, del_pw, del_addr, del_plz, or_num, del_cd)
VALUES('영례찡',	'01034257256',	'7635',	'서울시 송파구',	'천천히',	'2018-12-17011112',	'2018121703');

INSERT INTO DEL_GST(del_rec, del_cell, del_pw, del_addr, del_plz, or_num, del_cd)
VALUES('강사님',	'01054655468',	'23465',	'서울시 종로구',	'',	'2018-12-17011111',	'2018121801');
--------------------------------------------------sheet end





--------------★★후아바베큐(ch0001)의 인기 메뉴 TOP5(회원)★★--------------------------------
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


--------------★★후아바베큐(ch0001)의 인기 메뉴 TOP5(비회원)★★--------------------------------
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





