--�������ݿ�student
CREATE DATABASE student
ON ( NAME = st_data,
	FILENAME = 'd:\sqldb\data\st_data.mdf',
	SIZE = 15,
	MAXSIZE = 50,
	FILEGROWTH = 10%)
LOG ON ( NAME = st_log,
	FILENAME = 'd:\sqldb\data\st_log.ldf',
	SIZE = 1MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 1MB)
GO

--�������ݿ�db2,ʹ��db2_n2�����ļ���filegroup1
CREATE DATABASE db2
ON PRIMARY
( NAME = db2_data,
  FILENAME = 'd:\sqldb\data\db2_data.mdf',
  SIZE = 10,
  MAXSIZE = 50,
  FILEGROWTH = 10%),
( NAME = db2_n1,
  FILENAME = 'd:\sqldb\data\db2_n1.ndf',
  SIZE = 1,
  MAXSIZE = 10,
  FILEGROWTH = 10%),
FILEGROUP filegroup1
( NAME = db2_n2,
  FILENAME = 'd:\sqldb\data\db2_n2.ndf',
  SIZE = 1,
  MAXSIZE = 10,
  FILEGROWTH = 10%)
LOG ON
( NAME = db2_log,
  FILENAME = 'd:\sqldb\data\db2_log.ldf',
  SIZE = 1,
  MAXSIZE = 10,
  FILEGROWTH = 10%)
GO


--���õ�ǰ���ݿ�
USE db2

--�鿴���ݿⶨ����Ϣ
EXEC sp_helpdb db2

--�鿴���ݿ�ռ�ʹ�������sp_spaceused���治ָ��ֵ��
EXEC sp_spaceused 
--�鿴ָ����Ŀռ�ʹ�������sp_spaceused����ָ��������
USE adventureworks
EXEC sp_spaceused 'Person.Address'
--�鿴ָ����ͼ�Ŀռ�ʹ�������sp_spaceused����ָ����ͼ����
EXEC sp_spaceused 'HumanResources.vEmployee'


--�����ļ���С
--�޸����ݿ�db2������������ļ�db2_n1������Ϊ5MB
ALTER DATABASE db2
MODIFY FILE
( NAME = db2_n1,
  SIZE = 5MB)
GO

--�޸����ݿ�db2������һ���������ļ�db2_n3���������ļ���ӵ�һ���µ��ļ���filegroup2��
ALTER DATABASE db2
ADD FILEGROUP filegroup2
GO
ALTER DATABASE db2
ADD FILE
( NAME = db2_n3,
  FILENAME = 'd:\sqldb\data\db2_n3.ndf',
  SIZE = 1,
  MAXSIZE = 10,
  FILEGROWTH = 10%)
TO FILEGROUP filegroup2
GO

--�޸����ݿ�db2���������ݿ������޸�Ϊnew_db2
/*ʹ��SET SINGLE_USER��Ҫ�Ƿ�ֹ��������������û��������ݿ⣬
�����ȷ��û���κ��û�����ʹ�����ݿ�. ����ͨ�������ݿ�����Ϊ���û�ģʽ��
Ҳ���������ݿ����ԡ�������ѡ�ѡ�������ҵ������Ʒ��ʡ�ѡ�ѡ��SINGLE_USERѡ�
Ȼ��ִ��MODIFY NAME = new_db2 ��䣬�����޸����ݿ����ơ�*/
ALTER DATABASE db2
	SET SINGLE_USER
GO
ALTER DATABASE db2
	MODIFY NAME = new_db2
GO
ALTER DATABASE new_db2
	SET MULTI_USER
GO

--��һ���޸����ݿ����Ƶķ���sp_renamedb
EXEC sp_renamedb 'new_db2','db2' 


--�������ݿ�new_db2��ʹ�ļ���10%�Ŀ��ÿռ�
DBCC SHRINKDATABASE (db2,10)
GO

--ɾ�����ݿ�db1
CREATE DATABASE db1
GO
DROP DATABASE db1
GO


--�ӵ�ǰ�������������ݿ�new_db2
--�����ǰ���ݿ�Ϊnew_db2������ʧ�ܣ����Է���ǰ�Ȱѵ�ǰ���ݿ���Ϊmaster
USE master
EXEC sp_detach_db 'db2'
GO

