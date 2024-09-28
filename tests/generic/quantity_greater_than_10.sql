{% test quantity_greater_than_10(model,column_name) %}
    select {{column_name}} from {{model}} where {{column_name}}>12


{% endtest %}