---
title: java编程思想第四版第十三章读书笔记
comments: true
date: 2019-01-20 13:56:33
tags:
- 书籍
- java
- java编程思想第四版
categories:
- 书籍
- java
- java编程思想第四版
---
# 前言
最近一段时间重读了java编程思想，把一些东西重新理解记录一遍
# 目的
整理知识点，方便以后回顾，这一章主要讲解了java的字符串
<!-- more -->
# 正文
#### 1.字符串
字符串的操作是计算机程序设计中最常见的行为。
关键词： StringBuilder ，StringBuffer，toString()，format转换，正则表达式

#### 2.不可变String
String对象时不可变的。每当把String对象作为方法的参数时，都会复制一份引用。（其实就是对函数中参数列表中参数的操作不会影响外面的原参数）

#### 3.重载“+”与StringBuilder
用于String的“+”与“+=”是Java中仅有的两个重载过的操作符，而Java并不允许程序员重载任何操作符。
在使用"+"操作符时，编译器自动引入了java.lang.StringBuilder类，避免了连加情况下产生大量需要回收的垃圾（每+一次就会产生一个新的字符串）。
因此，当为一个类编写toString()方法时，如果字符串操作简单，可以信赖编译器，它会为你合理的构造最终字符串结果。但是如果要在toString()中使用循环，那么最好自己创建一个StringBuilder对象，结合append()用它来构造最终结果。
StringBuilder提供了丰富而全面的方法，包括insert()、replace()、subString()甚至reverse()，但最常用的还是append()和toString()，delete()方法。
StringBuilder是Java SE5引入的，在这之前还有Java的StringBuffer。StringBuffer是线程安全的，因此开销会大一些。StringBuilder字符串操作会更快一些。

#### 4.无意识的递归
如果希望toString()方法打印出对象的内存地址，不可以使用this关键字。如果这样写
```
public String toString() {
return " InfiniteRecursion address: " + this + "\n";
}
```
编译器会试图将"+"后面的this转换为String，此时调用toString()函数，导致无穷递归。因此如果想要打印出内存地址，应该调用Object.toString()方法，所以调用super.toString()就可以了
```
public String toString() {
return " InfiniteRecursion address: " + super.toString() + "\n";
}
```
结果是：
```
[ E02_RepairInfinite address: E02_RepairInfinite@3e25a5
, E02_RepairInfinite address: E02_RepairInfinite@19821f
, E02_RepairInfinite address: E02_RepairInfinite@addbf1
, E02_RepairInfinite address: E02_RepairInfinite@42e816
, E02_RepairInfinite address: E02_RepairInfinite@9304b1
, E02_RepairInfinite address: E02_RepairInfinite@190d11
, E02_RepairInfinite address: E02_RepairInfinite@a90653
, E02_RepairInfinite address: E02_RepairInfinite@de6ced
, E02_RepairInfinite address: E02_RepairInfinite@c17164
, E02_RepairInfinite address: E02_RepairInfinite@1fb8ee3
]
```

