---
title: java编程思想第四版第十一章读书笔记
comments: true
date: 2019-01-18 00:01:31
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
整理知识点，方便以后回顾，这一章主要讲解了java的持有对象
<!-- more -->
# 正文
#### 1.持有对象
容器类的基本类型是List，Set，Queue，Map。这些对象类型也成为集合类

#### 2.泛型和类型安全的容器
使用ArrayList相当简单：创建一个实例，用add()插入对象，get()访问对象， size()获取ArrayList中元素的个数

#### 3.基本概念
Java容器类类库的用途是“保存对象”，并将其划分为两个不同的概念:
**Collection**:一个独立元素的序列，这些元素都服从一条或多条规则。List必须按照插入的顺序保存元素，而Set不能有重复元素。Queue按照队列规则来确定对象产生的顺序
**Map**:一组成对的"键值对"对象，允许使用键值来查找值。映射表允许我们使用另一个对象查找某个对象，它也被称为“关联数组”

#### 4.添加一组元素
下面介绍Collection类添加元素的实用方法：
Arrays.asList()接受一个数组或者一个逗号分隔的元素列表（使用可变参数），将其转换为一个List对象。
```
 List<Integer> list = Arrays.asList(16, 17, 18, 19, 20); 
 list.set(1, 99); 
```
Collection.addAll()方法运行起来很快，而且构建一个不包含元素的Collection，然后调用Collection.addAll()这种方式很方便，因此它是首选方式
```
Collection<Integer> collection = new ArrayList<Integer>(Arrays.asList(1, 2, 3, 4, 5));
Integer[] moreInts = { 6, 7, 8, 9, 10 }; 
collection.addAll(Arrays.asList(moreInts));
```
而Collection.addAll()只能接受另一个Collection对象作为参数，不如Arrays.asList()和Collections.addAll()灵活，这两个方法采样的都是可变参数列表
```
Collections.addAll(collection, 11, 12, 13, 14, 15); 
```
可以直接使用Arrays.asList()的输出，将其当做List，但是这种情况下，其底层表示的是数组，不能调整其尺寸，所以不能add()或delete()
```java
   class Snow {} 
     class Powder extends Snow {} 
     class Light extends Powder {} 
     class Heavy extends Powder {} 
     class Crusty extends Snow {} 
     class Slush extends Snow {} 


     public class AsListInference { 
       public static void main(String[] args) { 
          List<Snow> snow1 = Arrays.asList( 
            new Crusty(), new Slush(), new Powder()); 


          // Won’t compile: 
          // List<Snow> snow2 = Arrays.asList( 
          //    new Light(), new Heavy()); 
          // Compiler says: 
          // found      : java.util.List<Powder> 
          // required: java.util.List<Snow> 


          // Collections.addAll() doesn’t get confused: 
          List<Snow> snow3 = new ArrayList<Snow>(); 
          Collections.addAll(snow3, new Light(), new Heavy());
      }
  }
```
对于这种多重向上转型，必须显示类型参数说明。

#### 5.容器的打印
可直接打印容器，它自带了打印函数
```java
import java.util.*; 
     import static net.mindview.util.Print.*; 


     public class PrintingContainers { 
       static Collection fill(Collection<String> collection) { 
          collection.add("rat"); 
          collection.add("cat"); 
          collection.add("dog"); 
          collection.add("dog"); 
          return collection; 
       } 
       static Map fill(Map<String,String> map) { 
          map.put("rat", "Fuzzy"); 
          map.put("cat", "Rags"); 
          map.put("dog", "Bosco"); 
          map.put("dog", "Spot"); 
          return map; 
       } 
       public static void main(String[] args) { 
          print(fill(new ArrayList<String>())); 
          print(fill(new LinkedList<String>())); 
          print(fill(new HashSet<String>())); 
          print(fill(new TreeSet<String>())); 
          print(fill(new LinkedHashSet<String>())); 
          print(fill(new HashMap<String,String>())); 
          print(fill(new TreeMap<String,String>())); 
          print(fill(new LinkedHashMap<String,String>())); 
       } 
     } /* Output: 
     [rat, cat, dog, dog] 
     [rat, cat, dog, dog] 
     [dog, cat, rat] 

     [cat, dog, rat] 

     [rat, cat, dog] 
     {dog=Spot, cat=Rags, rat=Fuzzy} 
     {cat=Rags, dog=Spot, rat=Fuzzy} 
     {rat=Fuzzy, cat=Rags, dog=Spot} 
```
这两种主要类型的区别在于容器的每个“槽”保存的元素个数
Collection在每个槽中只能保存一个元素。此类容器包括：List，它以特定的顺序保存一组元素；Set，元素不能重复；Queue，一端插入对象，另一端移除对象。 
Map在每个槽内保存两个对象，即键和与之相关联的值
Collection打印出来的内容用[ ]括住，Map打印出来的内容用{ }括住
HashMap提供了最快的查找技术，TreeMap按照比较结果升序保存键，LinkedHashMap则按照插入顺序保存键，同时还保留了HashMap的查询速度

