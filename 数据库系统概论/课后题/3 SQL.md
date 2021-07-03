第3章 关系数据库标准语言SQL

[TOC]

NOT EXISTS 的用法我有点不明白



### 1 ．试述 sQL 语言的特点。

答：

(l）**综合统一**。 sQL 语言集数据定义语言 DDL 、数据操纵语言 DML 、数据控制语言 DCL 的功能于一体。

(2）**高度非过程化**。用 sQL 语言进行数据操作，只要提出“做什么”，而无需指明“怎么做”，因此无需了解存取路径，存取路径的选择以及 sQL 语句的操作过程由系统自动完成。 

(3）**面向集合的操作方式**。 sQL 语言采用集合操作方式，不仅操作对象、查找结果可以是元组的集合，而且一次插入、删除、更新操作的对象也可以是元组的集合。

(4）以同一种语法结构提供两种使用方式。

 sQL 语言既是自含式语言，又是嵌入式语言。作为自含式语言，它能够独立地用于联机交互的使用方式；作为嵌入式语言，它能够嵌入到高级语言程序中，供程序员设计程序时使用。

(5）语言简捷，易学易用。

 

### 2 ．试述 sQL 的定义功能。 

sQL 的数据定义功能包括<u>定义表、定义视图和定义索引</u>。

 SQL 语言使用 CREATE TABLE 语句建立基本表， ALTER TABLE 语句修改基本表定义， DROP TABLE 语句删除基本表；使用 CREATE INDEX 语句建立索引， DROP INDEX 语句删除索引；使用 CREATE VIEW 语句建立视图， DROP VIEW 语句删除视图。

 

### 3 ．用 sQL 语句建立第二章习题 5 中的 4 个表。

答：

对于 S 表： S ( SNO , SNAME , STATUS , CITY ) ; 

建 S 表：

  CREATE TABLE S ( Sno C(2) **UNIQUE**，Sname C(6) ，Status  C(2)，City C(4));

> 这里应该char(2) 这种定义方式，不要简写成 C(2)
>
> 为什么Sname不用 VARCHAR(6) 这么定义，名字有两个有三个字的呀？
>
> 一个中文字符需要两个Char

```SQL
//我的版本，这个NOT NULL 实在是可写可不写
CREATE TABLE S ( Sno char(2) UNIQUE NOT NULL，
                Sname varchar(6) ，
                Status  char(2)，
                City char(4)  );
```



对于 P 表： P ( PNO , PNAME , COLOR , WEIGHT );

建 P 表 ：

CREATE TABLE P(Pno  C(2)  **UNIQUE**，Pname  C(6)，COLOR  C(2)，  WEIGHT INT);

 

对于 J 表： J ( JNO , JNAME , CITY） ; 

建 J 表：

CREATE  TABLE  J(Jno  C(2) **UNlQUE，**JNAME  C(8)， CITY C(4))

 

对于 SPJ 表： sPJ ( sNo , PNo , JNo , QTY） ; 

建 SPJ 表：SPJ(SNO,PNO,JNO,QTY)

CREATE TABLE SPJ(Sno  C(2)，Pno  C(2)，JNO  C(2)，  QTY  INT))

> spj这个表就不用写unique了，蛮多都是外码。

 

### 4.  针对上题中建立的 4 个表试用 sQL 语言完成第二章习题 5 中的查询。 

 ( l ）求供应工程 Jl 零件的供应商号码 SNO ;

```sql
SELECT DISTINCT SNO //去重用distinct。
FROM SPJ 
WHERE  JNO=’J1’
```

 ( 2 ）求供应工程 Jl 零件 Pl 的供应商号码 SNO ; 

```sql
SELECT DISTINCT SNO
FROM SPJ 
WHERE JNO='J1' AND PNO='P1'
```

( 3 ）求供应工程 Jl 零件为红色的供应商号码 SNO ; 

```SQL
SELECT SNO //为何不用distinct,没道理啊。
FROM SPJ,P 
WHERE JNO='J1' AND SPJ.PNO=P.PNO AND COLOR='红'

//我的版本
SELECT DISTINCT SNO
FROM SPJ,P
WHERE SPJ.JNO='J1' AND
	  SPJ.PNO=P.PNO AND
	  P.COLOR='红'
//两点不同，一是有DISTINCT,二是多余的地方加了表限制，例如两表中只有SPJ有JNO那么就不需要加前面的限制,当然加了也可以，没问题

//或者用嵌套查询
SELECT Sno
FROM SPJ
WHERE Jno='J1' and Pno in
		(SELECT PNO
		 FORM P
         WHERE COLOR='红');
```

( 4 ）求没有使用天津供应商生产的红色零件的工程号 JNO ;

```sql
SELECT  DISTCT  JNO 
FROM SPJ  
WHERE JNO NOT IN (
    SELE JNO 
    FROM SPJ,P,S 
    WHERE S.CITY='天津' //city在这三个表中也只有一个啊，为啥加前缀？我觉得不加前缀也可以啊。
    		AND COLOR='红' 
    		AND S.SNO=SPJ.SNO  
    		AND P.PNO=SPJ.PNO);
    		
//另一种写法，用not exists
SELECT Jno
FROM J
WHERE NOT EXISTS(//这里not exists显然可以改成not in
		SELECT *
		FROM SPJ,S,P
		WHERE SPJ.JNO=J.JNO AND  //这一步不太懂，为啥要把J.NO牵扯进来，是为了得出true or false 然后得到答案？因为外层用的是J表？
  			  //上一句好像是为了和外层循环建立联系
    	      SPJ.SNO=S.SNO AND
    		  SPJ.PNO=P.PNO AND
    		  S.CITY='天津' AND
    		  P.color='红');
```

( 5 ）求至少用了供应商 Sl 所供应的全部零件的工程号 JNO ;

由于**VFP不允许子查询嵌套太深**，将查询分为两步

```sql
A、查询S1供应商供应的零件号

SELECT DIST PNO //应写DISTINCT 应该是教材老的关系。
FROM SPJ 
WHERE SNO='S1'

结果是（P1，P2）

B、查询哪一个工程既使用P1零件又使用P2零件。
SELECT JNO 
FROM SPJ 
WHERE PNO='P1' 
 	  AND JNO IN (SELECT JNO 
                  FROM SPJ 
                  WHERE PNO='P2')
```

> 然我来想也想不到更好的解决方法。看看网友怎么回答吧。

问题转化为：

不存在这样的零件y，供应商S1供应了y，而工程x未选用y
即对于所有的供应商SI供应的零件，某个工程全选用了。

```sql
SELECT DISTINCT JNO
FROM SPJ Z //这是起别名
WHERE NOT EXISTS
	(SELECT *
     FROM SPJ X
     WHERE SNO='S1' AND NOT EXISTS(
     		SELECT *
     		FROM SPJ Y
     		WHERE Y.PNO=X.PNO AND Y.JNO=Z.JNO)
    );
```



### 5．针对习题3中的四个表试用SQL语言完成以下各项操作：

(1)找出所有供应商的姓名和所在城市。

```sql
SELECT SNAME,CITY 
FROM S
```

(2)找出所有零件的名称、颜色、重量。

```sql
SELECT PNAME,COLOR,WEIGHT 
FROM P
```

(3)找出使用供应商S1所供应零件的工程号码。

```sql
SELECT  DIST JNO 
FROM SPJ 
WHERE SNO='S1'
```

(4)找出工程项目J2使用的各种零件的名称及其数量。

```sql
SELECT PNAME,QTY 
FROM SPJ,P 
WHERE P.PNO=SPJ.PNO AND SPJ.JNO='J2'
```

(5)找出上海厂商供应的所有零件号码。

```sql
SELECT PNO 
FROM SPJ,S 
WHERE S.SNO=SPJ.SNO AND CITY='上海'
//当然，用嵌套查询也可以
```

(6)出使用上海产的零件的工程名称。

> 上海产的，指的是上海供应的。要S表。

```sql
SELECT JNAME 
FROM SPJ,S,J
WHERE S.SNO=SPJ.SNO AND S.CITY='上海' AND J.JNO=SPJ.JNO

或

SELECT JNAME
FROM J
WHER JNO IN(   SELECT JNO
               FROM SPJ,S
               WHERE SPJ.SNO=S.SNO
                   AND S.CITY='上海');
```

(7)找出**没有使用天津产**的零件的工程项目号码。

> 供应商城市不是天津。

```sql
//适用于JNO是唯一或不唯一的情况。
SELECT DISTINCT JNO 
FROM SPJ  
WHERE JNO NOT IN 
    (SELECT DISTINCT JNO 
     FROM SPJ,S 
     WHERE S.SNO=SPJ.SNO AND S.CITY='天津') 


//<>这个符号是不等于
//适用于JNO是唯一的情况
//就是工程项目是唯一的情况，从书P81的J表上看，工程项目是唯一的。
SELECT DISTINCT JNO 
FROM SPJ,S 
WHERE S.SNO=SPJ.SNO AND S.CITY<>'天津'

//用exists解决
SELECT JNO
FROM J
WHERE NOT EXISTS
   (SELECT *
    FROM SPJ,S
    WHERE SPJ.JNO=J.JNO AND   //这个是为了和外层循环建立联系的
    	  SPJ.SNO=SPJ.SNO AND
    	  S.CITY='天津');
```

(8)把全部红色零件的颜色改成蓝色。

```sql
UPDATE P 
SET COLOR='蓝'  
WHERE COLOR='红'
```

(9)由S5供给J4的零件P6改为由S3供应。

```sql
UPDATE  SPJ  
SET SNO='S3' 
WHERE SNO='S5' AND JNO='J4' AND PNO='P6'
```

(10)从供应商关系中删除**供应商号是S2**的记录，并从供应情况关系中删除相应的记录。

```sql
DELETE  FROM  S  WHERE  SNO=’S2’
DELETE  FROM  SPJ  WHERE  SNO=‘S2’
```

(11)请将(S2，J6，P4，200)插入供应情况关系。

```sql
INSERT  INTO  SPJ  
VALUES（‘S2’，‘J6’，‘P4’，200）
```

 

### 6 ．什么是基本表？什么是视图？两者的区别和联系是什么？

答

基本表是本身独立存在的表，在 SQL 中一个关系就对应一个表。
视图是从一个或几个基本表导出的表。视图本身不独立存储在数据库中，是一个虚表。即数据库中只存放视图的定义而不存放视图对应的数据，这些数据仍存放在导出视图的基本表中。

视图在概念上与基本表等同，用户可以如同基本表那样使用视图，可以在视图上再定义视图。 

 

### 7 ．试述视图的优点。

答 

1. 视图能够简化用户的操作
2. 视图使用户能以多种角度看待同一数据
3. 视图对重构数据库提供了一定程度的逻辑独立性
4. 能够对机密数据提供安全保护

 

### 8 ．所有的视图是否都可以更新？为什么？

答:

不是。视图是不实际存储数据的虚表，因此对视图的更新，最终要转换为对基本表的更新。**因为有些视图的更新不能惟一有意义地转换成对相应基本表的更新，所以，并不是所有的视图都是可更新的.**

> 比如有的视图是取各列的平均值的，如果要改变平均值，那么不可能改变各列的值来是实现改变平均值。

 

### 9 ．哪类视图是可以更新的？哪类视图是不可更新的？各举一例说明。

答：

基本表的**行列子集视图**一般是可更新的。

若视图的属性来自集函数、表达式，则该视图肯定是不可以更新的。

 

### 10 ．试述某个你熟悉的实际系统中对视图更新的规定。

答

VFP

 

### 11．请为三建工程项目建立一个供应情况的视图，包括供应商代码(SNO)、零件代码(PNO)、供应数量(QTY)。

```sql
CREATE VIEW VSP 
AS //后面跟子查询。
    SELECT SNO,PNO,QTY 
    FROM SPJ,J 
    WHERE SPJ.JNO=J.JNO AND J.JNAME='三建'
```

针对该视图VSP完成下列查询：

(1)找出三建工程项目使用的各种零件代码及其数量。

```sql
SELECT DIST PNO,QTY 
FROM  VSP
```

(2)找出供应商S1的供应情况。

```sql
SELECT  DISTINCT * 
FROM VSP 
WHERE SNO='S1'
```

