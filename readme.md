<h2 align="center"> 🎓 Belarusian State University of Informatics and Radioelectronics <br/> 
 (BSUIR) - БГУИР <br/>Faculty of Computer Systems and Networks (FKSiS) - ФКСиС<br/>
 Specialty of Computing Machines, Systems and Networks (VMSiS) - ВМСиС <br/>2019-2021 г.
</h2>

<h4>EN: This repository presents laboratory work of the specialty "Computing machines, systems and networks". Not all works presented here are completely correct and may not  correspond to your task.<br/>
RU: В данном репозитории представлены лабораторные работы по специальности "Вычислительные машины, системы и сети". Не все представленные здесь  работы полностью корректны и могут не соответствовать вашей задаче.<br/></br>

P.S. Все авторские права на предоставленные ниже условия лабораторных работ принадлежат Белорусскому  Государственному Университету Информатики и Радиоэлектроники <a href="https://www.bsuir.by/" rel="nofollow">БГУИР</a>, <a href="https://www.bsuir.by/en/" rel="nofollow">BSUIR</a>
</h4>
<hr align="center">

<h2> 📘 4 term (4 семестр): </h2>
<ul>
 <li>
  <a href="https://github.com/KissLinkA-205/BSUIR-Labs/tree/main/4%20term/KPP%20(Project)" rel="nofollow">
   EN: Cross Platform Programming <code>Java</code> <br>
   RU: Кросс-платформенное программирование</a>
  <details close>
   <summary>
    Project (проект)
   </summary>
   <h3 align="center">Лабораторные работы по языку Java (создание проекта) - Introduction to Cross-Platform Programming on Java</h3>
   <h4>P.S. Все авторские права на предоставленные ниже условия лабораторных работ принадлежат компании <a href="https://www.epam.com/" rel="nofollow">EPAM</a></h4>
   
   <hr align="center">
   
   <h4>1. Intro</h4>
   1 - Создать и запустить локально простейший веб/REST сервис, используя любой открытый пример с использованием Java stack: Spring (Spring Boot)/maven/gradle/Jersey/ Spring MVC</br>
   2 - Добавить GET ендпоинт, принимающий входные параметры в качестве queryParams в URL и возвращающий результат в виде JSON согласно варианту.<br>
   
   <h4>2. Error logging/handling</h4>
   1 - Добавить валидацию входных параметров с возвращением 400 ошибки <br>
   2 - Добавить обработку внутренних unchecked ошибок с возвратом 500 ошибки <br>
   3 - Добавить логирование действий и ошибок <br>
   4 - Написать unit test <br>
   
  <h4>3. Collections intro, project structure</h4>
  Добавить простейший кэш в виде in-memory Map для сервиса. Map должна содержаться в отдельном бине/классе, который должен добавляться в основной сервис с помощью dependency injection механизм Spring.<br>
  
  <h4>4. Concurrency</h4>
  1 - Добавить сервис для подсчёта обращений к основному сервису. Счётчик должен быть реализован в виде отдельного класса, доступ к которому должен быть синхронизирован.<br> 
  2 - Используя jmeter/postman или любые другие средвста сконфигурировать нагрузочный тест и убедиться, что счётчик обращений работает правильно при большой нагрузке.<br>
  
  <h4>5. Functional programming with Java 8</h4>
  1 - Преобразовать исходный сервис для работы со списком параметров для bulk операций используя Java 8 лямбда выражения.<br>
  2 - Добавить POST метод для вызова bulk операции и передачи списка параметров в виде JSON.<br>
  
  <h4>6. Functional filtering and mapping</h4>
  Добавить аггрегирующий функционал (подсчёт макс, мин, средних значений) для входных параметров и результатов с использованием Java 8 map/filters функций. Расширить результат
  POST соотвественно.<br>
  
  <h4>7. Data persistence</h4>
  Добавить возможность сохранения всех результатов вычислений в базе данных или файле, используя стандартные persistence фреймворки Java (Spring Data/Hibernate/MyBatis)<br>
  
  <h4>8. Asynchronous calls</h4>
  Добавить возможность асинхронного вызова сервиса используя future, возвращать статус вызова REST сервиса не дожидаясь результатов подсчётов. Результаты подсчётов должны быть представлены в БД по предопределённой ID<br>
  </details>
 </li>
</ul>

<h2> 📘 5 term (5 семестр): </h2>

