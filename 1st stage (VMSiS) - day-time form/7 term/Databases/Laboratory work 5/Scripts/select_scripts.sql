-- Выводится название, страна, категория и цена тура, рейтинги оставленных отзывов и средняя оценка пользователей на тур.
-- Рассматриваются отзывы, оставленные в временной период с 20 ноября 2022 года до 30 ноября 2022 года.
-- Данные отсортированы в алфавитном порядке по названию тура.
SELECT tours.title                            "Tour title",
       tours.country                          "Country",
       tours.category                         "Category",
       tours.price                            "Price",
       string_agg(reviews.rating::text, ', ') "Ratings",
       AVG(reviews.rating) as                 "Average rating"
    FROM public.tours
        INNER JOIN public.reviews ON reviews.tour_id = tours.id
        INNER JOIN public.clients ON clients.id = reviews.client_id
    WHERE reviews.adding_date >= '20.11.2022' 
        AND reviews.adding_date <= '30.11.2022'
    GROUP BY tours.id
    ORDER BY tours.title ASC;


-- Выводится имя, фамилия и электронная почта клиента, а также завершенные туры, в которых побывал клиент и
-- общая стоимость всех завершенных туров. Рассматривается 2022 год.
-- Данные отсортированы в алфавитном порядке по общей потраченной сумме.
-- В конце добавляется общая выручка турагентства от выполненных заказов.
SELECT clients.name                  "Name",
       clients.surname               "Surname",
       clients.email                 "Email",
       string_agg(tours.title, ', ') "Tours",
       SUM(orders.total_cost) as     "Total price"
    FROM public.clients
        INNER JOIN public.orders ON clients.id = orders.client_id
        INNER JOIN public.tours ON tours.id = orders.tour_id
    WHERE orders.issue_date >= '01.01.2022'
        AND orders.issue_date <= '31.12.2022'
        AND orders.status = 'завершен'
    GROUP BY clients.id
    UNION
        SELECT '', '', '', 'Total revenues', SUM(orders.total_cost)
            FROM orders
            WHERE orders.status = 'завершен'
    ORDER BY "Total price";


-- Выводится название, страна и тип тура, а также перечисляются возможные даты отправления в тур.
-- Около тура выводится количество транспортов, доступных в туре. Рассматривается 2022 год.
-- Данные отсортированы в алфавитном порядке по названию тура.
SELECT tours.title                                       "Tour",
       tours.country                                     "Country",
       tours.category                                    "Category",
       string_agg(transports.departure_date::text, ', ') "Dates",
       COUNT(transports.id) as                           "Number of transports"
    FROM public.tours
        INNER JOIN public.tours_transports ON tours_transports.tour_id = tours.id
        INNER JOIN public.transports ON transports.id = tours_transports.transport_id
    WHERE transports.departure_date >= '01.01.2022'
        AND transports.departure_date <= '31.12.2022'
    GROUP BY tours.id
    ORDER BY tours.title ASC;


-- Выводится имя, фамилия и электронная почта клиента, статус заказа, общая стоимость заказа,
-- а также перечень номеров паспортов, участвующих в заказе. Рассматриваются заказы со статусом,
-- отличным от «завершен» и «отменен». Данные отсортированы в алфавитном порядке по статусу заказа.
SELECT clients.name                             "Name",
       clients.surname                          "Surname",
       clients.email                            "Email",
       orders.status                            "Status",
       orders.total_cost                        "Total cost",
       string_agg(passports.number::text, ', ') "Passports"
    FROM public.orders
        INNER JOIN public.clients ON clients.id = orders.client_id
        INNER JOIN public.orders_passports ON orders_passports.order_id = orders.id
        INNER JOIN public.passports ON passports.id = orders_passports.passport_id
    WHERE orders.status != 'завершен'
        AND orders.status != 'отменен'
    GROUP BY orders.id, clients.id
    ORDER BY orders.status ASC;


-- Выводится имя, фамилия и электронная почта клиента, а также количество заказов. Рассматривается 2022 год. 
-- Данные отсортированы в алфавитном порядке по количеству заказов. 
-- В конце добавляется общее количество заказов пользователей.
SELECT clients.name        "Name",
       clients.surname     "Surname",
       clients.email       "Email",
       COUNT(orders.id) as "Number of orders"
    FROM public.clients
        INNER JOIN public.orders ON clients.id = orders.client_id
    WHERE orders.issue_date >= '01.01.2022'
        AND orders.issue_date <= '31.12.2022'
    GROUP BY clients.id
    UNION
        SELECT '', '', 'Total number of orders', COUNT(orders.id)
            FROM orders
    ORDER BY "Number of orders";