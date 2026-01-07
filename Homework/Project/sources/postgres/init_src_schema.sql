-- Copyright (c) 2025 Postgres Professional
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Debian 17.5-1.pgdg120+1)
-- Dumped by pg_dump version 17.5 (Debian 17.5-1.pgdg120+1)

--SET statement_timeout = 0;
--SET lock_timeout = 0;
--SET idle_in_transaction_session_timeout = 0;
--SET transaction_timeout = 0;
--SET client_encoding = 'UTF8';
--SET standard_conforming_strings = on;
--SELECT pg_catalog.set_config('search_path', '', false);
--SET check_function_bodies = false;
--SET xmloption = content;
--SET client_min_messages = warning;
--SET row_security = off;

--DROP DATABASE IF EXISTS src_db;
--
-- Name: src_db; Type: DATABASE; Schema: -; Owner: -
--

--CREATE DATABASE src_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';


\connect src_db

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
--SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: src_db; Type: DATABASE PROPERTIES; Schema: -; Owner: -
--

ALTER DATABASE src_db SET "bookings.lang" TO 'en';
ALTER DATABASE src_db SET search_path TO 'bookings', '$user', 'public';


\connect src_db

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
--SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bookings; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bookings;


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: cube; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS cube WITH SCHEMA public;


--
-- Name: EXTENSION cube; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION cube IS 'data type for multidimensional cubes';


--
-- Name: earthdistance; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS earthdistance WITH SCHEMA public;


--
-- Name: EXTENSION earthdistance; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION earthdistance IS 'calculate great-circle distances on the surface of the Earth';


--
-- Name: lang(); Type: FUNCTION; Schema: bookings; Owner: -
--

CREATE FUNCTION bookings.lang() RETURNS text
    LANGUAGE sql STABLE
    RETURN current_setting('bookings.lang'::text, true);


--
-- Name: FUNCTION lang(); Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON FUNCTION bookings.lang() IS 'Language code for translatable names';


--
-- Name: now(); Type: FUNCTION; Schema: bookings; Owner: -
--

CREATE FUNCTION bookings.now() RETURNS timestamp with time zone
    LANGUAGE sql IMMUTABLE
    RETURN '2026-09-01 00:00:00+00'::timestamp with time zone;


--
-- Name: FUNCTION now(); Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON FUNCTION bookings.now() IS 'Current moment for the generated data';


--
-- Name: version(); Type: FUNCTION; Schema: bookings; Owner: -
--

CREATE FUNCTION bookings.version() RETURNS text
    LANGUAGE sql IMMUTABLE
    RETURN 'PostgresPro 2025-09-01 (365 days)'::text;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: airplanes_data; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.airplanes_data (
    airplane_code character(3) NOT NULL,
    model jsonb NOT NULL,
    range integer NOT NULL,
    speed integer NOT NULL,
    CONSTRAINT airplanes_data_range_check CHECK ((range > 0)),
    CONSTRAINT airplanes_data_speed_check CHECK ((speed > 0))
);


--
-- Name: TABLE airplanes_data; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE bookings.airplanes_data IS 'Airplanes (internal multilingual data)';


--
-- Name: COLUMN airplanes_data.airplane_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airplanes_data.airplane_code IS 'Airplane code, IATA';


--
-- Name: COLUMN airplanes_data.model; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airplanes_data.model IS 'Airplane model';


--
-- Name: COLUMN airplanes_data.range; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airplanes_data.range IS 'Maximum flight range, km';


--
-- Name: COLUMN airplanes_data.speed; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airplanes_data.speed IS 'Cruise speed, km/h';


--
-- Name: airplanes; Type: VIEW; Schema: bookings; Owner: -
--

CREATE VIEW bookings.airplanes AS
 SELECT airplane_code,
    (model ->> bookings.lang()) AS model,
    range,
    speed
   FROM bookings.airplanes_data ml;


--
-- Name: VIEW airplanes; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON VIEW bookings.airplanes IS 'Airplanes';


--
-- Name: COLUMN airplanes.airplane_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airplanes.airplane_code IS 'Airplane code, IATA';


--
-- Name: COLUMN airplanes.model; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airplanes.model IS 'Airplane model';


