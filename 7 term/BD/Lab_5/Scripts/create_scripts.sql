-- Удаление ранее созданных таблиц при повторном запуске скрипта
DROP TABLE IF EXISTS ORDERS_PASSPORTS CASCADE;
DROP TABLE IF EXISTS VISAS CASCADE;
DROP TABLE IF EXISTS PASSPORTS CASCADE;
DROP TABLE IF EXISTS ORDERS CASCADE;
DROP TABLE IF EXISTS REVIEWS CASCADE;
DROP TABLE IF EXISTS TOURS_HOTELS CASCADE;
DROP TABLE IF EXISTS HOTELS CASCADE;
DROP TABLE IF EXISTS TOURS_TRANSPORTS CASCADE;
DROP TABLE IF EXISTS TRANSPORTS CASCADE;
DROP TABLE IF EXISTS TOURS CASCADE;
DROP TABLE IF EXISTS CLIENTS CASCADE;

-- Создание таблиц
CREATE TABLE IF NOT EXISTS CLIENTS
(
    id           SERIAL PRIMARY KEY,
    email        VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    name         VARCHAR(35)         NOT NULL,
    surname      VARCHAR(20)         NOT NULL
);

CREATE TABLE IF NOT EXISTS TOURS
(
    id              SERIAL PRIMARY KEY,
    title           VARCHAR(255) UNIQUE NOT NULL,
    country         VARCHAR(35)         NOT NULL,
    hot             BOOLEAN  DEFAULT false,
    price           MONEY               NOT NULL,
    adults_number   SMALLINT DEFAULT 0 CHECK (adults_number >= 0),
    children_number SMALLINT DEFAULT 0 CHECK (children_number >= 0),
    nights_number   SMALLINT DEFAULT 0 CHECK (nights_number >= 0 AND nights_number < 366),
    nutrition       VARCHAR(25),
    category        VARCHAR(45)         NOT NULL,
    description     TEXT
);

CREATE TABLE IF NOT EXISTS TRANSPORTS
(
    id              SERIAL PRIMARY KEY,
    type            VARCHAR(25) NOT NULL,
    price           MONEY       NOT NULL,
    departure_date  DATE,
    departure_place VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS TOURS_TRANSPORTS
(
    id           SERIAL PRIMARY KEY,
    tour_id      INTEGER NOT NULL,
    transport_id INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS HOTELS
(
    id            SERIAL PRIMARY KEY,
    title         VARCHAR(100) UNIQUE NOT NULL,
    location      VARCHAR(100)        NOT NULL,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(20),
    stars         SMALLINT DEFAULT 0 CHECK (stars >= 0 AND stars <= 5),
    type          VARCHAR(100)        NOT NULL,
    description   TEXT
);

CREATE TABLE IF NOT EXISTS TOURS_HOTELS
(
    id       SERIAL PRIMARY KEY,
    tour_id  INTEGER NOT NULL,
    hotel_id INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS REVIEWS
(
    id          SERIAL PRIMARY KEY,
    rating      SMALLINT DEFAULT 0 CHECK (rating >= 0 AND rating <= 10),
    text        TEXT    NOT NULL,
    adding_date DATE    NOT NULL,
    client_id   INTEGER NOT NULL,
    tour_id     INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS ORDERS
(
    id         SERIAL PRIMARY KEY,
    status     VARCHAR(20) NOT NULL,
    issue_date DATE        NOT NULL,
    total_cost MONEY       NOT NULL,
    client_id  INTEGER     NOT NULL,
    tour_id    INTEGER     NOT NULL
);

CREATE TABLE IF NOT EXISTS PASSPORTS
(
    id              SERIAL PRIMARY KEY,
    number          VARCHAR(10) UNIQUE NOT NULL,
    name            VARCHAR(35)        NOT NULL,
    surname         VARCHAR(35)        NOT NULL,
    patronymic      VARCHAR(35)        NOT NULL,
    birth_date      DATE               NOT NULL,
    issue_date      DATE               NOT NULL,
    expiration_date DATE               NOT NULL,
    nationality     VARCHAR(50)        NOT NULL
);

CREATE TABLE IF NOT EXISTS VISAS
(
    id              SERIAL PRIMARY KEY,
    number          VARCHAR(10) UNIQUE NOT NULL,
    country         VARCHAR(35)        NOT NULL,
    issue_date      DATE               NOT NULL,
    expiration_date DATE               NOT NULL,
    passport_id     INTEGER            NOT NULL
);

CREATE TABLE IF NOT EXISTS ORDERS_PASSPORTS
(
    id          SERIAL PRIMARY KEY,
    order_id    INTEGER NOT NULL,
    passport_id INTEGER NOT NULL
);


-- Задание ограничений внешних ключей
ALTER TABLE TOURS_TRANSPORTS
    ADD CONSTRAINT fk_tour
        FOREIGN KEY (tour_id)
            REFERENCES TOURS (id);

ALTER TABLE TOURS_TRANSPORTS
    ADD CONSTRAINT fk_transport
        FOREIGN KEY (transport_id)
            REFERENCES TRANSPORTS (id);

ALTER TABLE TOURS_HOTELS
    ADD CONSTRAINT fk_tour
        FOREIGN KEY (tour_id)
            REFERENCES TOURS (id);

ALTER TABLE TOURS_HOTELS
    ADD CONSTRAINT fk_hotel
        FOREIGN KEY (hotel_id)
            REFERENCES HOTELS (id);

ALTER TABLE REVIEWS
    ADD CONSTRAINT fk_tour
        FOREIGN KEY (tour_id)
            REFERENCES TOURS (id);

ALTER TABLE REVIEWS
    ADD CONSTRAINT fk_client
        FOREIGN KEY (client_id)
            REFERENCES CLIENTS (id);

ALTER TABLE ORDERS
    ADD CONSTRAINT fk_tour
        FOREIGN KEY (tour_id)
            REFERENCES TOURS (id);

ALTER TABLE ORDERS
    ADD CONSTRAINT fk_client
        FOREIGN KEY (client_id)
            REFERENCES CLIENTS (id);

ALTER TABLE VISAS
    ADD CONSTRAINT fk_passport
        FOREIGN KEY (passport_id)
            REFERENCES PASSPORTS (id);

ALTER TABLE ORDERS_PASSPORTS
    ADD CONSTRAINT fk_order
        FOREIGN KEY (order_id)
            REFERENCES ORDERS (id);

ALTER TABLE ORDERS_PASSPORTS
    ADD CONSTRAINT fk_passport
        FOREIGN KEY (passport_id)
            REFERENCES PASSPORTS (id);
