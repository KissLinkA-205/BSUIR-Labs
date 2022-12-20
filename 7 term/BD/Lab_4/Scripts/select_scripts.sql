-- Выводится статус, дата оформления и общая стоимость заказа; email-клиента; название тура,
-- страна тура, количество взрослых и детей в туре.
-- Данные отсортированы в алфавитном порядке по названию тура.
SELECT orders.status         "Status",
       orders.issue_date     "Issue date",
       orders.total_cost     "Total cost",
       clients.email         "Email",
       tours.title           "Tour title",
       tours.country         "Country",
       tours.adults_number   "Adults number",
       tours.children_number "Children number"
    FROM public.orders
        INNER JOIN public.clients ON clients.id = orders.client_id
        INNER JOIN public.tours ON tours.id = orders.tour_id
    ORDER BY tours.title ASC;


-- Выводится название и цена тура; имя и фамилия клиента, оставившего отзыв;
-- текст отзыва, а также его рейтинг и дата добавления.
-- Данные отсортированы в алфавитном порядке по названию тура.
SELECT tours.title         "Tour title",
       tours.price         "Price",
       reviews.rating      "Rating",
       clients.name        "Name",
       clients.surname     "Surname",
       reviews.text        "Text",
       reviews.adding_date "Adding date"
    FROM public.tours
         INNER JOIN public.reviews ON reviews.tour_id = tours.id
         INNER JOIN public.clients ON clients.id = reviews.client_id
    ORDER BY tours.title ASC;


-- Выводится название и категория тура; название отеля, количество звезд, тип, а также контактная почта и телефон.
-- Данные отсортированы в алфавитном порядке по названию тура.
SELECT tours.title          "Tour title",
       tours.category       "Tour category",
       hotels.title         "Hotel title",
       hotels.stars         "Stars",
       hotels.type          "Hotel type",
       hotels.contact_email "Contact email",
       hotels.contact_phone "Contact phone"
    FROM public.tours
         INNER JOIN public.tours_hotels ON tours_hotels.tour_id = tours.id
         INNER JOIN public.hotels ON hotels.id = tours_hotels.hotel_id
    ORDER BY tours.title ASC;


-- Выводится название, категория и цена тура; тип транспорта, а также его цена, дата отправления и место отправления.
-- Данные отсортированы в алфавитном порядке по названию тура.
SELECT tours.title                "Tour title",
       tours.category             "Tour category",
       tours.price                "Tour price",
       transports.type            "Type",
       transports.price           "Transport price",
       transports.departure_date  "Departure date",
       transports.departure_place "Departure place"
    FROM public.tours
         INNER JOIN public.tours_transports ON tours_transports.tour_id = tours.id
         INNER JOIN public.transports ON transports.id = tours_transports.transport_id
    ORDER BY tours.title ASC;


-- Выводится номер паспорта; имя, фамилия, отчество, дата рождения и национальность держателя паспорта;
-- номер визы; страна; дата выдачи и окончания действия визы.
-- Данные отсортированы в алфавитном порядке по имени держателя паспорта.
SELECT passports.number      "Passport number",
       passports.name        "Name",
       passports.surname     "Surname",
       passports.patronymic  "Patronymic",
       passports.birth_date  "Birth date",
       passports.nationality "Nationality",
       visas.number          "Visas number",
       visas.country         "Country",
       visas.issue_date      "Issue date",
       visas.expiration_date "Expiration date"
    FROM public.passports
         LEFT JOIN public.visas ON visas.passport_id = passports.id
    ORDER BY passports.name ASC;