--
-- Name: COLUMN airplanes.range; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airplanes.range IS 'Maximum flight range, km';


--
-- Name: COLUMN airplanes.speed; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airplanes.speed IS 'Cruise speed, km/h';


--
-- Name: airports_data; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.airports_data (
    airport_code character(3) NOT NULL,
    airport_name jsonb NOT NULL,
    city jsonb NOT NULL,
    country jsonb NOT NULL,
    coordinates point NOT NULL,
    timezone text NOT NULL
);


--
-- Name: TABLE airports_data; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE bookings.airports_data IS 'Airports (internal multilingual data)';


--
-- Name: COLUMN airports_data.airport_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airports_data.airport_code IS 'Airport code, IATA';


--
-- Name: COLUMN airports_data.airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airports_data.airport_name IS 'Airport name';


--
-- Name: COLUMN airports_data.city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airports_data.city IS 'City';


--
-- Name: COLUMN airports_data.country; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airports_data.country IS 'Country';


--
-- Name: COLUMN airports_data.coordinates; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airports_data.coordinates IS 'Airport coordinates (longitude and latitude)';


--
-- Name: COLUMN airports_data.timezone; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airports_data.timezone IS 'Airport time zone';


--
-- Name: airports; Type: VIEW; Schema: bookings; Owner: -
--

CREATE VIEW bookings.airports AS
 SELECT airport_code,
    (airport_name ->> bookings.lang()) AS airport_name,
    (city ->> bookings.lang()) AS city,
    (country ->> bookings.lang()) AS country,
    coordinates,
    timezone
   FROM bookings.airports_data ml;


--
-- Name: VIEW airports; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON VIEW bookings.airports IS 'Airports';


--
-- Name: COLUMN airports.airport_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airports.airport_code IS 'Airport code, IATA';


--
-- Name: COLUMN airports.airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airports.airport_name IS 'Airport name';


--
-- Name: COLUMN airports.city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airports.city IS 'City';


--
-- Name: COLUMN airports.country; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airports.country IS 'Country';


--
-- Name: COLUMN airports.coordinates; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airports.coordinates IS 'Airport coordinates (longitude and latitude)';


--
-- Name: COLUMN airports.timezone; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.airports.timezone IS 'Airport time zone';


--
-- Name: boarding_passes; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.boarding_passes (
    ticket_no text NOT NULL,
    flight_id integer NOT NULL,
    seat_no text NOT NULL,
    boarding_no integer,
    boarding_time timestamp with time zone
);


--
-- Name: TABLE boarding_passes; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE bookings.boarding_passes IS 'Boarding passes';


--
-- Name: COLUMN boarding_passes.ticket_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.boarding_passes.ticket_no IS 'Ticket number';


--
-- Name: COLUMN boarding_passes.flight_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.boarding_passes.flight_id IS 'Flight ID';


--
-- Name: COLUMN boarding_passes.seat_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.boarding_passes.seat_no IS 'Seat number';


--
-- Name: COLUMN boarding_passes.boarding_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.boarding_passes.boarding_no IS 'Boarding pass number';


--
-- Name: COLUMN boarding_passes.boarding_time; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.boarding_passes.boarding_time IS 'Boarding time';


--
-- Name: bookings; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.bookings (
    book_ref character(6) NOT NULL,
    book_date timestamp with time zone NOT NULL,
    total_amount numeric(10,2) NOT NULL
);


--
-- Name: TABLE bookings; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE bookings.bookings IS 'Bookings';


--
-- Name: COLUMN bookings.book_ref; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.bookings.book_ref IS 'Booking number';


--
-- Name: COLUMN bookings.book_date; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.bookings.book_date IS 'Booking date';


--
-- Name: COLUMN bookings.total_amount; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.bookings.total_amount IS 'Total booking amount';


