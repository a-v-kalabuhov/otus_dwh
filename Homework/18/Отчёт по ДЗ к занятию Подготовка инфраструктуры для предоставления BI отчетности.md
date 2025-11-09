## Отчёт по ДЗ к занятию «Подготовка инфраструктуры для предоставления BI отчетности»

<hr>

### **Задача:** 

1. Развернуть BI решение
2. Подключить источник данных
3. Построить дашборд

<hr>

### *Результат:*

1. Развернул ClickHouse и Apache Superset.

По мануалу [Using Docker Compose](https://superset.apache.org/docs/installation/docker-compose) развернул Superset в локальном инстансе Docker.<br>
Для подключения ClickHouse добавил в репозитарии файл docker\requirements-local.txt, и в него вписал пакет clickhouse-connect.
Скриншот GUI Superset: ![image](./superset-running.png)

По мануалу [Install ClickHouse using Docker](https://clickhouse.com/docs/install/docker) также развернул ClickHouse, и по мануалу [Данные такси Нью-Йорка](https://clickhouse.com/docs/ru/getting-started/example-datasets/nyc-taxi) залил в него датасет жёлтого такси Нью-Йорка.<br>
Скриншот датасета в CH: ![image](./ch-trips.png)

### *Возникшие проблемы:*

Superset зависал после завершения инициализации инстанса.<br>
Контейнер superset-app не стартовал. Я смотрел логи контейнеров, и пришёл к выводу, что возникла какая-то пробема с Node.js.
Развернул всю инфраструктуру с нуля и проблема самоустранилась. 

<hr>

2. Подключил ClickHouse к Superset.

В GUI Superset добавил новое соединение к СУБД: ![image](./ch-db-settings.png)

<hr>

3. Построить дашборд

Создал новый дашборд с двумя вкладками и общим на весь дашборд фильтром.

Вкладка 1: ![image](./Такси-Нью-Йорка-стр1.png)
Использованные типы диаграмм:

- Pie Chart
- Bar Chart
- Table
- Line Chart

<br>
Вкладка 2: ![image](./Такси-Нью-Йорка-стр2.png)
Использованные типы диаграмм:

- Big Number
- Word Cloud
- Box Plot
- Gauge Chart

Всего восемь диаграмм, из них 4 - нестандартные.
