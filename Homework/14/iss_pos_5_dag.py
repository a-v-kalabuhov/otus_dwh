import urllib3
import json
from datetime import datetime, timedelta
from airflow.decorators import dag, task
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.http.operators.http import SimpleHttpOperator


@dag(
    schedule_interval=timedelta(minutes=60),
    start_date=datetime(2025, 1, 1),
    catchup=False,
)


def iss_position_tracking_5():
    
    # Создаём таблицу в базе данных, 
    # если она ещё не создана
    create_iss_position_table = PostgresOperator(
        task_id="create_iss_position_table",
        postgres_conn_id="pgsql",
        sql="""
            CREATE TABLE IF NOT EXISTS public.iss_position (
            latitude float4 NOT NULL,
            longitude float4 NOT NULL,
            message varchar NOT NULL,
            pos_timestamp int4 PRIMARY KEY);
            """
    )

    # Получаем текущее положение МКС в виде json'а.
    # Из полученного json'а кладём данные в XCom
    @task()
    def download_iss_position(**context):
        # Скачиваем json
        http = urllib3.PoolManager()
        url = 'http://api.open-notify.org/iss-now.json'
        response = http.request('GET', url)
        obj = json.loads(response.data.decode('utf-8'))
        # Кладём поля json'а в XCom
        result = dict()
        iss = obj["iss_position"]
        context["ti"].xcom_push(key="latitude", value=iss["latitude"])
        context["ti"].xcom_push(key="longitude", value=iss["longitude"])
        context["ti"].xcom_push(key="message", value = obj["message"])
        context["ti"].xcom_push(key="pos_timestamp", value = obj["timestamp"])
        return result

    # Вытаскиваем из XCom данные о положении МКС.
    # Формируем текст SQL-запроса на всавку записи в таблицу.
    # Выполняем запрос с помощью PostgresOperator.
    @task()
    def load(**context):
        # 1. Вытаскиваем данные из XCom
        lat = context["ti"].xcom_pull(task_ids='download_iss_position', key='latitude')
        lon = context["ti"].xcom_pull(task_ids='download_iss_position', key='longitude')
        message = context["ti"].xcom_pull(task_ids='download_iss_position', key='message')
        pos_timestamp = context["ti"].xcom_pull(task_ids='download_iss_position', key='pos_timestamp')
        # 2. Формируем запрос
        sql1 = 'INSERT INTO public.iss_position (latitude, longitude, message, pos_timestamp) '
        sql2 = f"VALUES({lat},{lon},'{message}',{pos_timestamp});"
        sql_text = sql1 + sql2
        # 3. Выполняем запрос
        PostgresOperator(
            task_id="insert_data_to_db",
            postgres_conn_id="pgsql",
            sql=sql_text
        ).execute({})

    # выполняем цепочку задач DAG'а
    create_iss_position_table >> download_iss_position() >> load()


dag = iss_position_tracking_5()