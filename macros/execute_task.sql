{% macro execute_task(task_name) %}
  {% do run_query("EXECUTE TASK " ~ task_name) %}
  {{ log("Triggered task: " ~ task_name, info=True) }}
{% endmacro %}