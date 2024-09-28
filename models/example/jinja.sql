{%- set country=['USA','uk','germany','japan'] -%}
{%- for country in country -%}
My country is:{{ country | upper}}
{% endfor %}

{%- set my_score=89 -%}
{%- set passing_score=35 -%}
{%- if my_score > passing_score -%}
You have passed the exam!
{% else %}
You have failed the exam!
{% endif %}