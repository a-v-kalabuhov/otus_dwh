Отчёт по ДЗ к занятию «Оркестрация c Apache AirFlow».

1. Создан работающий облачный инстанс Apache Airflow.
    - Веб-интерфейс доступен по [ссылке](https://c-c9qoqhmsgnpqocr8qqb5.airflow.yandexcloud.net/)
    - Логин: admin
    - Pwd: AirFlow-00
2. Создан кластер СУБД PostgreSQL.
    - Хост: rc1d-9jdjg4ss2vmhlc1i.mdb.yandexcloud.net
    - Порт: 6432
    - Схема: db1
    - Логин: user1
    - Pwd: yclrW+zA)FlHTz+]6iK9Y6^H-6j>W5IHKsXI

2. Создан pipeline, содержащий в себе несколько task-ов и "крутящийся" по расписанию Airflow:
    Для выполнения ДЗ я реализовал загрузку данных о положении МКС в базу данных PostgreSQL.
    Исходный код piplen'а доступн в [файле](./iss_pos_5_dag.py).
    При создании pipeline я применил смешанный подход - использовал операторы и TaskFlow.

    Pipeline состоит из следующих задач:
    |Задача|id задачи|Реализаця|Описание|
    |---|---|---|---|
    |Подготовка структуры БД|create_iss_position_table|PostgresOperator|Создание таблицы в БД, если она ещё не создана|
    |Получение и преобразование данных|download_iss_position|task|Получает текущее положение МКС в виде json'а и кладёт эти данные в XCom, чтобы передать следующей задаче|
    |Сохранение данных в БД|load|task и вложенный PostgresOperator|Вытаскивает данные из XCom и сохраняет их в таблицу БД с помощью PostgresOperator|
    