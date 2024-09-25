{% macro clone_db_macro(src_db,trg_db) %}
    {% set sqlquery %}
        create database {{trg_db}} clone {{src_db}}
    {% endset%}
    {% do run_query(sqlquery)%}
{% endmacro %}