#### 5.String上的操作
String的一些基本方法:
一、构造函数
```
     String(byte[ ] bytes)：通过byte数组构造字符串对象。
     String(char[ ] value)：通过char数组构造字符串对象。
     String(Sting original)：构造一个original的副本。即：拷贝一个original。
     String(StringBuffer buffer)：通过StringBuffer数组构造字符串对象。
```
二、方法
```
1. char charAt(int index) ：取字符串中的某一个字符，其中的参数index指的是字符串中序数。字符串的序数从0开始到length()-1 。
    例如： String s = new String("abcdefghijklmnopqrstuvwxyz");
          System.out.println("s.charAt(5): " + s.charAt(5) );
          结果为： s.charAt(5): f
2. int compareTo(String anotherString) ：当前String对象与anotherString比较。相等关系返回０；不相等时，从两个字符串第0个字符开始比较，返回第一个不相等的字符差，另一种情况，较长字符串的前面部分恰巧是较短的字符串，返回它们的长度差。
3. int compareTo(Object o) ：如果o是String对象，和2的功能一样；否则抛出ClassCastException异常。
    例如:   String s1 = new String("abcdefghijklmn");
           String s2 = new String("abcdefghij");
           String s3 = new String("abcdefghijalmn");
           System.out.println("s1.compareTo(s2): " + s1.compareTo(s2) ); //返回长度差
           System.out.println("s1.compareTo(s3): " + s1.compareTo(s3) ); //返回'k'-'a'的差
           结果为：s1.compareTo(s2): 4
                  s1.compareTo(s3): 10
4. String concat(String str) ：将该String对象与str连接在一起。
5. boolean contentEquals(StringBuffer sb) ：将该String对象与StringBuffer对象sb进行比较。
6. static String copyValueOf(char[] data) ：
7. static String copyValueOf(char[] data, int offset, int count) ：这两个方法将char数组转换成String，与其中一个构造函数类似。
8. boolean endsWith(String suffix) ：该String对象是否以suffix结尾。
    例如：  String s1 = new String("abcdefghij");
           String s2 = new String("ghij");
           System.out.println("s1.endsWith(s2): " + s1.endsWith(s2) );
           结果为：s1.endsWith(s2): true
9. boolean equals(Object anObject) ：当anObject不为空并且与当前String对象一样，返回true；否则，返回false。
10. byte[] getBytes() ：将该String对象转换成byte数组。
11. void getChars(int srcBegin, int srcEnd, char[] dst, int dstBegin) ：该方法将字符串拷贝到字符数组中。其中，srcBegin为拷贝的起始位置、srcEnd为拷贝的结束位置、字符串数值dst为目标字符数组、dstBegin为目标字符数组的拷贝起始位置。
     例如： char[] s1 = {'I',' ','l','o','v','e',' ','h','e','r','!'};//s1=I love her!
           String s2 = new String("you!"); s2.getChars(0,3,s1,7); //s1=I love you!
           System.out.println( s1 );
           结果为：I love you!
12. int hashCode() ：返回当前字符的哈希表码。
13. int indexOf(int ch) ：只找第一个匹配字符位置。
14. int indexOf(int ch, int fromIndex) ：从fromIndex开始找第一个匹配字符位置。
15. int indexOf(String str) ：只找第一个匹配字符串位置。
16. int indexOf(String str, int fromIndex) ：从fromIndex开始找第一个匹配字符串位置。
      例如：   String s = new String("write once, run anywhere!");
              String ss = new String("run");
              System.out.println("s.indexOf('r'): " + s.indexOf('r') );
              System.out.println("s.indexOf('r',2): " + s.indexOf('r',2) );
              System.out.println("s.indexOf(ss): " + s.indexOf(ss) );
              结果为：s.indexOf('r'): 1
                     s.indexOf('r',2): 12
                     s.indexOf(ss): 12
17. int lastIndexOf(int ch)
18. int lastIndexOf(int ch, int fromIndex)
19. int lastIndexOf(String str)
20. int lastIndexOf(String str, int fromIndex) 以上四个方法与13、14、15、16类似，不同的是：找最后一个匹配的内容。
        public class CompareToDemo {
              public static void main (String[] args) {
                   String s1 = new String("acbdebfg");
              
                   System.out.println(s1.lastIndexOf((int)'b',7));
             }
        }
        运行结果：5
（其中fromIndex的参数为 7，是从字符串acbdebfg的最后一个字符g开始往前数的位数。既是从字符c开始匹配，寻找最后一个匹配b的位置。所以结果为 5）
21. int length() ：返回当前字符串长度。
22. String replace(char oldChar, char newChar) ：将字符号串中第一个oldChar替换成newChar。
23. boolean startsWith(String prefix) ：该String对象是否以prefix开始。
24. boolean startsWith(String prefix, int toffset) ：该String对象从toffset位置算起，是否以prefix开始。
        例如：String s = new String("write once, run anywhere!");
             String ss = new String("write");
             String sss = new String("once");
             System.out.println("s.startsWith(ss): " + s.startsWith(ss) );
             System.out.println("s.startsWith(sss,6): " + s.startsWith(sss,6) );
             结果为：s.startsWith(ss): true
                    s.startsWith(sss,6): true
25. String substring(int beginIndex) ：取从beginIndex位置开始到结束的子字符串。
26.String substring(int beginIndex, int endIndex) ：取从beginIndex位置开始到endIndex位置的子字符串。
27. char[ ] toCharArray() ：将该String对象转换成char数组。
28. String toLowerCase() ：将字符串转换成小写。
29. String toUpperCase() ：将字符串转换成大写。
        例如：String s = new String("java.lang.Class String");
             System.out.println("s.toUpperCase(): " + s.toUpperCase() );
             System.out.println("s.toLowerCase(): " + s.toLowerCase() );
             结果为：s.toUpperCase(): JAVA.LANG.CLASS STRING
                    s.toLowerCase(): java.lang.class string
30. static String valueOf(boolean b)
31. static String valueOf(char c)
32. static String valueOf(char[] data)
33. static String valueOf(char[] data, int offset, int count)
34. static String valueOf(double d)
35. static String valueOf(float f)
36. static String valueOf(int i)
37. static String valueOf(long l)
38. static String valueOf(Object obj)
以上方法用于将各种不同类型转换成Java字符型。这些都是类方法。下面挑选一些上面常用的方法：
Java中String类的常用方法:
public char charAt(int index)
返回字符串中第index个字符；
public int length()
返回字符串的长度；
public int indexOf(String str)
返回字符串中第一次出现str的位置；
public int indexOf(String str,int fromIndex)
返回字符串从fromIndex开始第一次出现str的位置；
public boolean equalsIgnoreCase(String another)
比较字符串与another是否一样（忽略大小写）；
public String replace(char oldchar,char newChar)
在字符串中用newChar字符替换oldChar字符
public boolean startsWith(String prefix)
判断字符串是否以prefix字符串开头；
public boolean endsWith(String suffix)
判断一个字符串是否以suffix字符串结尾；
public String toUpperCase()
返回一个字符串为该字符串的大写形式；
public String toLowerCase()
返回一个字符串为该字符串的小写形式
public String substring(int beginIndex)
返回该字符串从beginIndex开始到结尾的子字符串；
public String substring(int beginIndex,int endIndex)
返回该字符串从beginIndex开始到endsIndex结尾的子字符串
public String trim()
返回该字符串去掉开头和结尾空格后的字符串
public String[] split(String regex)
将一个字符串按照指定的分隔符分隔，返回分隔后的字符串数组
```