--�����ݿ�new_db2���ӵ���ǰ������ʵ�����������ݿ�����Ϊdb2
CREATE DATABASE db2
	ON
	( NAME = db2_data,
	FILENAME = 'd:\sqldb\data\db2_data.mdf')
	FOR ATTACH
GO


--����������������name������ϵͳ��������varchar��10���������ֵ
USE student
GO
CREATE TYPE name
	FROM varchar(10) NULL
GO

--ɾ��������������test
CREATE TYPE test
	FROM char(2) 
GO
DROP TYPE test
GO


--����ѧ����student����ṹ��ͼ4-9��������Լ����Ϣ
USE student
GO
CREATE TABLE student
(
	st_id char(10) NOT NULL,
	st_name varchar(10) NOT NULL,
	st_birth datetime NULL,
	st_gender char(2) NULL,
	st_address varchar(60) NULL,
	st_tel varchar(15) NULL,
	st_clid char(2) NULL)
GO

--�������б�ʶ�У������еı�����Ϊcompute_table
USE student
GO
CREATE TABLE compute_table
(
	id int identity(1,1),
	column1 int,
	column2 int,
	column3 AS column1+column2,
	column4 char(2))
GO


--�鿴��compute_table�Ľṹ
USE student
GO
EXEC sp_help 'compute_table'
GO

--�޸ı�student����������st_nation ,st_native
USE student
GO
ALTER TABLE student
 ADD
	st_nation char(2) NULL,
	st_native char(2) NULL
GO


--��������compute_table�����ƣ��µ�����Ϊnew_compute
USE student
GO
EXEC sp_rename 'compute_table','new_compute'
GO 


--ɾ����new_compute
USE student
GO
DROP TABLE new_compute
GO


--���student�в���һ����¼���ü�¼��Ӧ���е�������
USE student
GO
INSERT INTO student(st_id, st_name, st_birth ,st_gender, st_address, st_tel, st_clid)
	VALUES('2005010101','����','1998-10-10','Ů','�����г�����','84981234','01')
GO

--���student�в���һ����¼���ü�¼��Ӧ���е���Ӧ��
USE student
GO
INSERT INTO student(st_id, st_name, st_birth ,st_gender, st_clid)
	VALUES('2005010102','����','1989-12-1','��','01')
GO


--������м�¼,���ѱ�student�е�st_id��st_name�в��뵽��һ����kaoping_table��
USE student
GO
CREATE TABLE kaoping_table
(
	id char(10),
	name varchar(10),
	pingjia varchar(10)
)
GO
INSERT INTO kaoping_table(id,name)
	SELECT st_id,st_name FROM student
GO


--���±��е�һ�м�¼
USE student
GO
UPDATE student
	SET st_birth = '1989-10-10',st_tel = '010_84981234'
	WHERE st_id = '2005010101'
GO

--���±��е����м�¼
USE student
GO
UPDATE student
	SET st_address = '�����к�����'
GO


--ɾ����kaoping_table�е����м�¼
USE student
GO
DELETE FROM kaoping_table
GO


--��ѧ����st_id��������Լ��
USE student
GO
ALTER TABLE student
	ADD CONSTRAINT pk_stid PRIMARY KEY(st_id)
GO

--������dept������������Լ����Ωһ��Լ����Ϣ
USE student
GO
CREATE TABLE dept
(
	dt_id char(2) PRIMARY KEY,
	dt_name varchar(20) NOT NULL UNIQUE,
	dt_address varchar(20) NULL,
	dt_tel varchar(15) NULL
)
GO

--������class
USE student
GO
CREATE TABLE class
(
	cl_id char(2) NOT NULL PRIMARY KEY,
	cl_name varchar(20) NOT NULL UNIQUE,
	cl_room varchar(20) NULL,
	cl_dtid char(2) NULL REFERENCES dept(dt_id) 
)
GO

