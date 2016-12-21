--创建数据库student
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

--创建数据库db2,使得db2_n2加入文件组filegroup1
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


--设置当前数据库
USE db2

--查看数据库定义信息
EXEC sp_helpdb db2

--查看数据库空间使用情况（sp_spaceused后面不指定值）
EXEC sp_spaceused 
--查看指定表的空间使用情况（sp_spaceused后面指定表名）
USE adventureworks
EXEC sp_spaceused 'Person.Address'
--查看指定视图的空间使用情况（sp_spaceused后面指定视图名）
EXEC sp_spaceused 'HumanResources.vEmployee'


--扩充文件大小
--修改数据库db2，扩充此数据文件db2_n1的容量为5MB
ALTER DATABASE db2
MODIFY FILE
( NAME = db2_n1,
  SIZE = 5MB)
GO

--修改数据库db2，增加一个次数据文件db2_n3，并将该文件添加到一个新的文件组filegroup2中
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

--修改数据库db2，将其数据库名称修改为new_db2
/*使用SET SINGLE_USER主要是防止还有其它程序或用户连接数据库，
你必须确保没有任何用户正在使用数据库. 可以通过将数据库设置为单用户模式。
也可以在数据库属性——》“选项”选择里面找到“限制访问”选项，选择SINGLE_USER选项。
然后执行MODIFY NAME = new_db2 语句，即可修改数据库名称。*/
ALTER DATABASE db2
	SET SINGLE_USER
GO
ALTER DATABASE db2
	MODIFY NAME = new_db2
GO
ALTER DATABASE new_db2
	SET MULTI_USER
GO

--另一种修改数据库名称的方法sp_renamedb
EXEC sp_renamedb 'new_db2','db2' 


--收缩数据库new_db2，使文件有10%的可用空间
DBCC SHRINKDATABASE (db2,10)
GO

--删除数据库db1
CREATE DATABASE db1
GO
DROP DATABASE db1
GO


--从当前服务器分离数据库new_db2
--如果当前数据库为new_db2则会分离失败，所以分离前先把当前数据库设为master
USE master
EXEC sp_detach_db 'db2'
GO

--将数据库new_db2附加到当前服务器实例，并将数据库命名为db2
CREATE DATABASE db2
	ON
	( NAME = db2_data,
	FILENAME = 'd:\sqldb\data\db2_data.mdf')
	FOR ATTACH
GO


--创建别名数据类型name，基于系统数据类型varchar（10），允许空值
USE student
GO
CREATE TYPE name
	FROM varchar(10) NULL
GO

--删除别名数据类型test
CREATE TYPE test
	FROM char(2) 
GO
DROP TYPE test
GO


--创建学生表student，表结构如图4-9，不包含约束信息
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

--创建带有标识列，计算列的表，表名为compute_table
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


--查看表compute_table的结构
USE student
GO
EXEC sp_help 'compute_table'
GO

--修改表student，增加两列st_nation ,st_native
USE student
GO
ALTER TABLE student
 ADD
	st_nation char(2) NULL,
	st_native char(2) NULL
GO


--重命名表compute_table的名称，新的名称为new_compute
USE student
GO
EXEC sp_rename 'compute_table','new_compute'
GO 


--删除表new_compute
USE student
GO
DROP TABLE new_compute
GO


--向表student中插入一条记录，该记录对应表中的所有列
USE student
GO
INSERT INTO student(st_id, st_name, st_birth ,st_gender, st_address, st_tel, st_clid)
	VALUES('2005010101','王辰','1998-10-10','女','北京市朝阳区','84981234','01')
GO

--向表student中插入一条记录，该记录对应表中的相应列
USE student
GO
INSERT INTO student(st_id, st_name, st_birth ,st_gender, st_clid)
	VALUES('2005010102','张意','1989-12-1','男','01')
GO


--插入多行记录,即把表student中的st_id，st_name列插入到另一个表kaoping_table中
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


--更新表中的一行记录
USE student
GO
UPDATE student
	SET st_birth = '1989-10-10',st_tel = '010_84981234'
	WHERE st_id = '2005010101'
GO

--更新表中的所有记录
USE student
GO
UPDATE student
	SET st_address = '北京市海淀区'
GO


--删除表kaoping_table中的所有记录
USE student
GO
DELETE FROM kaoping_table
GO


--对学号列st_id定义主键约束
USE student
GO
ALTER TABLE student
	ADD CONSTRAINT pk_stid PRIMARY KEY(st_id)
GO

--创建表dept，并定义主键约束和惟一键约束信息
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

--创建表class
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