#### 6.格式化的输出
Java SE5推出了格式化输出这一功能。如下：
printf()
printf()并不是用重载的“+”操作符来连接引号内的字符串，而是使用特殊的占位符来表示数据将来的位置。而且它还将插入格式化字符串的参数，以逗号分隔，排成一行。
```
printf("Row 1: [%d %f]\n", x, y);
```
这些占位符称作格式修饰符，它不但说明了插入位置，还说明了插入说明类型的变量，%d表示整数，%f表示浮点数，%s表示字符串。
System.out.format()
Java SE5引入的format方法可用于PrintStream或者PrintWriter对象。其中也包括System.out对象。
format()方法模仿自C的printf()，两者是等价的，以下展示三种方法输出坐标点：
```java
public class SimpleFormat {
public static void main(String[] args) {
int x = 5;
double y = 5.332542;
// The old way:
System.out.println("Row 1: [" + x + " " + y + "]");
// The new way:
System.out.format("Row 1: [%d %f]\n", x, y);
// or
System.out.printf("Row 1: [%d %f]\n", x, y);
}
} /* Output:
Row 1: [5 5.332542]
Row 1: [5 5.332542]
Row 1: [5 5.332542]
```
Formatter类
在Java中，所有新的格式化功能都有java.util.Formatter处理。Formatter构造器经过重载可以接受多种输出目的地，最常用的还是PrintStream()\OutputStream和File。
```java
import java.io.*;
import java.util.*;
public class Turtle {
private String name;
private Formatter f;
public Turtle(String name, Formatter f) {
this.name = name;
this.f = f;
}
public void move(int x, int y) {
f.format("%s The Turtle is at (%d,%d)\n", name, x, y);
}
public static void main(String[] args) {
PrintStream outAlias = System.out;
Turtle tommy = new Turtle("Tommy",
new Formatter(System.out));
Turtle terry = new Turtle("Terry",
new Formatter(outAlias));
tommy.move(0,0);
terry.move(4,8);
tommy.move(3,4);
terry.move(2,5);
tommy.move(3,3);
terry.move(3,3);
}
} /* Output:
Tommy The Turtle is at (0,0)
Terry The Turtle is at (4,8)
Tommy The Turtle is at (3,4)
Terry The Turtle is at (2,5)
Tommy The Turtle is at (3,3)
```
tommy输出到System.out中，terry输出到System.out的一个别名中
格式化说明符
为了在插入数据是控制空格和对齐，需要更加精细的格式修饰符。格式如下：
```
[argument_index$][flags][width][.precision]conversion
```
flags表示左右对齐，默认是右对齐，如果想左对齐就使用“-”标志
with控制最小尺寸（宽度）至少该这么长，不够用空格替代。
在with后面加上"."后面表示精度precision。
用于String（%s）时，表示最多可写的字符数
用于浮点数（%f）表示小数点后面的位数，多了舍入，少了补0，默认是6位
用于整数（%d）时,不可用于整数，会触发异常
```java
import java.util.*;

public class Receipt {
private double total = 0;
private Formatter f = new Formatter(System.out);
public void printTitle() {
f.format("%-15s %5s %10s\n", "Item", "Qty", "Price");  //Item项都有“-”，表示左对齐，其余项都是右对齐
f.format("%-15s %5s %10s\n", "----", "---", "-----");
}
public void print(String name, int qty, double price) {
f.format("%-15.15s %5d %10.2f\n", name, qty, price);    //name是左对齐并且最多15个字符，包括空格。price最多小数点后两位。
total += price;
}
public void printTotal() {
f.format("%-15s %5s %10.2f\n", "Tax", "", total*0.06);
f.format("%-15s %5s %10s\n", "", "", "-----");
f.format("%-15s %5s %10.2f\n", "Total", "",
total * 1.06);
}
public static void main(String[] args) {
Receipt receipt = new Receipt();
receipt.printTitle();
receipt.print("Jack’s Magic Beans", 4, 4.25);
receipt.print("Princess Peas", 3, 5.1);
receipt.print("Three Bears Porridge", 1, 14.29);
receipt.printTotal();
}
} /* Output:
Item Qty Price
---- --- -----
Jack’s Magic Be 4 4.25
Princess Peas 3 5.10
Three Bears Por 1 14.29
Tax 1.42
-----
Total 25.06
```
Formatter转换
常用的类型转换：
d 整型 (十进制)
c Unicode字符
b Boolean
sString
f 浮点型 (十进制)
e 浮点型(科学计数)
x 整数 (十六进制)
h 散列码(十六进制)
% 字符"%"
实例：
```
Formatter f = new Formatter(System.out);
char u = ‘a’;
f.format("c: %c\n", u);
f.format("b: %b\n", u);
```
所有类型变量都可以执行b转换，除了Boolean类型对应相应的true/false，其它的只要参数不为Null，结果永远是true。（参数为数字0，仍然是true，这点与C不同）
String.format()
String.format()是一个static方法，它接受与Formatter.format()方法一样的参数，但返回一个String对象。
如下所示：
```
String.format("(t%d, q%d) %s", transactionID,queryID, message)
```

