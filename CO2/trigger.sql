create table sample(sid number,sname varchar(20));

insert into sample values(&sid,'&sname');

create or replace trigger t1
before insert or update or delete on sample for each row
begin
raise_application_error(-20000,'you are not permitted to  do INSERT/UPDATE/DELETE');
end;
/

drop trigger t1;

create or replace trigger t1
after insert or update or delete on sample for each row
begin
raise_application_error(-20000,'you are not permitted to  do INSERT/UPDATE/DELETE');
end;
/

#professor table

create table professor(pnum number,pname varchar(20),salary number);

insert into professor values (&pnum,'&pname',&salary);

create or replace trigger minsalary
before insert on professor for each row
begin
if(:new.salary<60000)
then raise_application_error(-20004,'Violation of minimum professor salary');
end if;
end;
/

create table professorbacklog as select * from professor;
delete from professorbacklog;

create or replace trigger backlog
after delete on professor for each row
begin
insert into professorbacklog values(:old.pnum,:old.pname,:old.salary);
end;
/
delete from professor where pnum=1;

.................................................................................................................................

create table student(rollno number,name varchar(20),gender varchar(20));

create table gender(fcount number,mcount number);
insert into gender values(&fcount,&mcount);

create or replace trigger count
after insert on student for each row
begin
if(:new.gender ='female')
then
update gender set fcount=fcount+1;
elsif(:new.gender='male')
then
update gender set mcount=mcount+1;
end if;
end;
/

insert into student values(&rollno,'&name','&gender');

.....................................................................................................................................

create table gold(cdate date,price number);
insert into gold values('&date',&price);

create table oldgold(odate date,oprice number);

create or replace trigger gold
after update on gold for each row
begin
insert into oldgold values(:old.cdate,:old.price);
end;
/

update gold set price=6000,cdate='27-MAY-22';

......................................................................................................................................

create table prod1(pid number,pname varchar(20),quantity number);

create table orders(opid number,pname varchar(20));

create or replace trigger ord
after insert on prod1 for each row
begin
if(:new.quantity<100)
then
insert into orders values(:new.pid,:new.pname);
end if;
end;
/

insert into prod1 values(&pid,'&pname',&quantity);

select * from prod1;
select * from orders;