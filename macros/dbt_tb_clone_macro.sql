{% macro db_sc_tb_clone(src_db,src_sc,trg_db,trg_sc,tbl_list) %}
{% set create_db %}
    create database {{trg_db}}
{% endset %}
{% do run_query(create_db) %}

{% set create_sc %}
    create schema {{trg_db}}.{{trg_sc}}
{% endset %}
{% do run_query(create_sc) %}

{% for tbl in tbl_list %}
    {% set source_table= src_db~'.'~src_sc~'.'~tbl %}
    {% set target_table= trg_db~'.'~trg_sc~'.'~tbl %}

    {% set create_tb %}
        create or replace table {{target_table}} clone {{source_table}}
    {% endset %}
    {% do run_query(create_tb) %}
{% endfor %}
{% endmacro %}
