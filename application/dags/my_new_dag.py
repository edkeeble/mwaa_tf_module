from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
import pendulum
import logging


def log_task(text:str):
    logging.info(text)

dag =  DAG(
    dag_id= "example_flow",
    start_date= pendulum.today('UTC').add(days=-14),
    schedule_interval=None
)
get_picture = BashOperator(
        task_id = "get_picture",
        bash_command= "curl https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png  --output /tmp/640px-Image_created_with_a_mobile_phone.png",
        dag = dag,
    )
process_image = PythonOperator(
        task_id = "process_image",
        python_callable=log_task,
        op_kwargs={'text': 'I am supposed to process an image'},
        dag = dag,
    )
notify = BashOperator(
        task_id = "notify",
        bash_command="echo 'I have detected' && ls -al /tmp/*.png",
        dag = dag,
    )

get_picture >> process_image >> notify