#### 7.正则表达式
正则表达式是一个强大而灵活的文本处理工具。它提供可一种完全通用的方式，能够解决各种字符串处理相关的问题：匹配、选择、编辑和验证。
正则可以切分，替换，判断字符串，通过设定的regex规则。
在Java中，\\的意思是“我要插入一个正则表达式的反斜线，所以其后字符含有特殊意义”
```
\\d 表示一位数字
\\W 表示非单词字符
\\w 表示单词字符
\\\\ 表示普通反斜线
\n 换行符
\t 制表符
+ 一个或多个前一位的表达式
| 或者
? 可能有
\\+ 正号（加号在正则表达式中有特殊的意义，必须用\\将其转译为一个普通字符）
```
```java
public class IntegerMatch {
public static void main(String[] args) {
System.out.println("-1234".matches("-?\\d+"));  //可能以负号开头且后面跟着数字们
System.out.println("5678".matches("-?\\d+"));   
System.out.println("+911".matches("-?\\d+"));
System.out.println("+911".matches("(-|\\+)?\\d+"));  //可能以正负号开头且后面跟着数字们
}
} /* Output:
true
true
false
true
```
split()方法目标是“将字符串从正则表达式匹配的地方切开”
```java
//: strings/Splitting.java
import java.util.*;
public class Splitting {
public static String knights =
"Then, when you have found the shrubbery, you must " +
"cut down the mightiest tree in the forest... " +
"with... a herring!";
public static void split(String regex) {
System.out.println(
Arrays.toString(knights.split(regex)));
}
public static void main(String[] args) {
split(" "); // 从有空格处分开 
split("\\W+"); // 从有非单词字符处分开
split("n\\W+"); // 从“字符n后面跟了非单词字符”处分开
}
} /* Output:
[Then,, when, you, have, found, the, shrubbery,, you, must, cut, down,
the, mightiest, tree, in, the, forest..., with..., a, herring!]
[Then, when, you, have, found, the, shrubbery, you, must, cut, down,
the, mightiest, tree, in, the, forest, with, a, herring]
[The, whe, you have found the shrubbery, you must cut dow, the mightiest
tree i, the forest... with... a herring!]
```
String.split()还有个重载版本，允许限制字符串分隔次数。
String类自带“替换”正则表达式
```java
import static net.mindview.util.Print.*;
public class Replacing {
static String s = Splitting.knights;
public static void main(String[] args) {
print(s.replaceFirst("f\\w+", "located"));  //以f开头的单词换成Located
print(s.replaceAll("shrubbery|tree|herring","banana"));  //这几个单词的位置换成banana
}
} /* Output:
Then, when you have located the shrubbery, you must cut down the
mightiest tree in the forest... with... a herring!
Then, when you have found the banana, you must cut down the mightiest
banana in the forest... with... a banana!
```
创建正则表达式
B字符B
```
\xhh十六进制值为oxhh的字符
\uhhhh十六进制表示为0xhhhh的Unicode字符
\t制表符
\n换行符
\r回车符
\f转页符
\e转义符
```

