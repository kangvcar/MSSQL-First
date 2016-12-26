--�������ݿ�library
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
CREATE TABLE �鼮���
(
������ char(20) NOT NULL PRIMARY KEY,
�������� char(20) NOT NULL UNIQUE
)
GO

CREATE TABLE ������
(
����֤��� char(20) NOT NULL PRIMARY KEY,
���������� char(20) NOT NULL,
�������Ա� char(20) NULL CHECK(�������Ա�='��' OR �������Ա�='Ů'),
���������� char(20) NULL CHECK(����������='ѧ��' OR ����������='��ʦ'),
�Ǽ����� datetime NULL
)

CREATE TABLE �鼮
(
�鼮��� char(20) NOT NULL PRIMARY KEY,
�鼮���� char(20) NULL,
������ char(20) NOT NULL REFERENCES �鼮���(������),
�鼮���� char(20) NULL,
�Ƿ񱻽� char(8) NOT NULL CHECK(�Ƿ񱻽�='��' OR �Ƿ񱻽�='��')
)

CREATE TABLE �鼮��ͨ
(
����֤��� char(20) NOT NULL,
�鼮���� char(20) NOT NULL,
��ͨ���� char (20) NOT NULL CHECK(��ͨ����='��' OR ��ͨ����='��'),
��ͨʱ�� datetime NOT NULL,
CONSTRAINT pk_shujiliutong PRIMARY KEY(����֤���,�鼮����,��ͨ����)
)

CREATE TABLE ����
(
����֤��� char(20) NOT NULL,
��ͨʱ�� datetime NOT NULL,
��ͨ���� char(20) NOT NULL,
��������Ϣ char(20) NULL,
�鼮��� char(20) NOT NULL REFERENCES �鼮(�鼮���)
)