--
-- Name: flights; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.flights (
    flight_id integer NOT NULL,
    route_no text NOT NULL,
    status text NOT NULL,
    scheduled_departure timestamp with time zone NOT NULL,
    scheduled_arrival timestamp with time zone NOT NULL,
    actual_departure timestamp with time zone,
    actual_arrival timestamp with time zone,
    CONSTRAINT flight_actual_check CHECK (((actual_arrival IS NULL) OR ((actual_departure IS NOT NULL) AND (actual_arrival IS NOT NULL) AND (actual_arrival > actual_departure)))),
    CONSTRAINT flight_scheduled_check CHECK ((scheduled_arrival > scheduled_departure)),
    CONSTRAINT flight_status_check CHECK ((status = ANY (ARRAY['Scheduled'::text, 'On Time'::text, 'Delayed'::text, 'Boarding'::text, 'Departed'::text, 'Arrived'::text, 'Cancelled'::text])))
);


--
-- Name: TABLE flights; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE bookings.flights IS 'Flights';


--
-- Name: COLUMN flights.flight_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.flights.flight_id IS 'Flight ID';


--
-- Name: COLUMN flights.route_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.flights.route_no IS 'Route number';


--
-- Name: COLUMN flights.status; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.flights.status IS 'Flight status';


--
-- Name: COLUMN flights.scheduled_departure; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.flights.scheduled_departure IS 'Scheduled departure time';


--
-- Name: COLUMN flights.scheduled_arrival; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.flights.scheduled_arrival IS 'Scheduled arrival time';


--
-- Name: COLUMN flights.actual_departure; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.flights.actual_departure IS 'Actual departure time';


--
-- Name: COLUMN flights.actual_arrival; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.flights.actual_arrival IS 'Actual arrival time';


--
-- Name: flights_flight_id_seq; Type: SEQUENCE; Schema: bookings; Owner: -
--

ALTER TABLE bookings.flights ALTER COLUMN flight_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bookings.flights_flight_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: routes; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.routes (
    route_no text NOT NULL,
    validity tstzrange NOT NULL,
    departure_airport character(3) NOT NULL,
    arrival_airport character(3) NOT NULL,
    airplane_code character(3) NOT NULL,
    days_of_week integer[] NOT NULL,
    scheduled_time time without time zone NOT NULL,
    duration interval NOT NULL
);


--
-- Name: TABLE routes; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE bookings.routes IS 'Routes';


--
-- Name: COLUMN routes.route_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.routes.route_no IS 'Route number';


--
-- Name: COLUMN routes.validity; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.routes.validity IS 'Period of validity';


--
-- Name: COLUMN routes.departure_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.routes.departure_airport IS 'Airport of departure';


--
-- Name: COLUMN routes.arrival_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.routes.arrival_airport IS 'Airport of arrival';


--
-- Name: COLUMN routes.airplane_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.routes.airplane_code IS 'Airplane code, IATA';


--
-- Name: COLUMN routes.days_of_week; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.routes.days_of_week IS 'Days of week array';


--
-- Name: COLUMN routes.scheduled_time; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.routes.scheduled_time IS 'Scheduled local time of departure';


--
-- Name: COLUMN routes.duration; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.routes.duration IS 'Estimated duration';


--
-- Name: seats; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.seats (
    airplane_code character(3) NOT NULL,
    seat_no text NOT NULL,
    fare_conditions text NOT NULL,
    CONSTRAINT seat_fare_conditions_check CHECK ((fare_conditions = ANY (ARRAY['Economy'::text, 'Comfort'::text, 'Business'::text])))
);


--
-- Name: TABLE seats; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE bookings.seats IS 'Seats';


--
-- Name: COLUMN seats.airplane_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.seats.airplane_code IS 'Airplane code, IATA';


--
-- Name: COLUMN seats.seat_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.seats.seat_no IS 'Seat number';


--
-- Name: COLUMN seats.fare_conditions; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.seats.fare_conditions IS 'Travel class';


--
-- Name: segments; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.segments (
    ticket_no text NOT NULL,
    flight_id integer NOT NULL,
    fare_conditions text NOT NULL,
    price numeric(10,2) NOT NULL,
    CONSTRAINT segments_fare_conditions_check CHECK ((fare_conditions = ANY (ARRAY['Economy'::text, 'Comfort'::text, 'Business'::text]))),
    CONSTRAINT segments_price_check CHECK ((price >= (0)::numeric))
);