字符类：
```
. 任意字符
[abc] 包含a、b、c的任何字符
[^abc] 除了a、b、c的任何字符
[a-zA-Z] 从a-z或者A-Z的所有字符
[abc[hij]] 包含a、b、c、h、i、j的所有字符
[a-z&&[hij]] 包含h、i、j（交集）
\s 空白符（空格、tab、换行、换页、回车）
\S 非空白符
\d 数字[0-9]
\D 非数字[^o-9]
\w 词字符[a-zA-Z_0-9]
\W 非词字符[^\w]
```
逻辑操作符：
```
XY X后面有Y
X|Y X或Y
(X) 捕获组。可以在表达式中用\i引用第i个捕获组
```

边界匹配符：
```
^一行的开始
$ 一行的结束
\b 单词的边界
\B 非单词的边界
\G 前一个匹配的结束
```
量词
量词描述一个模式吸收输入文本的方式：
贪婪型：
贪婪表达式会为所有可能的模式发现尽可能多的匹配。
勉强型：
用问号来指定，这个词量匹配满足模式所需的最少字符数。
占有型：
Java特有。当正则表达式被用于字符串时，它会产生相当多的状态，以便在匹配失败时可以回溯。而“占有的”词量并不保存这些中间状态，因此它们可以防止回溯。

| 贪婪型 | 勉强型 | 占有型 | 如何匹配 |
| ------ | ------ | ------ | ------ |
| X? | X??  | X?+ | 一个或0个X |
| X* | X*? | x*+ | 0个或者多个X |
| x+ | x+? | X++ | 一个或者多个X |
| X{n} | X{n}? | X{n}+ | 恰好n次X |
| X{n,} | X{n,}? | X{n,}+ | 至少n次X |
| X{n,m}  | X{n,m}? | X{n,m}+ | X至少n次，且不超过m次 |

接口CharSequence从CharBuffer、String、StringBuffer、StringBuilder类中抽象出字符序列的一般化定义
```java
interface CharSequence {
charAt(int i);
length();
subSequence(int start,int end);
toString();
}
```
这些类都实现了该接口

