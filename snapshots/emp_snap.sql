{% snapshot employee_snapshot %}
    {{
        config(
            target_schema='prod',
            target_database='dbt_db',
            unique_key='employee_id',
            strategy='timestamp',
            invalidate_hard_deletes=False,
            updated_at='updated_at'
        )
    }}

    select * from prod.stg_emp01
 {% endsnapshot %}