#### 6.List
两种类型的List:
基本的ArrayList，它长于随机访问元素，但是在List的中间插入和移除元素时较慢。
LinkedList，它提供了代价较低的在List中间进行的插入和删除操作，提供了优化的顺序访问。LinkedList在随机访问方面相对比较慢
List重要价值在于，它提供了一种可修改的序列。
indexOf()来发现对象在List中所处位置的索引编号。
从List中移除一个元素，都会涌到equals()方法，List的行为根据equals()的行为而有所变化。
优化是一个棘手的问题，最好的策略就是弃之不顾，知道你发现需要担心它。
subList()方法允许很容易的从较大的列表中创建一个片段，顺序并不影响containsAll()的判断结果。
retainAll()保留两List的交集。
removeAll()也是基于equals()方法的。
addAll()方法使得我们可以在初始List中插入新的列表，而不是仅仅只能用Collection的addAll()方法追加到表尾。

#### 7.迭代器
对于List，add()是插入元素的方法之一，而get()是取出元素的方法之一。
迭代器（Iterator，一种设计模式）是一个对象，它的工作是遍历并选择序列中的对象，迭代器通常被称为轻量级对象，创建它们的代价小。
Java的Iterator只能单向移动，用来：
```
使用方法Iterator()要求容器返回一个Iterator。Iterator准备好返回序列的第一个元素。
使用next()获得序列中的下一个元素。
使用hasNext()检查序列中是否还有元素。
使用remove()将迭代器新近返回的元素删除。
```
在remove()之前必须先调用next()。
Iterator 能够将遍历序列的操作与序列底层的结构分离。迭代器统一了对容器的访问方式。如下：
```java
import typeinfo.pets.*; 
     import java.util.*; 


     public class CrossContainerIteration { 
public static void display(Iterator<Pet> it) { 
          while(it.hasNext()) { 
             Pet p = it.next(); 
             System.out.print(p.id() + ":" + p + " "); 
          } 
          System.out.println(); 
       } 
       public static void main(String[] args) { 
          ArrayList<Pet> pets = Pets.arrayList(8); 
          LinkedList<Pet> petsLL = new LinkedList<Pet>(pets); 
          HashSet<Pet> petsHS = new HashSet<Pet>(pets); 
          TreeSet<Pet> petsTS = new TreeSet<Pet>(pets); 
          display(pets.iterator()); 
          display(petsLL.iterator()); 
          display(petsHS.iterator()); 
          display(petsTS.iterator()); 
       } 
     } /* Output: 
     0:Rat 1:Manx 2:Cymric 3:Mutt 4:Pug 5:Cymric 6:Pug 7:Manx 
     0:Rat 1:Manx 2:Cymric 3:Mutt 4:Pug 5:Cymric 6:Pug 7:Manx 
     4:Pug 6:Pug 3:Mutt 1:Manx 5:Cymric 7:Manx 2:Cymric 0:Rat 
     5:Cymric 2:Cymric 7:Manx 1:Manx 3:Mutt 6:Pug 4:Pug 0:Rat 
```
ListIterator可以双向移动，并且可以使用set()方法替换它访问过的最后一个元素。

#### 8.LinkedList
LinkedList在执行某些操作时比ArrayList更高效，但是在随机访问操作方面却要逊色一些。
LinkedList还添加了可以作为栈，队列，双端队列的方法。可以使用它们的方法