--�����������st_clid�������Լ��
USE student
GO
ALTER TABLE student
	ADD CONSTRAINT fk_student_class FOREIGN KEY (st_clid) REFERENCES class (cl_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
GO


--��������Լ���ͼ��Լ����Ϣ
USE student
GO
CREATE TABLE course
(
	cr_id char(6) PRIMARY KEY,
	cr_name varchar(30) NOT NULL,
	cr_type char(4) NULL CHECK(cr_type = '����' or cr_type = '����'),
	cr_time int NULL
)
GO

--��������Լ�������Լ����Ĭ��Լ����Ϣ
USE student
GO
CREATE TABLE teacher
(
	th_id char(6) PRIMARY KEY,
	th_name varchar(10) NOT NULL,
	th_gender char(2) NULL CHECK(th_gender = '��' or th_gender = 'Ů'),
	th_position char(6) NULL,
	th_type char(4) NULL DEFAULT 'רְ'
)
GO

--������score��������Լ����Ϣ��
--�޸ı�score�����Լ����Ϣ��
USE student
GO
CREATE TABLE score
(
	sc_stid char(10) NOT NULL,
	sc_crid char(6) NOT NULL,
	sc_grade decimal(4,1) NULL
)
GO
ALTER TABLE score
	ADD
		CONSTRAINT pk_stid_crid PRIMARY KEY (sc_stid, sc_crid),
		CONSTRAINT fk_score_student FOREIGN KEY (sc_stid) REFERENCES student(st_id),
		CONSTRAINT fk_score_course FOREIGN KEY (sc_crid) REFERENCES course (cr_id)
GO


--������schedule,����Լ����Ϣ
USE student
GO
CREATE TABLE schedule
(
	sh_thid char(6) NOT NULL REFERENCES teacher(th_id),
	sh_crid char(6) NOT NULL REFERENCES course(cr_id),
	sh_clid char(2) NOT NULL REFERENCES class(cl_id),
	sh_time char(11) NULL,
	sh_room varchar(15) NULL,
	CONSTRAINT pk_thid_crid_clid PRIMARY KEY (sh_thid, sh_crid, sh_clid)
)
GO


--�������̱����豸���߼�����Ϊstudent_backup1
EXEC sp_addumpdevice 'disk','student_backup1','d:\sqlbackup\student_backup1.bak'
GO


--�����ݿ�student�����������ݣ������ݴ洢�ڱ����豸student_backup1��
--����ǰ�Ȱѻָ�ģʽ��Ϊ����
USE student
GO
BACKUP DATABASE student TO student_backup1
WITH  NAME = 'student��������'
GO


--�������̱����豸���߼�����Ϊstlog_backup1
EXEC sp_addumpdevice 'disk','stlog_backup1','d:\sqlbackup\stlog_backup1.bak'
GO

--�鿴���б����豸
SELECT * FROM sys.backup_devices
GO


--���student�в���������¼��
--�Ա�student���в��챸�ݣ������ݴ洢�ڱ����豸student_backup1�У��������α���׷�ӵ����ʵ���������֮��
USE student
GO
INSERT INTO student(st_id, st_name, st_birth, st_gender, st_address, st_tel, st_clid)
VALUES('2005010202','����','1989-12-9','��','�����ж�����','13112222678','01')
GO
BACKUP DATABASE student TO student_backup1
WITH DIFFERENTIAL, NAME = 'student���챸��'
GO


--ִ��������־����
BACKUP LOG student TO stlog_backup1
WITH NAME='student������־����'
GO


--��ԭ���ݿ�
--1)��ԭ��������
RESTORE DATABASE student
	FROM student_backup1
	WITH FILE=1,NORECOVERY,REPLACE
GO
--2)��ԭ���챸��
RESTORE DATABASE student
	FROM student_backup1
	WITH FILE=2,NORECOVERY
GO
--3)��ԭ������־����
RESTORE DATABASE student
	FROM stlog_backup1
	WITH FILE=1,RECOVERY,REPLACE
GO



--���������ֲ���������ֵ����ʾ��Ϣ
USE student
GO
DECLARE @num int,@gender char(2)
SET @gender='��'
SELECT @num=count(*) FROM student WHERE st_gender=@gender
PRINT '�Ա�' + @gender + '�������ǣ�' + convert(char(4),@num)
GO


--��ʾȫ�ֱ���@@CONNECTIONS ��ֵ
SELECT @@CONNECTIONS AS '���Ӵ���'
GO


