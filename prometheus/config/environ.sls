# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if 'environ' in prometheus and prometheus.environ %}
    {%- if prometheus.pkg.use_upstream_archive %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}

include:
  - {{ sls_package_install }}

prometheus-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ prometheus.environ_file }}
    - source: {{ files_switch(['prometheus.sh.jinja'],
                              lookup='prometheus-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ prometheus.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        config: {{ prometheus.environ|json }}
    - require:
      - sls: {{ sls_package_install }}

    {%- endif %}
{%- endif %}