#### 9.stack
“栈”通常是指“后进先出”（LIFO）的容器。
可以直接将LinkedList当做栈使用。如:
```java
package net.mindview.util; 
     import java.util.LinkedList; 


     public class Stack<T> { 
       private LinkedList<T> storage = new LinkedList<T>(); 
       public void push(T v) { storage.addFirst(v); } 
       public T peek() { return storage.getFirst(); } 
       public T pop() { return storage.removeFirst(); } 
       public boolean empty() { return storage.isEmpty(); } 
       public String toString() { return storage.toString(); } 
     }
```
如果想在自己的代码里使用Stack类，在创建实例时，需要完整的指定包名，否则可能会和java.util包中的Stack发生冲突

#### 10.set
Set最常使用的是测试归属性，可以轻易的查询某个对象是否在某个Set中。查找成为Set中最重要的操作，因此通常会选择一个HashSet的实现，它专门对快速查找进行了优化。
Set具有与Collection完全一样的接口，实际上Set就是Collection，只是行为不同。Set是基于对象的值来确定归属性的，使用contains()
HashSet使用了散列，HashSet所维护的顺序与TreeSet和LinkedHashSet都不一样，因为他们的实现具有不同的元素存储方式。TreeSet将元素存储在红-黑树数据结构中，而HashSet使用的是散列函数。LinkedHashList因为查询速度的原因也使用了散列，但是看起来是使用了链表来维护元素的插入顺序。
```java
import java.util.*; 
     import net.mindview.util.*; 


     public class UniqueWords { 
       public static void main(String[] args) { 
          Set<String> words = new TreeSet<String>( 
            new TextFile("SetOperations.java", "\\W+")); 
          System.out.println(words); 
       } 
     } 
     /* Output: 
     [A, B, C, Collections, D, E, F, G, H, HashSet, I, J, K, L, M, N, Output, 
     Print, Set, SetOperations, String, X, Y, Z, add, addAll, added, args, 
     class, contains, containsAll, false, from, holding, import, in, java, 
     main, mindview, net, new, print, public, remove, removeAll, removed, 
     set1, set2, split, static, to, true, util, void] 
```
如上所示代码，打开一个文件，并将其读入一个Set中。TextFile继承自List<String>，构造器打开文件，并根据正则表达式“\\W+”将其断开为单词，这个正则表达式表示“一个或多个字母”，TreeSet将其按字典顺序排列，大小写分开。
如果想按字母顺序排列，可以向TreeSwt构造器传入String.CASE_INSENTIVE_ORDER比较器
```java
public class UniqueWordsAlphabetic { 
       public static void main(String[] args) { 
          Set<String> words = 
            new TreeSet<String>(String.CASE_INSENSITIVE_ORDER); 
          words.addAll( 
            new TextFile("SetOperations.java", "\\W+")); 
          System.out.println(words); 
       } 
     } 
    
     /* Output: 
     [A, add, addAll, added, args, B, C, class, Collections, contains, 
     containsAll, D, E, F, false, from, G, H, HashSet, holding, I, import, 
     in, J, java, K, L, M, main, mindview, N, net, new, Output, Print, 
     public, remove, removeAll, removed, Set, set1, set2, SetOperations, 
     split, static, String, to, true, util, void, X, Y, Z] 
```

#### 11.Map
Map的get方法返回该键对应的值。如果没有则返回null。
Map的put方法放入键值对。
Map的contansKey()返回是否含有这个键，containsValue()返回是否含有这个值。
Map可以返回它的键的Set，它的值的Collection，或者它的键值对的Set。value()返回所有值组成的Collection，KeySet()方法产生所有健组成的Set，可用于遍历。

#### 12.Queue
队列是一个典型的先进先出（FIFO）的容器。队列常被当做一种可靠的将对象从程序的某个区域传输到另一个区域的途径。队列在并发编程中特别重要。因为它们可以安全的将对象从一个任务传输给另一个任务。
```
offer()是与Queue相关的方法之一，他在允许的情况下，将一个元素插入到队尾，或者返回false。
peek()和element()都将在布衣橱的情况下返回队头，但是peek()方法在队列为空时返回null，而element()会抛出NoSuchElementException异常。
poll()和remove()方法将一出并返回队头，但是poll()在队列为空时返回null，而remove()会抛出NoSuchElementException异常。
```
Queue可以由LinkedList来实现。而Queue接口窄化了对LinkedList的方法的访问权限。
PriorityQueue:
先进先出描述了最典型的队列规则。队列规则是指在给定一组队列中的元素的情况下，确定下一个弹出队列的元素的规则。先进先出声明的是下一个元素应该是等待时间最长的元素。
```
优先级队列声明下一个弹出元素是最需要的元素（拥有最高优先级）。 PriorityQueue可以确保当你调用peek()、poll()和remove()方法时，获取的元素将是队列中优先级最高的元素。
重复是允许的，最小的值拥有最高的优先级（如果是String，空格也可以算作值，并且比字母优先级高），可以使用Collection.reverseOrder()来改变顺序。如
```
stringPQ = new PriorityQueue<String>(strings.size(), Collections.reverseOrder()); 
可以用HashSet来消除重复的Charactor.比如：
         String fact = "EDUCATION SHOULD ESCHEW OBFUSCATION"; 
         Set<Character> charSet = new HashSet<Character>(); 
         for(char c : fact.toCharArray()) 
            charSet.add(c); // Autoboxing 
         PriorityQueue<Character> characterPQ = new PriorityQueue<Character>(charSet); 
         QueueDemo.printQ(characterPQ); 