--ʹ��CEILING(),FLOOR(),ROUND(),RAND()����������ʾ����ֵ
SELECT ceiling(12.345) AS ��С����, floor(12.345) AS �������, round(12.345,2) AS ��������, rand() AS �����
GO

--����SUBSTRING(),STUFF(),LEN(),REVERSE()����������ʾ����ֵ
SELECT substring('abcdef',2,2) AS ���ַ���, stuff('abcdef',2,2,'123') AS �滻�ַ���, 
len('abcdef') AS �ַ�������, reverse('abcdef') AS �����ַ���
GO

--����GETDATE(),DATEADD(),DATEDIFF(),DATENAME(),DATEPART()����������ʾ����ֵ
SELECT getdate() AS ϵͳ����, dateadd(dd,10,getdate()) AS ��ʮ������,
datediff(dd,'2009-1-1',getdate()) AS �������,
datename(weekday,getdate()) AS ����, datepart(yy,getdate()) AS ϵͳ���
GO

--����CAST(),CONVERT()����������ʾ����ֵ
SELECT cast(getdate() AS varchar(30)) AS ����ʱ��, convert(varchar(30),getdate(),120) AS ����ʱ��,
convert(varchar(30),getdate(),108) AS ʱ��, convert(varchar(30),getdate(),111) AS ����
GO


--����DB_ID(),CURRENT_USER(),ISDATE(),ISNULL()����������ʾ����ֵ
SELECT db_id('studnet') AS ���ݿ�ID,current_user AS ���ݿ��û�, isdate(getdate()) AS �����ж�,
 isnull(NULL,'IS NULL') AS ��ֵ�ж�
GO


--�û����庯��
--����һ����������func_age,����������ڣ���������ֵ�����ú���func_age����ʾ����ֵ
USE student
GO
--1)������������
CREATE FUNCTION func_age
	(@var_birth datetime)
	RETURNS int
AS
	BEGIN
		RETURN datediff(yy,@var_birth,getdate())
	END
GO
--2)ʹ�ñ�������
SELECT dbo.func_age('1997-1-10') AS '����'
GO



--�ж�һ�����ͱ�����ֵ��
--���Ϊ�գ���ʾ��value is null����
--������ʾ�ñ�����ֵ
DECLARE @var_a int
IF @var_a is null
	PRINT 'value is null'
ELSE
	PRINT CONVERT(varchar(10),@var_a)
GO


--���㲢1+2+3+4+������������+100��ֵ
DECLARE @i int, @sum int
SET @i=1
SET @sum=0
WHILE @i<=100
	BEGIN
		SET @sum=@sum+@i
		SET @i=@i+1
	END
PRINT '1+2+3+4+������������+100�Ľ��Ϊ��'+ CONVERT(varchar(6),@sum)
GO


--������student����ѯ����ѧ����ѧ�ź�����
USE student
GO
SELECT st_id,st_name FROM student
GO

--������student����ѯ����ѧ����ѧ�ź������͵绰�������볣����
--�����С�please call��
USE student
GO
SELECT st_id,st_name,'please call:',st_tel FROM student
GO

--������student����ѯ����ѧ������ϸ��Ϣ
--*
USE student
GO
SELECT * FROM student
GO

--������student����ѯ����ѧ����ѧ�ź����������䣬��������ָ��������
--������ʽ���£�
--���� AS ����
--���� ����
--���� = ����
USE student
GO
SELECT st_id AS ѧ��,st_name ����,���� = dbo.func_age(st_birth) FROM student
GO

--������student����ѯ����ѧ��������ϵ��
--DISTINCT�����ظ���
USE student
GO
--1)����������ظ���
SELECT substring(st_id,5,2) AS ϵ�� FROM student
GO
--2)����������ظ���
SELECT DISTINCT substring(st_id,5,2) AS ϵ�� FROM student
GO

--������student����ѯǰ����ѧ������ϸ��Ϣ
--TOP
USE student
GO
SELECT TOP 2 * FROM student
GO

--������student����ѯǰ50%ѧ������ϸ��Ϣ
-- PERCENT
USE student
GO
SELECT TOP 50 PERCENT * FROM student
GO