--
-- Name: TABLE segments; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE bookings.segments IS 'Flight segment (leg)';


--
-- Name: COLUMN segments.ticket_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.segments.ticket_no IS 'Ticket number';


--
-- Name: COLUMN segments.flight_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.segments.flight_id IS 'Flight ID';


--
-- Name: COLUMN segments.fare_conditions; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.segments.fare_conditions IS 'Travel class';


--
-- Name: COLUMN segments.price; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.segments.price IS 'Travel price';


--
-- Name: tickets; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.tickets (
    ticket_no text NOT NULL,
    book_ref character(6) NOT NULL,
    passenger_id text NOT NULL,
    passenger_name text NOT NULL,
    outbound boolean NOT NULL
);


--
-- Name: TABLE tickets; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE bookings.tickets IS 'Tickets';


--
-- Name: COLUMN tickets.ticket_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.tickets.ticket_no IS 'Ticket number';


--
-- Name: COLUMN tickets.book_ref; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.tickets.book_ref IS 'Booking number';


--
-- Name: COLUMN tickets.passenger_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.tickets.passenger_id IS 'Passenger ID';


--
-- Name: COLUMN tickets.passenger_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.tickets.passenger_name IS 'Passenger name';


--
-- Name: COLUMN tickets.outbound; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.tickets.outbound IS 'Outbound flight?';


--
-- Name: timetable; Type: VIEW; Schema: bookings; Owner: -
--

CREATE VIEW bookings.timetable AS
 SELECT f.flight_id,
    f.route_no,
    r.departure_airport,
    r.arrival_airport,
    f.status,
    r.airplane_code,
    f.scheduled_departure,
    (f.scheduled_departure AT TIME ZONE dep.timezone) AS scheduled_departure_local,
    f.actual_departure,
    (f.actual_departure AT TIME ZONE dep.timezone) AS actual_departure_local,
    f.scheduled_arrival,
    (f.scheduled_arrival AT TIME ZONE arr.timezone) AS scheduled_arrival_local,
    f.actual_arrival,
    (f.actual_arrival AT TIME ZONE arr.timezone) AS actual_arrival_local
   FROM (((bookings.flights f
     JOIN bookings.routes r ON (((r.route_no = f.route_no) AND (r.validity @> f.scheduled_departure))))
     JOIN bookings.airports_data dep ON ((dep.airport_code = r.departure_airport)))
     JOIN bookings.airports_data arr ON ((arr.airport_code = r.arrival_airport)));


--
-- Name: VIEW timetable; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON VIEW bookings.timetable IS 'Detailed info about flights';


--
-- Name: COLUMN timetable.flight_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.flight_id IS 'Flight ID';


--
-- Name: COLUMN timetable.route_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.route_no IS 'Route number';


--
-- Name: COLUMN timetable.departure_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.departure_airport IS 'Airport of departure';


--
-- Name: COLUMN timetable.arrival_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.arrival_airport IS 'Airport of arrival';


--
-- Name: COLUMN timetable.status; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.status IS 'Flight status';


--
-- Name: COLUMN timetable.airplane_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.airplane_code IS 'Airplane code, IATA';


--
-- Name: COLUMN timetable.scheduled_departure; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.scheduled_departure IS 'Scheduled departure time';


--
-- Name: COLUMN timetable.scheduled_departure_local; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.scheduled_departure_local IS 'Scheduled departure time in airport''s timezone';


--
-- Name: COLUMN timetable.actual_departure; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.actual_departure IS 'Actual departure time';


--
-- Name: COLUMN timetable.actual_departure_local; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.actual_departure_local IS 'Actual departure time in airport''s timezone';


--
-- Name: COLUMN timetable.scheduled_arrival; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.scheduled_arrival IS 'Scheduled arrival time';


--
-- Name: COLUMN timetable.scheduled_arrival_local; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.scheduled_arrival_local IS 'Scheduled arrival time in airport''s timezone';


--
-- Name: COLUMN timetable.actual_arrival; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.actual_arrival IS 'Actual arrival time';


--
-- Name: COLUMN timetable.actual_arrival_local; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.timetable.actual_arrival_local IS 'Actual arrival time in airport''s timezone';