Output: A B C D E F H I L N O S T U W 

#### 13.Collection和Iterator
Collection是描述所有序列容器的共性的接口。在Java中，Collection和迭代器绑定到了一起，所有实现Collection就意味着需要实现Iterator()方法
然而如果一个不是Collection类型的外部类，就不能实现Collection接口了，此时使用Iterator就是个不错的选择。继承AbstractCollection可以很容易的实现，它强制实现iterator()和size()方法。
```java
   import typeinfo.pets.*; 
     import java.util.*; 


     public class CollectionSequence 
     extends AbstractCollection<Pet> { 
       private Pet[] pets = Pets.createArray(8); 
       public int size() { return pets.length; } 
       public Iterator<Pet> iterator() { 
          return new Iterator<Pet>() { 
            private int index = 0; 
            public boolean hasNext() { 
               return index < pets.length; 
            } 
            public Pet next() { return pets[index++]; } 
            public void remove() { // Not implemented 
               throw new UnsupportedOperationException(); 
            } 

             }; 
       } 
       public static void main(String[] args) { 
          CollectionSequence c = new CollectionSequence(); 
          InterfaceVsIterator.display(c); 
          InterfaceVsIterator.display(c.iterator()); 
       } 
     } /* Output: 
     0:Rat 1:Manx 2:Cymric 3:Mutt 4:Pug 5:Cymric 6:Pug 7:Manx 
     0:Rat 1:Manx 2:Cymric 3:Mutt 4:Pug 5:Cymric 6:Pug 7:Manx 
```
上例可见，如果实现Collection()，就必须实现Iterator()，更糟糕的是，如果这个外部类已经有需要继承的类而不能继承自AbstractCollection，要实现Collection就必须实现该接口中的所有方法。
```java
       class PetSequence { 
       protected Pet[] pets = Pets.createArray(8); 
     } 


     public class NonCollectionSequence extends PetSequence { 
       public Iterator<Pet> iterator() { 
          return new Iterator<Pet>() { 
            private int index = 0; 
            public boolean hasNext() { 
               return index < pets.length; 
            } 
            public Pet next() { return pets[index++]; } 
            public void remove() { // Not implemented 
               throw new UnsupportedOperationException(); 
            } 
          }; 
       } 
       public static void main(String[] args) { 
          NonCollectionSequence nc = new NonCollectionSequence(); 
          InterfaceVsIterator.display(nc.iterator()); 
       } 
     } /* Output: 
     0:Rat 1:Manx 2:Cymric 3:Mutt 4:Pug 5:Cymric 6:Pug 7:Manx 
```
生成Iterator是将队列与消费队列的方法连接在一起耦合度最小的方式，并且与实现Collection相比，它在序列类上所施加的约束也少得多。

#### 14.Foreach与迭代器
Iterable接口包含一个能够产生Iterator的iterator()方法，并且Iterator接口被foreach用来在序列中移动。
大量的类都是Iterable类型，主要包括所有的Collection类（但是不包含各种Map）。
foreach语句可以用于数组或其它任何Iterable，但并不意味着数组肯定是一个Iterable，而任何自动包装也不会自动发生，不存在任何从数组到Iterable的自动转换，必须手动执行这种转换。
```java
     import java.util.*; 
     public class ArrayIsNotIterable { 
        static <T> void test(Iterable<T> ib) { 
           for(T t : ib) 
             System.out.print(t + " "); 
        } 
        public static void main(String[] args) { 
           test(Arrays.asList(1, 2, 3)); 
           String[] strings = { "A", "B", "C" }; 
           // An array works in foreach, but it’s not Iterable: 
           //! test(strings); 
           // You must explicitly convert it to an Iterable: 
           test(Arrays.asList(strings)); 
        } 
     } /* Output: 
     1 2 3 A B C 
```
如上，String数组不可以直接作为Iterator类传递，而是被手动转换成了Collection类，也即Iterable类型

