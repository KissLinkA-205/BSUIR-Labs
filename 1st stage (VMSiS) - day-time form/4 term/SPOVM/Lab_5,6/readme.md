<h2 align="center"> 🎓  Системное программное обеспечение вычислительных машин <br/>Лабораторная работа №5(6) "Отображенные в память файлы, барьеры POSIX"</h2>

<h3>Задание</h3>
<p>Задача — обработать файл размером, превышающим доступный размер памяти.<br>
Обработка выполняется несколькими потоками.<br>
Файл отображается на память (mmap()) блоками.<br>
Размер блока кратен размеру страницы памяти (page_sz = sysconf(_SC_PAGESIZE)) и количеству потоков N, соответственно, блок может быть разделен на равные куски, 
  каждый из которых будет обрабатываться своим потоком независимо.</p>
  
<p>chunk_sz = k * page_sz;<br>
block_sz = chunk_sz * N;</p>

<p>Ранг (номер, индекс) главного потока 0, ранги остальных — от 1 до N-1. Зная свой ранг, поток может вычислить начало своего куска.<br>
Отображением блоков из файла на память занимается главный поток (с рангом 0).<br>
Он же сбрасывает результат обработки в файл, когда все потоки закончат обработку своего куска. Здесь можно использовать условную переменную на счетчике, который будет
устанавливаться главным потоком в N и декрементироваться остальными по мере того, как они заканчивают свой кусок.<br>
Остаток необработанного файла на последнем раунде будет меньше размера блока — эта ситуация должна правильно обрабатываться.<br>
Потоки ожида.n завершение отображения нового блока на барьере — как только главный поток подготовит им работу, он приходит последним к барьеру и всех освобождает.<br>
Когда поток в очередном раунде завершает обработку своего куска, он приходит к барьеру ожидания нового.<br>
На последнем раунде потоки самостоятельно определяют, есть ли у них работа и ее размер.</p>

<p>Суть обработки — любая асинхронная работа, например перестановка пар длинных беззнаковых целых по возрастанию (частичная сортировка). Оставшиеся байты последнего
раунда остаются как есть.</p>

<p>Большой файл можно получить, читая dev/random. Его размер должен превышать в несколько раз объем свободной оперативной памяти и быть, по возможности, простым числом.</p>

<p>Как получить большой файл:</p>

<p>~20Гбайт<br>
$ dd if=/dev/random of=random.bin bs=16384 count=1273936<br>
$ dd if=/dev/random bs=1 count=1783 >> random.bin<br>
$ wc -c random.bin<br>
20872169207</p>

<p>~200Мбайт<br>
$ dd if=/dev/random of=random.bin bs=16384 count=12739<br>
$ dd if=/dev/random bs=1 count=5845 >> random.bin<br>
$ wc -c random.bin<br>
208721621</p>