Parttern和Matcher
Parttern对象表示编译后的正则表达式。
1、导入java.util.regex包
2、用static Parttern.compile()方法来编译正则表达式。
3、使用已编译的Parttern对象上的matcher()方法，加上一个输入字符串，从而共同构造一个Matcher对象。它有很多功能可用。
```java
//{Args: abcabcabcdefabc "abc+" "(abc)+" "(abc){2,}" }
import java.util.regex.*;
import static net.mindview.util.Print.*;
public class TestRegularExpression {
public static void main(String[] args) {
if(args.length < 2) {
print("Usage:\njava TestRegularExpression " +
"characterSequence regularExpression+");
System.exit(0);
}
print("Input: \"" + args[0] + "\"");
for(String arg : args) {
print("Regular expression: \"" + arg + "\"");
Pattern p = Pattern.compile(arg);
Matcher m = p.matcher(args[0]);
while(m.find()) {
print("Match \"" + m.group() + "\" at positions " +
m.start() + "-" + (m.end() - 1));
}
}
}
} /* Output:
Input: "abcabcabcdefabc"
Regular expression: "abcabcabcdefabc"
Match "abcabcabcdefabc" at positions 0-14
Regular expression: "abc+"
Match "abc" at positions 0-2
Match "abc" at positions 3-5
Match "abc" at positions 6-8
Match "abc" at positions 12-14
Regular expression: "(abc)+"
Match "abcabcabc" at positions 0-8
Match "abc" at positions 12-14
Regular expression: "(abc){2,}"
Match "abcabcabc" at positions 0-8
```
使用Matcher上的方法，我们能够判断各种不同类型的匹配是否成功：
```
boolean matches()判断整个输入字符串是否匹配正则表达式，只有整个输入都匹配正则表达式时才会true
boolean lookingAt() 判断字符串的开始部分是否能匹配模式，只有输入的第一部分匹配才会true
boolean find() 在CharSequence中按照正则表达式查找多个匹配
boolean find(int start) 在指定位置查找多个匹配
```
```java
import java.util.regex.*;
import static net.mindview.util.Print.*;
public class Finding {
public static void main(String[] args) {
Matcher m = Pattern.compile("\\w+")    //模式\\w+将字符串划分为单词
.matcher("Evening is full of the linnet’s wings");
while(m.find())
printnb(m.group() + " ");
print();
int i = 0;
while(m.find(i)) {
printnb(m.group() + " ");
i++;
}
}
} /* Output:
Evening is full of the linnet s wings
Evening vening ening ning ing ng g is is s full full ull ll l of of f
the the he e linnet linnet innet nnet net et t s s wings wings ings ngs
gs s
```
组
组是用括号划分的正则表达式，组号为0表示整个正则表达式，组号为1表示第一队括号()括起的组，依次类推。
Matcher对象提供了一系列方法
```
public int groupCount() 返回该匹配器的模式中的分组数目,不包括第0组
public String group() 返回前一次匹配操作的第0组
public String group(int i) 返回前一次匹配操作指定的组号，如果匹配成功，但是指定的组没有匹配输入字符串的任何部分，则将返回null。
public int start(int group) 返回前一次匹配操作中寻找到的组的起始索引
public int end(int group) 返回前一次匹配操作中寻找到的组的最后一个字符索引+1的值
```
Pattern标记
Pattern类的compile()方法还有另一个版本，它接受一个标记参数，以调整匹配的行为。
Pattern Pattern.compile(String regex, int flag)
flag来自Pattern类中的常量，常用的有Pattern.CASE_INSENSITIVE,Pattern.MULTILINE, 以及 Pattern.COMMENTS
split()
spilit()方法将输入字符断开成字符串对象数组，断开边界由正则表达式确定。默认情况下是遇到空格切分的
```
String[] split(CharSequence input)  //通过正则表达式分隔input
String[] split(CharSequence input, int limit)   //通过正则表达式分隔input，分隔成limit个
```
```java
import java.util.regex.*;
import java.util.*;
import static net.mindview.util.Print.*;
public class SplitDemo {
public static void main(String[] args) {
String input =
"This!!unusual use!!of exclamation!!points";
print(Arrays.toString(
Pattern.compile("!!").split(input)));
// Only do the first three:
print(Arrays.toString(
Pattern.compile("!!").split(input, 3)));
}
} /* Output:
[This, unusual use, of exclamation, points]
[This, unusual use, of exclamation!!points]
```
替换操作
```
replaceFirst(String replacement) 用于替换第一个匹配成功的部分为字符串replacement
replaceAll(String replacement) 将匹配成功的所有部分替换为字符串replacement
appendReplacement(StringBuffer sbuf,String replacement)执行渐进式替换
appendTail(StringBuffer sbuf,String replacement)输入字符串余下部分复制到sbuf中
```
reset()
public Matcher reset()；  //这个方法将Matcher重置为最初的状态
正则表达式与Java I/O
可以讲正则表达式用于动态字符串，应有两个参数： 文件名和要匹配的正则表达式。  输出：匹配的部分和该部分所在行。
```java
//: strings/JGrep.java
// A very simple version of the "grep" program.
// {Args: JGrep.java "\\b[Ssct]\\w+"}
import java.util.regex.*;
import net.mindview.util.*;
public class JGrep {
public static void main(String[] args) throws Exception {
if(args.length < 2) {
System.out.println("Usage: java JGrep file regex");
System.exit(0);
}
Pattern p = Pattern.compile(args[1]);
// Iterate through the lines of the input file:
int index = 0;
Matcher m = p.matcher("");
for(String line : new TextFile(args[0])) {
m.reset(line);   //没有在循环里创建Matcher，性能提升
while(m.find())
System.out.println(index++ + ": " +
m.group() + ": " + m.start());
}
}
} /* Output: (Sample)
0: strings: 4
1: simple: 10
2: the: 28
3: Ssct: 26
4: class: 7
5: static: 9
6: String: 26
7: throws: 41
8: System: 6
9: System: 6
10: compile: 24
11: through: 15
12: the: 23
13: the: 36
14: String: 8
15: System: 8
16: start: 31
```

