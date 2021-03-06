<h2 align="center"> 🎓  Системное программное обеспечение вычислительных машин <br/>Лабораторная работа №2 "Файловая система"</h2>

<h3>Задание</h3>
<p>Написать программу, которая рекурсивно сканирует файловое дерево, начиная с некоторого каталога, и выдает в поток стандартного вывода список имен найденных файлов в полном формате (абсолютный путь к файлу).</p>
  
<p>Программа принимает и обрабатывает следующие параметры:</p>
<p>foo [start] [options]</p>
<p>start — начальный каталог сканирования. Если опущен, сканирование осуществляется с текущего каталога.</p>

Опции:
<ul>
  <li>f — выводятся только обычные файлы</li>
  <li>d — выводятся только каталоги</li>
  <li>l — выводятся только символические ссылки</li>
</ul>

<p>Если опции опущены, выводятся файлы, каталоги и симлинки</p>
<p>Опции могут быть указаны в любом порядке, как раздельно (-f -l), так и вместе (-fl).</p>
<p>При выводе симлинка следует указать файл, на который он ссылается. При необходимости выполняется рекурсия.</p>
<p>Записи, соответствующие родительскому и текущему каталогу, не выводятся.</p>
<p>Если выводится более одного типа файлов, именам каталогов и симлинков должны
предшествовать через пробел символы d и l, соответственно. Пример вывода:</p>
<p>$ foo<br>
 &nbsp;&nbsp;./.gitignore<br>
 &nbsp;&nbsp;./makefile<br>
 &nbsp;&nbsp;./lab2.c<br>
l ./header.h -> /usr/include/header.h<br>
d ./build<br>
&nbsp;&nbsp; ./build/.gitignore<br>
d ./build/Debug<br>
&nbsp;&nbsp; ...</p>