--对所属班号列st_clid定义外键约束
USE student
GO
ALTER TABLE student
	ADD CONSTRAINT fk_student_class FOREIGN KEY (st_clid) REFERENCES class (cl_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
GO


--定义主键约束和检查约束信息
USE student
GO
CREATE TABLE course
(
	cr_id char(6) PRIMARY KEY,
	cr_name varchar(30) NOT NULL,
	cr_type char(4) NULL CHECK(cr_type = '考试' or cr_type = '考核'),
	cr_time int NULL
)
GO

--定义主键约束、检查约束和默认约束信息
USE student
GO
CREATE TABLE teacher
(
	th_id char(6) PRIMARY KEY,
	th_name varchar(10) NOT NULL,
	th_gender char(2) NULL CHECK(th_gender = '男' or th_gender = '女'),
	th_position char(6) NULL,
	th_type char(4) NULL DEFAULT '专职'
)
GO

--创建表score，不包含约束信息；
--修改表score，添加约束信息；
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


--创建表schedule,包含约束信息
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


--创建磁盘备份设备，逻辑名称为student_backup1
EXEC sp_addumpdevice 'disk','student_backup1','d:\sqlbackup\student_backup1.bak'
GO


--对数据库student进行完整备份，将备份存储于备份设备student_backup1中
--备份前先把恢复模式改为完整
USE student
GO
BACKUP DATABASE student TO student_backup1
WITH  NAME = 'student完整备份'
GO


--创建磁盘备份设备，逻辑名称为stlog_backup1
EXEC sp_addumpdevice 'disk','stlog_backup1','d:\sqlbackup\stlog_backup1.bak'
GO

--查看所有备份设备
SELECT * FROM sys.backup_devices
GO


--向表student中插入三条记录；
--对表student进行差异备份，将备份存储于备份设备student_backup1中，并将本次备份追加到介质的现有数据之后
USE student
GO
INSERT INTO student(st_id, st_name, st_birth, st_gender, st_address, st_tel, st_clid)
VALUES('2005010202','李六','1989-12-9','男','北京市东城区','13112222678','01')
GO
BACKUP DATABASE student TO student_backup1
WITH DIFFERENTIAL, NAME = 'student差异备份'
GO


--执行事务日志备份
BACKUP LOG student TO stlog_backup1
WITH NAME='student事务日志备份'
GO


--还原数据库
--1)还原完整备份
RESTORE DATABASE student
	FROM student_backup1
	WITH FILE=1,NORECOVERY,REPLACE
GO
--2)还原差异备份
RESTORE DATABASE student
	FROM student_backup1
	WITH FILE=2,NORECOVERY
GO
--3)还原事务日志备份
RESTORE DATABASE student
	FROM stlog_backup1
	WITH FILE=1,RECOVERY,REPLACE
GO



--声明两个局部变量，赋值并显示信息
USE student
GO
DECLARE @num int,@gender char(2)
SET @gender='男'
SELECT @num=count(*) FROM student WHERE st_gender=@gender
PRINT '性别' + @gender + '的人数是：' + convert(char(4),@num)
GO


--显示全局变量@@CONNECTIONS 的值
SELECT @@CONNECTIONS AS '连接次数'
GO


--使用CEILING(),FLOOR(),ROUND(),RAND()函数，并显示返回值
SELECT ceiling(12.345) AS 最小整数, floor(12.345) AS 最大整数, round(12.345,2) AS 近似整数, rand() AS 随机数
GO

--调用SUBSTRING(),STUFF(),LEN(),REVERSE()函数，并显示返回值
SELECT substring('abcdef',2,2) AS 子字符串, stuff('abcdef',2,2,'123') AS 替换字符串, 
len('abcdef') AS 字符串长度, reverse('abcdef') AS 反向字符串
GO

--调用GETDATE(),DATEADD(),DATEDIFF(),DATENAME(),DATEPART()函数，并显示返回值
SELECT getdate() AS 系统日期, dateadd(dd,10,getdate()) AS 后十日日期,
datediff(dd,'2009-1-1',getdate()) AS 相差天数,
datename(weekday,getdate()) AS 星期, datepart(yy,getdate()) AS 系统年份
GO

--调用CAST(),CONVERT()函数，并显示返回值
SELECT cast(getdate() AS varchar(30)) AS 日期时间, convert(varchar(30),getdate(),120) AS 日期时间,
convert(varchar(30),getdate(),108) AS 时间, convert(varchar(30),getdate(),111) AS 日期
GO


--调用DB_ID(),CURRENT_USER(),ISDATE(),ISNULL()函数，并显示返回值
SELECT db_id('studnet') AS 数据库ID,current_user AS 数据库用户, isdate(getdate()) AS 日期判断,
 isnull(NULL,'IS NULL') AS 空值判断
GO


--用户定义函数
--创建一个标量函数func_age,输入出生日期，返回年龄值；调用函数func_age，显示返回值
USE student
GO
--1)创建标量函数
CREATE FUNCTION func_age
	(@var_birth datetime)
	RETURNS int
