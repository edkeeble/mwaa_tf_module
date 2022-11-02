from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
import pendulum
import logging


def log_task(text:str):
    logging.info(text)

dag =  DAG(
    dag_id= "csda_workflow",
    start_date= pendulum.today('UTC').add(days=-14),
    schedule_interval=None
)
get_data_from_planet = BashOperator(
        task_id = "get_data_from_planet",
        bash_command= "echo 'I am getting the data'",
        dag = dag,
    )
convert_to_csv = PythonOperator(
        task_id = "convert_to_csv",
        python_callable=log_task,
        op_kwargs={'text': 'I am supposed to convert something to CSV'},
        dag = dag,
    )
notify = BashOperator(
        task_id = "notify",
        bash_command='echo "I am supposed to notify you that everything went well!"',
        dag = dag,
    )

get_data_from_planet >> convert_to_csv >> notify

