import pendulum
from airflow import DAG
import airflow
from airflow.operators.python import PythonOperator
#from airflow.providers.amazon.aws.sensors.s3 import S3KeySensor
from airflow.providers.amazon.aws.sensors.s3_prefix import S3PrefixSensor
from datetime import timedelta
def generic_copy(text):
    print(text)
    return

def process(text):
    print(text)
    return
def metrics(text):
    print(text)
    return
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': airflow.utils.dates.days_ago(1),
    'retries': 0,
    'retry_delay': timedelta(minutes=2),
    'provide_context': True,
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False
}
with DAG(
    dag_id="sensor_ex_1",
    default_args=default_args,
    description="Testing sensors in the cloud"
) as dag:
    wait_for_file = S3PrefixSensor(task_id="wait_for_file",
                                bucket_name="amarouane-uat-impact-mwaa-350996086543",
                                prefix="sensors",
                                dag=dag,
                                aws_conn_id= "aws_s3_conn"
                                )
    copy_to_raw_1 = PythonOperator(
        task_id="copy_to_raw_1",
        python_callable=generic_copy,
        op_kwargs={'text': "Task 1"}
    )
    copy_to_raw_2 = PythonOperator(
        task_id="copy_to_raw_2",
        python_callable=generic_copy,
        op_kwargs={'text': "Task 2"}

    )
    copy_to_raw_3 = PythonOperator(
        task_id="copy_to_raw_3",
        python_callable=generic_copy,
        op_kwargs={'text': "Task 3"}

    )
    copy_to_raw_4 = PythonOperator(
        task_id="copy_to_raw_4",
        python_callable=generic_copy,
        op_kwargs={'text': "Task 4"}
    )
    process_super_1 = PythonOperator(
        task_id="process_super_1",
        python_callable=process,
        op_kwargs={'text': "Task 1"}

    )
    process_super_2 = PythonOperator(
        task_id="process_super_2",
        python_callable=process,
        op_kwargs={'text': "Task 2"}

    )
    process_super_3 = PythonOperator(
        task_id="process_super_3",
        python_callable=process,
        op_kwargs={'text': "Task 3"}

    )
    process_super_4 = PythonOperator(
        task_id="process_super_4",
        python_callable=process,
        op_kwargs={'text': "Task 4"}

    )

    create_metrics = PythonOperator(
        task_id="create_metrics",
        python_callable=metrics,
        op_kwargs=({'text': "Create Metrics"})
    )
    wait_for_file >> copy_to_raw_1 >> process_super_1 >> create_metrics
    wait_for_file >> copy_to_raw_2 >> process_super_2 >> create_metrics
    wait_for_file >> copy_to_raw_3 >> process_super_3 >> create_metrics
    wait_for_file >> copy_to_raw_4 >> process_super_4 >> create_metrics



