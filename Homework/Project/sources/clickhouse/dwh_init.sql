-- 1. Базы (логические схемы) для слоёв DWH
CREATE DATABASE IF NOT EXISTS dwh;
CREATE DATABASE IF NOT EXISTS dwh_stage;
CREATE DATABASE IF NOT EXISTS dwh_dds;
CREATE DATABASE IF NOT EXISTS dwh_marts;

-- 2. Источники из PostgreSQL (БД2, схема bookings)
-- Важно: имена пользователя/БД/пароля должны совпадать с переменными POSTGRES_SRC_USER/DB/PASSWORD

-- Справочник самолётов (airplanes)
CREATE TABLE IF NOT EXISTS dwh_stage.src_airplanes_data
(
    airplane_code   String,
    model           String,
    range           Int32,
    speed           Int32
)
ENGINE = PostgreSQL(
    'postgres_src:5432',
    'src_db',
    'airplanes_data',
    'src_user',
    'src_pass',
    'bookings'
);

-- Справочник аэропортов (airports)
CREATE TABLE IF NOT EXISTS dwh_stage.src_airports_data
(
    airport_code    String,
    airport_name    String,
    city            String,
    country         String,
    coordinates     String,
    timezone        String
)
ENGINE = PostgreSQL(
    'postgres_src:5432',
    'src_db',
    'airports_data',
    'src_user',
    'src_pass',
    'bookings'
);

-- Посадочные талоны (boarding_passes)
CREATE TABLE IF NOT EXISTS dwh_stage.src_boarding_passes
(
    ticket_no       String,
    flight_id       Int32,
    seat_no         String,
    boarding_no     Int32,
    boarding_time   DateTime
)
ENGINE = PostgreSQL(
    'postgres_src:5432',
    'src_db',
    'boarding_passes',
    'src_user',
    'src_pass',
    'bookings'
);

CREATE TABLE IF NOT EXISTS dwh_stage.src_boookings
(
    book_ref        String,
    book_date       DateTime,
    total_amount    Float
)
ENGINE = PostgreSQL(
    'postgres_src:5432',
    'src_db',
    'bookings',
    'src_user',
    'src_pass',
    'bookings'
);
-- Рейсы (flights)
CREATE TABLE IF NOT EXISTS dwh_stage.src_flights
(
    flight_id               Int32,
    route_no                String,
    status                  String,
    scheduled_departure     DateTime,
    scheduled_arrival       DateTime,
    actual_departure        DateTime,
    actual_arrival          DateTime
)
ENGINE = PostgreSQL(
    'postgres_src:5432',
    'src_db',
    'flights',
    'src_user',
    'src_pass',
    'bookings'
);

CREATE TABLE IF NOT EXISTS dwh_stage.src_routes
(
    route_no            String,
    validity            
    departure_airport
    arrival_airport
    airplane_code
    days_of_week
    scheduled_time
    duration

-- Билеты (tickets)
CREATE TABLE IF NOT EXISTS dwh_stage.src_tickets
(
    ticket_no       String,
    book_ref        String,
    passenger_id    String,
    passenger_name  String
)
ENGINE = PostgreSQL(
    'postgres_src:5432',
    'src_db',
    'tickets',
    'src_user',
    'src_pass',
    'bookings'
);

-- Связка билет–рейс (ticket_flights)
CREATE TABLE IF NOT EXISTS dwh_stage.src_ticket_flights
(
    ticket_no       String,
    flight_id       Int32,
    fare_conditions String,
    amount          Decimal(10,2)
)
ENGINE = PostgreSQL(
    'postgres_src:5432',
    'src_db',
    'ticket_flights',
    'src_user',
    'src_pass',
    'bookings'
);