AS
	BEGIN
		RETURN datediff(yy,@var_birth,getdate())
	END
GO
--2)使用标量函数
SELECT dbo.func_age('1997-1-10') AS '年龄'
GO



--判断一个整型变量的值。
--如果为空，显示‘value is null’；
--否则，显示该变量的值
DECLARE @var_a int
IF @var_a is null
	PRINT 'value is null'
ELSE
	PRINT CONVERT(varchar(10),@var_a)
GO


--计算并1+2+3+4+······+100的值
DECLARE @i int, @sum int
SET @i=1
SET @sum=0
WHILE @i<=100
	BEGIN
		SET @sum=@sum+@i
		SET @i=@i+1
	END
PRINT '1+2+3+4+······+100的结果为：'+ CONVERT(varchar(6),@sum)
GO


--检索表student，查询所有学生的学号和姓名
USE student
GO
SELECT st_id,st_name FROM student
GO

--检索表student，查询所有学生的学号和姓名和电话，并加入常量列
--常量列“please call”
USE student
GO
SELECT st_id,st_name,'please call:',st_tel FROM student
GO

--检索表student，查询所有学生的详细信息
--*
USE student
GO
SELECT * FROM student
GO

--检索表student，查询所有学生的学号和姓名和年龄，并用中文指定各列名
--三种形式如下：
--列名 AS 别名
--列名 别名
--别名 = 列明
USE student
GO
SELECT st_id AS 学号,st_name 姓名,年龄 = dbo.func_age(st_birth) FROM student
GO

--检索表student，查询所有学生所属的系号
--DISTINCT消除重复行
USE student
GO
--1)结果集包含重复行
SELECT substring(st_id,5,2) AS 系号 FROM student
GO
--2)结果集消除重复行
SELECT DISTINCT substring(st_id,5,2) AS 系号 FROM student
GO

--检索表student，查询前两名学生的详细信息
--TOP
USE student
GO
SELECT TOP 2 * FROM student
GO

--检索表student，查询前50%学生的详细信息
-- PERCENT
USE student
GO
SELECT TOP 50 PERCENT * FROM student
GO

--检索表student，查询男生的详细信息
--WHERE
USE student
GO
SELECT * FROM student
	WHERE st_gender='男'
GO

--检索表student，查询1989年出生的学生的详细信息
--方法1
--BETWEEN···AND···(范围)
USE student
GO
SELECT * FROM student
	WHERE st_birth BETWEEN '1989-1-1' AND '1989-12-31'
GO
--方法2
--AND(逻辑运算)
SELECT * FROM student
	WHERE st_birth >= '1989-1-1' AND st_birth <='1989-12-31'
GO


--检索表student，查询01,02,03班学生的详细信息
--方法1
--IN(列表)
USE student
GO
SELECT * FROM student
	WHERE st_clid IN ('01','02','03')
GO
--方法2
--OR(逻辑运算)
USE student
GO
SELECT * FROM student
	WHERE st_clid = '01' OR st_clid = '02' OR st_clid = '03'
GO



--检索表student，查询姓王的学生的详细信息
--LIKE(匹配模式)
USE student
GO
SELECT * FROM student
	WHERE st_name LIKE '王%'
GO

--检索表student，查询2005~2008年入学的学生的详细信息
--LIKE(匹配模式)
USE student
GO
SELECT * FROM student
	WHERE substring(st_id,1,4) LIKE '200[5-8]'
GO

--检索表student，查询电话中含有下划线_的学生的详细信息
--ESCAPE(转义) ,将a后面的字符转义
USE student
GO
SELECT * FROM student
	WHERE st_tel LIKE '%a_%' ESCAPE 'a'
GO

--检索表student，查询家庭地址为空的学生的详细信息
--IS NULL(判断非空)
USE student
GO
SELECT * FROM student
	WHERE st_address IS NULL
GO

--检索表score，查询选修了课程号为'c01001'的学生的学号及成绩，并安装成绩降序排序显示前三行记录
--ORDER BY(排序) 和 DESC(降序)
USE student
GO
SELECT TOP 3 sc_stid,sc_grade FROM score
	WHERE sc_crid = 'c01001' 
	ORDER BY sc_grade DESC
GO

--检索表score，查询记录数
--COUNT() (一列中的总行数)
USE student
GO
SELECT COUNT(*) AS 记录数 FROM student
GO

--检索表score，查询选修了课程号'c01001'的学生人数，总成绩，平均成绩，最高成绩和最低成绩
--SUM()(一列中值的总和),AVG()(一列中的平均值),MAX()(一列中的最大值),MIN()(一列中的最小值)
USE student
GO
SELECT COUNT(sc_stid) AS 学生人数, SUM(sc_grade) AS 总成绩, AVG(sc_grade) AS 平均成绩,
 MAX(sc_grade) AS 最高成绩, MIN(sc_grade) AS 最低成绩 FROM score
	WHERE sc_crid = 'c01001'