**适配器方法惯用法**:
当有一个接口并需要另一个接口，编写适配器就可以解决问题。至于为什么有一个接口还要写另一个接口么，比如像有乱序倒序的Iterator方法，如果直接继承就会覆盖原有的顺序方法，所以要写别的能产生Iterable对象的方法接口（适配器）以满足foreach语句实现功能。
通过使用方法中的内部类，下例实现了在foreach方法中将Iterable对象倒序和乱序遍历的方法
```java
     import java.util.*; 
     public class MultiIterableClass extends IterableClass { 
       public Iterable<String> reversed() { 
         return new Iterable<String>() { 
            public Iterator<String> iterator() { 
              return new Iterator<String>() { 
                 int current = words.length - 1; 
                 public boolean hasNext() { return current > -1; } 
                 public String next() { return words[current--]; } 
                 public void remove() { // Not implemented 
                   throw new UnsupportedOperationException(); 
                 } 
              }; 
            } 
         }; 
       } 
       public Iterable<String> randomized() { 
         return new Iterable<String>() { 
            public Iterator<String> iterator() { 
              List<String> shuffled = 
                 new ArrayList<String>(Arrays.asList(words)); 
              Collections.shuffle(shuffled, new Random(47)); 
              return shuffled.iterator(); 
            } 
         }; 
       } 
       public static void main(String[] args) { 
         MultiIterableClass mic = new MultiIterableClass(); 
         for(String s : mic.reversed()) 
            System.out.print(s + " "); 
         System.out.println(); 
         for(String s : mic.randomized()) 
            System.out.print(s + " "); 
         System.out.println(); 
         for(String s : mic) 
            System.out.print(s + " "); 
       } 
     } /* Output: 
     banana-shaped. be to Earth the know we how is that And 
     is banana-shaped. Earth that how the be And we know to 
    And that is how we know the Earth to be banana-shaped. 
```
注意乱序方法并没有创建自己的Iterator,而是直接返回被打乱的List（作为Collection类的一种）中的Iterator。
需要注意的是，Arrrays.asList()产生的List对象会使用底层数组作为其物理实现，也就是会修改原来的数组。如果不想这种情况发生，就应该在另一个容器中创建一个副本。即使用 List<Integer> list = new ArrayList<Integer>(Arrays.asList(数组)) 的方法，这样修改的只是list引用而不是原数组

#### 15.总结
Java提供了大量持有对象的方式：
1、数组。一旦生成，容量就不能改变。
2、Collection保存单一的元素，Map保存相关联的键值对。它们可以自动的调整其尺寸。容器不能持有基本类型，但是自动包装机制会自动地执行基本类型到容器中所持有的包装器类型之间的双向转换。
数组和List都是排好序的容器，List可以自动扩容。
如果需要大量随机访问，使用ArrayList，如果要经常在其中插入删除，则使用LinkedList。
各种Queue以及栈的行为，由LinkedList提供支持。
Map将对象与对象相关联，HashMap用来快速访问，而TreeMap保持“键”始终处于排序状态，所以没有HashMap快。LinkedHashMap保持原始插入的顺序，但也通过散列提供了快速访问能力。
Set不接受重复元素。HashSet提供最快的查询速度，TreeSet保持元素处于排序状态，LinkedHashSet以插入顺序保存元素。
新程序不该使用过时的Vector、Hashtable和Stack。 
除了TreeSet之外的所有Set都拥有与Collection完全一样的接口。
List和Collection存在着明显的不同，尽管List所要求的方法都在Collection中。
另一方面，在Queue接口中的方法都是独立的，在创建具有Queue功能的实现时，不需要使用Collection方法。
最后，Map和Collection之间唯一的重叠就是Map可以使用entrySet()和values()方法来产生Collection。

# 参考资料
https://blog.csdn.net/severusyue/article/details/49491441 Java编程思想第四版读书笔记——第十一章 持有对象 severusyue