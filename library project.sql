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
--创建书籍类别表
CREATE TABLE 书籍类别
(
种类编号 char(20) NOT NULL PRIMARY KEY,
种类名称 char(20) NOT NULL UNIQUE
)
GO
--创建借阅者表
CREATE TABLE 借阅者
(
借书证编号 char(20) NOT NULL PRIMARY KEY,
借阅者姓名 char(20) NOT NULL,
借阅者性别 char(20) NULL CHECK(借阅者性别='男' OR 借阅者性别='女'),
借阅者种类 char(20) NULL CHECK(借阅者种类='学生' OR 借阅者种类='老师'),
登记日期 datetime NULL
)
--创建书籍表
CREATE TABLE 书籍
(
书籍编号 char(20) NOT NULL PRIMARY KEY,
书籍名称 char(20) NULL,
种类编号 char(20) NOT NULL REFERENCES 书籍类别(种类编号),
书籍作者 char(20) NULL,
是否被借 char(8) NOT NULL CHECK(是否被借='是' OR 是否被借='否')
)
--创建书籍流通表
CREATE TABLE 书籍流通
(
借书证编号 char(20) NOT NULL,
书籍名称 char(20) NOT NULL,
流通类型 char (20) NOT NULL CHECK(流通类型='借' OR 流通类型='还'),
流通时间 datetime NOT NULL,
CONSTRAINT pk_shujiliutong PRIMARY KEY(借书证编号,书籍名称,流通类型)
)
--创建罚款别表
CREATE TABLE 罚款
(
借书证编号 char(20) NOT NULL,
流通时间 datetime NOT NULL,
流通类型 char(20) NOT NULL,
借阅者姓名 char(20) NULL,
书籍编号 char(20) NOT NULL REFERENCES 书籍(书籍编号)
CONSTRAINT pk_fakuan PRIMARY KEY(借书证编号,流通时间,流通类型)
)

USE library
GO
--向书籍类别表中插入数据
INSERT INTO 书籍类别 (种类编号,种类名称) VALUES ('b0001','管理类')
INSERT INTO 书籍类别 (种类编号,种类名称) VALUES ('b0002','历史类')
INSERT INTO 书籍类别 (种类编号,种类名称) VALUES ('b0003','法律类')
INSERT INTO 书籍类别 (种类编号,种类名称) VALUES ('b0004','农业类')
INSERT INTO 书籍类别 (种类编号,种类名称) VALUES ('b0005','军事类')
INSERT INTO 书籍类别 (种类编号,种类名称) VALUES ('b0006','文学类')
INSERT INTO 书籍类别 (种类编号,种类名称) VALUES ('b0007','艺术类')
INSERT INTO 书籍类别 (种类编号,种类名称) VALUES ('b0008','经济类')
INSERT INTO 书籍类别 (种类编号,种类名称) VALUES ('b0009','医学类')
--向借阅者表中插入数据
INSERT INTO 借阅者 (借书证编号,借阅者姓名,借阅者性别,借阅者总类,登记日期) VALUES (07150201,'何康健','男','学生',2015/9/12)
INSERT INTO 借阅者 (借书证编号,借阅者姓名,借阅者性别,借阅者总类,登记日期) VALUES (07150202,'周浩城','男','学生',2015/9/13)
INSERT INTO 借阅者 (借书证编号,借阅者姓名,借阅者性别,借阅者总类,登记日期) VALUES (07150203,'苏进城','男','学生',2015/9/14)
INSERT INTO 借阅者 (借书证编号,借阅者姓名,借阅者性别,借阅者总类,登记日期) VALUES (07150204,'林浩彬','男','学生',2015/9/15)
INSERT INTO 借阅者 (借书证编号,借阅者姓名,借阅者性别,借阅者总类,登记日期) VALUES (07150205,'吴志盛','男','学生',2015/9/16)
INSERT INTO 借阅者 (借书证编号,借阅者姓名,借阅者性别,借阅者总类,登记日期) VALUES (07150206,'张建鑫','女','学生',2015/9/17)
INSERT INTO 借阅者 (借书证编号,借阅者姓名,借阅者性别,借阅者总类,登记日期) VALUES (07150207,'郭晓志','女','学生',2015/9/18)
INSERT INTO 借阅者 (借书证编号,借阅者姓名,借阅者性别,借阅者总类,登记日期) VALUES (07150208,'刘卓华','男','教师',2012/9/1)
INSERT INTO 借阅者 (借书证编号,借阅者姓名,借阅者性别,借阅者总类,登记日期) VALUES (07150209,'李志杰','男','教师',2012/9/2)
--向书籍表中插入数据
INSERT INTO 书籍 (书籍编号,书籍名称,种类编号,书籍作者,是否被借) VALUES ('s0001','文学回忆录','b0006','陈丹青','否')
INSERT INTO 书籍 (书籍编号,书籍名称,种类编号,书籍作者,是否被借) VALUES ('s0002','中国文学史','b0006','叶龙','否')
INSERT INTO 书籍 (书籍编号,书籍名称,种类编号,书籍作者,是否被借) VALUES ('s0003','丝绸之路','b0002','彼得','否')
INSERT INTO 书籍( 书籍编号,书籍名称,种类编号,书籍作者,是否被借) VALUES ('s0004','阿米巴经营','b0001','稻盛和夫','否')
INSERT INTO 书籍 (书籍编号,书籍名称,种类编号,书籍作者,是否被借) VALUES ('s0005','山海经','b0007','陈丝雨','否')
INSERT INTO 书籍 (书籍编号,书籍名称,种类编号,书籍作者,是否被借) VALUES ('s0006','思考中医','b0009','刘立红','否')
INSERT INTO 书籍 (书籍编号,书籍名称,种类编号,书籍作者,是否被借) VALUES ('s0007','犯罪心理学','b0003','巴特农','否')
INSERT INTO 书籍 (书籍编号,书籍名称,种类编号,书籍作者,是否被借) VALUES ('s0008','全息自然农法实践','b0004','何以农','否')
INSERT INTO 书籍 (书籍编号,书籍名称,种类编号,书籍作者,是否被借) VALUES ('s0009','孙子兵法','b0005','孙武','否')
--向书籍流通表中插入数据
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150201,'s0009','借',2015/10/1)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150202,'s0008','借',2015/10/2)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150203,'s0007','借',2015/10/3)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150204,'s0006','借',2015/10/4)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150201,'s0009','还',2016/12/1)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150202,'s0008','还',2016/12/2)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150203,'s0007','还',2015/12/3)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150204,'s0006','还',2015/12/4)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150205,'s0005','借',2015/10/5)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150206,'s0004','借',2015/10/6)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150207,'s0003','借',2015/10/7)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150208,'s0002','借',2015/10/8)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150209,'s0001','借',2015/10/9)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150205,'s0005','还',2015/12/5)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150206,'s0004','还',2015/12/6)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150207,'s0003','还',2015/12/7)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150208,'s0002','还',2015/12/8)
INSERT INTO 书籍流通 (借书证编号,书籍编号,流通类型,流通时间) VALUES (07150209,'s0001','还',2015/12/9)
--向罚款表中插入数据
INSERT INTO 罚款 (借书证编号,流通时间,流通类型,借阅者姓名,书籍编号) VALUES (07150201,2015/10/1,'借','何康健','s0009')
INSERT INTO 罚款 (借书证编号,流通时间,流通类型,借阅者姓名,书籍编号) VALUES (07150202,2015/10/2,'借','周浩城','s0008')
GO