#### 8.扫描输入
input元素使用类来自java.io。
ReadLine()方法将一行输入转为String对象。
Java SE5新增了Scanner类（java.util.*），可以接受任何类型的输入对象，包括File对象，InputStream、String或者Readable对象。Readable时Java SE5新增的一个接口，具有read()方法。
使用Scanner，所有输入，粉刺，翻译的操作都隐藏在不同类型的next()中，比如nextInt()、nextDouble()，普通的next()方法方法返回下一个String。
所有基本类型都有next()方法，除了char类型，包括BigDecimal和BigInteger。
Scanner还有相应的hasNext方法，用以判断下一个输入分词是否是所需的类型。
Scanner可以自动吞IOException异常。
Scanner定界符
默认情况下，Scanner根据空白字符对输入进行分词，也可以用正则表达式指定定界符，利用函数scanner.useDelimiter(正则表达式)
```java
import java.util.*;
public class ScannerDelimiter {
public static void main(String[] args) {
Scanner scanner = new Scanner("12, 42, 78, 99, 42");
scanner.useDelimiter("\\s*,\\s*"); //,作为定界符，包括逗号前后的空格符
while(scanner.hasNextInt())
System.out.println(scanner.nextInt());
}
} /* Output:
12
42
78
99
42
```

用正则表达式扫描
除了能够扫描基本类型外，可能还想要扫描自定义的正则表达式。
```java
//: strings/ThreatAnalyzer.java
import java.util.regex.*;
import java.util.*;
public class ThreatAnalyzer {
static String threatData =
"58.27.82.161@02/10/2005\n" +
"204.45.234.40@02/11/2005\n" +
"58.27.82.161@02/11/2005\n" +
"58.27.82.161@02/12/2005\n" +
"58.27.82.161@02/12/2005\n" +
"[Next log section with different data format]";
public static void main(String[] args) {
Scanner scanner = new Scanner(threatData);
String pattern = "(\\d+[.]\\d+[.]\\d+[.]\\d+)@" +
"(\\d{2}/\\d{2}/\\d{4})";
while(scanner.hasNext(pattern)) {
scanner.next(pattern);
MatchResult match = scanner.match();
String ip = match.group(1);
String date = match.group(2);
System.out.format("Threat on %s from %s\n", date,ip);
}
}
} /* Output:
Threat on 02/10/2005 from 58.27.82.161
Threat on 02/11/2005 from 204.45.234.40
Threat on 02/11/2005 from 58.27.82.161
Threat on 02/12/2005 from 58.27.82.161
Threat on 02/12/2005 from 58.27.82.161
```
配合正则表达式扫描时，只针对下一个输入分词，如果正则表达式中含有定界符，则永远不可能匹配成功

#### 9.StringTokenizer
以前用StringTokenizer来分词，现在基本上已经废弃不用了。

# 参考资料
https://blog.csdn.net/severusyue/article/details/51784228  severusyue