GO

--检索表score，按课程号进行分组，查询各门课程的课程号、上课人数及平均成绩
--GROUP BY(分组)
USE student
GO
SELECT sc_crid AS 课程号, COUNT(sc_stid) AS 上课人数, AVG(sc_grade)AS 平均成绩 FROM score
	GROUP BY sc_crid
GO

--检索表score，按课程号进行分组，查询上课人数多于2人的各门课程的课程号、上课人数及平均成绩
--GROUP BY(分组) 和 HAVING(条件查询)
USE student
GO
SELECT sc_crid AS 课程号, COUNT(sc_stid) AS 上课人数, AVG(sc_grade) AS 平均成绩 FROM score
	GROUP BY sc_crid
	HAVING COUNT(sc_stid) > 2
GO

--检索表score，查询课程号、学号、成绩的明细并进行汇总上课人数和平均成绩
--COMPUTE(查询明细)
USE student
GO
SELECT * FROM score
	COMPUTE COUNT(sc_stid), AVG(sc_grade)
GO

--检索表score，按照课程号分组，查询各组的课程号、学号、成绩的明细行并汇总上课人数和平均成绩
USE student
GO
SELECT * FROM score
	ORDER BY sc_crid
	COMPUTE COUNT(sc_stid), AVG(sc_grade) BY sc_crid
GO

--对表dept和表class进行交叉联接，查询两个表中的所有列
--CROSS JOIN(交叉联接)
USE student
GO
SELECT dept.*, class.*
FROM dept CROSS JOIN class
GO

--对表class和表student进行等值联接，查询包含学生的班级及其学生信息，即返回两个表的所有列
--方法1
--JOIN
USE student
GO
SELECT * FROM class JOIN student
ON class.cl_id = student.st_clid
GO

--方法2
--自然联接查询
USE student
GO
SELECT class.* ,student.st_id ,student.st_name ,student.st_birth , student.st_gender ,student.st_address ,student.st_tel ,student.st_clid
FROM class JOIN student
ON class.cl_id = student.st_clid
GO


--对表class和表student进行左外联接，查询没有学生的班级信息
USE student
GO
SELECT class.* FROM class LEFT JOIN student
	ON class.cl_id = student.st_clid
	WHERE student.st_id IS NULL
GO


--对表student进行自联接，查询与学号为'2005010101'在同一个班级的学生的学号和姓名
USE student
GO
SELECT student2.st_id,student2.st_name
FROM student AS student1 JOIN student AS student2
ON student1.st_clid = student2.st_clid
WHERE student1.st_id = '2005010101' AND student2.st_id <> '2005010101'
GO


--对表student、表course、表score进行等值联接，查询学生的姓名、选修的课程名以及所取得的成绩
--方法1
USE student
GO
SELECT student.st_name,course.cr_name,score.sc_grade
FROM student JOIN score 
ON student.st_id = score.sc_stid
JOIN course ON course.cr_id = score.sc_crid
GO

--方法2
USE student
GO
SELECT student.st_name,course.cr_name,score.sc_grade
FROM student,course,score
WHERE student.st_id = score.sc_stid AND course.cr_id = score.sc_crid
GO


--对两个SELECT语句进行联合查询。第一个查询表student，查询学生的学号，姓名；第二个查询表teacher，查询教师的编号，姓名
--方法1
USE student
GO
SELECT st_id AS 人员编号, st_name AS 人员姓名 FROM student
UNION
SELECT th_id ,th_name FROM teacher
ORDER BY st_name
GO

--方法2
USE student
GO
SELECT st_name
FROM student
WHERE st_clid = (SELECT st_clid FROM student WHERE st_id = '2005010101') AND st_id <> '2005010101'
GO


--检索表class，表student，查询班名为'05网络1班'的学生的详细信息
--方法1
USE student
GO
SELECT *
FROM student
WHERE st_clid = (SELECT cl_id FROM class WHERE cl_name = '05网络1班')
GO

--方法2
USE student
GO
SELECT *
FROM student JOIN class
ON student.st_clid = class.cl_id
WHERE class.cl_name = '05网络1班'
GO


--检索表student、表score，查询班号为'01' 的学生成绩的详细信息
--IN子查询
USE student
GO
SELECT * FROM score
WHERE sc_stid IN (SELECT st_id FROM student WHERE st_clid = '01')
GO

--检索表class、表student，判断是否存在包含学生的班级，如果不存在，则返回不包含学生的班级的详细信息
USE student
GO
SELECT * FROM class
WHERE NOT EXISTS (SELECT * FROM student WHERE student.st_clid = class.cl_id)
GO