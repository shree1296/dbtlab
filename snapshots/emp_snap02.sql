{% snapshot employee_snapshot02 %}
    {{
        config(
            target_schema='prod',
            target_database='dbt_db',
            unique_key='employee_id',
            strategy='check',
            invalidate_hard_deletes=False,
            check_cols=['employee_name','State']
        )
    }}

    select * from prod.stg_emp02
 {% endsnapshot %}