--������student����ѯ��������ϸ��Ϣ
--WHERE
USE student
GO
SELECT * FROM student
	WHERE st_gender='��'
GO

--������student����ѯ1989�������ѧ������ϸ��Ϣ
--����1
--BETWEEN������AND������(��Χ)
USE student
GO
SELECT * FROM student
	WHERE st_birth BETWEEN '1989-1-1' AND '1989-12-31'
GO
--����2
--AND(�߼�����)
SELECT * FROM student
	WHERE st_birth >= '1989-1-1' AND st_birth <='1989-12-31'
GO


--������student����ѯ01,02,03��ѧ������ϸ��Ϣ
--����1
--IN(�б�)
USE student
GO
SELECT * FROM student
	WHERE st_clid IN ('01','02','03')
GO
--����2
--OR(�߼�����)
USE student
GO
SELECT * FROM student
	WHERE st_clid = '01' OR st_clid = '02' OR st_clid = '03'
GO



--������student����ѯ������ѧ������ϸ��Ϣ
--LIKE(ƥ��ģʽ)
USE student
GO
SELECT * FROM student
	WHERE st_name LIKE '��%'
GO

--������student����ѯ2005~2008����ѧ��ѧ������ϸ��Ϣ
--LIKE(ƥ��ģʽ)
USE student
GO
SELECT * FROM student
	WHERE substring(st_id,1,4) LIKE '200[5-8]'
GO

--������student����ѯ�绰�к����»���_��ѧ������ϸ��Ϣ
--ESCAPE(ת��) ,��a������ַ�ת��
USE student
GO
SELECT * FROM student
	WHERE st_tel LIKE '%a_%' ESCAPE 'a'
GO

--������student����ѯ��ͥ��ַΪ�յ�ѧ������ϸ��Ϣ
--IS NULL(�жϷǿ�)
USE student
GO
SELECT * FROM student
	WHERE st_address IS NULL
GO

--������score����ѯѡ���˿γ̺�Ϊ'c01001'��ѧ����ѧ�ż��ɼ�������װ�ɼ�����������ʾǰ���м�¼
--ORDER BY(����) �� DESC(����)
USE student
GO
SELECT TOP 3 sc_stid,sc_grade FROM score
	WHERE sc_crid = 'c01001' 
	ORDER BY sc_grade DESC
GO

--������score����ѯ��¼��
--COUNT() (һ���е�������)
USE student
GO
SELECT COUNT(*) AS ��¼�� FROM student
GO

--������score����ѯѡ���˿γ̺�'c01001'��ѧ���������ܳɼ���ƽ���ɼ�����߳ɼ�����ͳɼ�
--SUM()(һ����ֵ���ܺ�),AVG()(һ���е�ƽ��ֵ),MAX()(һ���е����ֵ),MIN()(һ���е���Сֵ)
USE student
GO
SELECT COUNT(sc_stid) AS ѧ������, SUM(sc_grade) AS �ܳɼ�, AVG(sc_grade) AS ƽ���ɼ�,
 MAX(sc_grade) AS ��߳ɼ�, MIN(sc_grade) AS ��ͳɼ� FROM score
	WHERE sc_crid = 'c01001'
GO

--������score�����γ̺Ž��з��飬��ѯ���ſγ̵Ŀγ̺š��Ͽ�������ƽ���ɼ�
--GROUP BY(����)
USE student
GO
SELECT sc_crid AS �γ̺�, COUNT(sc_stid) AS �Ͽ�����, AVG(sc_grade)AS ƽ���ɼ� FROM score
	GROUP BY sc_crid
GO

--������score�����γ̺Ž��з��飬��ѯ�Ͽ���������2�˵ĸ��ſγ̵Ŀγ̺š��Ͽ�������ƽ���ɼ�
--GROUP BY(����) �� HAVING(������ѯ)
USE student
GO
SELECT sc_crid AS �γ̺�, COUNT(sc_stid) AS �Ͽ�����, AVG(sc_grade) AS ƽ���ɼ� FROM score
	GROUP BY sc_crid
	HAVING COUNT(sc_stid) > 2
GO

