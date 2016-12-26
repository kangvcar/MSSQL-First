--创建数据库library
CREATE DATABASE library
ON(
NAME = library_data,
FILENAME = 'd:\sqldb\data\library_data.mdf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 10%	
)
LOG ON
(
NAME = library_log,
FILENAME = 'd:\sqldb\data\library_log.ldf',
SIZE = 1,
MAXSIZE = UNLIMITED,
FILEGROWTH = 10%
)
GO

USE library
GO
CREATE TABLE 书籍类别
(
种类编号 char(20) NOT NULL PRIMARY KEY,
种类名称 char(20) NOT NULL UNIQUE
)
GO

CREATE TABLE 借阅者
(
借书证编号 char(20) NOT NULL PRIMARY KEY,
借阅者姓名 char(20) NOT NULL,
借阅者性别 char(20) NULL CHECK(借阅者性别='男' OR 借阅者性别='女'),
借阅者种类 char(20) NULL CHECK(借阅者种类='学生' OR 借阅者种类='老师'),
登记日期 datetime NULL
)

CREATE TABLE 书籍
(
书籍编号 char(20) NOT NULL PRIMARY KEY,
书籍名称 char(20) NULL,
种类编号 char(20) NOT NULL REFERENCES 书籍类别(种类编号),
书籍作者 char(20) NULL,
是否被借 char(8) NOT NULL CHECK(是否被借='是' OR 是否被借='否')
)

CREATE TABLE 书籍流通
(
借书证编号 char(20) NOT NULL,
书籍名称 char(20) NOT NULL,
流通类型 char (20) NOT NULL CHECK(流通类型='借' OR 流通类型='还'),
流通时间 datetime NOT NULL,
CONSTRAINT pk_shujiliutong PRIMARY KEY(借书证编号,书籍名称,流通类型)
)

CREATE TABLE 罚款
(
借书证编号 char(20) NOT NULL,
流通时间 datetime NOT NULL,
流通类型 char(20) NOT NULL,
借阅者信息 char(20) NULL,
书籍编号 char(20) NOT NULL REFERENCES 书籍(书籍编号)
)