--������score����ѯ�γ̺š�ѧ�š��ɼ�����ϸ�����л����Ͽ�������ƽ���ɼ�
--COMPUTE(��ѯ��ϸ)
USE student
GO
SELECT * FROM score
	COMPUTE COUNT(sc_stid), AVG(sc_grade)
GO

--������score�����տγ̺ŷ��飬��ѯ����Ŀγ̺š�ѧ�š��ɼ�����ϸ�в������Ͽ�������ƽ���ɼ�
USE student
GO
SELECT * FROM score
	ORDER BY sc_crid
	COMPUTE COUNT(sc_stid), AVG(sc_grade) BY sc_crid
GO

--�Ա�dept�ͱ�class���н������ӣ���ѯ�������е�������
--CROSS JOIN(��������)
USE student
GO
SELECT dept.*, class.*
FROM dept CROSS JOIN class
GO

--�Ա�class�ͱ�student���е�ֵ���ӣ���ѯ����ѧ���İ༶����ѧ����Ϣ���������������������
--����1
--JOIN
USE student
GO
SELECT * FROM class JOIN student
ON class.cl_id = student.st_clid
GO

--����2
--��Ȼ���Ӳ�ѯ
USE student
GO
SELECT class.* ,student.st_id ,student.st_name ,student.st_birth , student.st_gender ,student.st_address ,student.st_tel ,student.st_clid
FROM class JOIN student
ON class.cl_id = student.st_clid
GO


--�Ա�class�ͱ�student�����������ӣ���ѯû��ѧ���İ༶��Ϣ
USE student
GO
SELECT class.* FROM class LEFT JOIN student
	ON class.cl_id = student.st_clid
	WHERE student.st_id IS NULL
GO


--�Ա�student���������ӣ���ѯ��ѧ��Ϊ'2005010101'��ͬһ���༶��ѧ����ѧ�ź�����
USE student
GO
SELECT student2.st_id,student2.st_name
FROM student AS student1 JOIN student AS student2
ON student1.st_clid = student2.st_clid
WHERE student1.st_id = '2005010101' AND student2.st_id <> '2005010101'
GO


--�Ա�student����course����score���е�ֵ���ӣ���ѯѧ����������ѡ�޵Ŀγ����Լ���ȡ�õĳɼ�
--����1
USE student
GO
SELECT student.st_name,course.cr_name,score.sc_grade
FROM student JOIN score 
ON student.st_id = score.sc_stid
JOIN course ON course.cr_id = score.sc_crid
GO

--����2
USE student
GO
SELECT student.st_name,course.cr_name,score.sc_grade
FROM student,course,score
WHERE student.st_id = score.sc_stid AND course.cr_id = score.sc_crid
GO


--������SELECT���������ϲ�ѯ����һ����ѯ��student����ѯѧ����ѧ�ţ��������ڶ�����ѯ��teacher����ѯ��ʦ�ı�ţ�����
--����1
USE student
GO
SELECT st_id AS ��Ա���, st_name AS ��Ա���� FROM student
UNION
SELECT th_id ,th_name FROM teacher
ORDER BY st_name
GO

--����2
USE student
GO
SELECT st_name
FROM student
WHERE st_clid = (SELECT st_clid FROM student WHERE st_id = '2005010101') AND st_id <> '2005010101'
GO


--������class����student����ѯ����Ϊ'05����1��'��ѧ������ϸ��Ϣ
--����1
USE student
GO
SELECT *
FROM student
WHERE st_clid = (SELECT cl_id FROM class WHERE cl_name = '05����1��')
GO

--����2
USE student
GO
SELECT *
FROM student JOIN class
ON student.st_clid = class.cl_id
WHERE class.cl_name = '05����1��'
GO


--������student����score����ѯ���Ϊ'01' ��ѧ���ɼ�����ϸ��Ϣ
--IN�Ӳ�ѯ
USE student
GO
SELECT * FROM score
WHERE sc_stid IN (SELECT st_id FROM student WHERE st_clid = '01')
GO

--������class����student���ж��Ƿ���ڰ���ѧ���İ༶����������ڣ��򷵻ز�����ѧ���İ༶����ϸ��Ϣ
USE student
GO
SELECT * FROM class
WHERE NOT EXISTS (SELECT * FROM student WHERE student.st_clid = class.cl_id)
GO