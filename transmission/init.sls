{% from "transmission/map.jinja" import transmission with context %}

# install package and run servie
transmission:
  pkg.installed:
    - name: {{ transmission.pkg }}
  service.running:
    - enable: True
    - name: {{ transmission.service }}
    - require:
      - pkg: transmission
    - watch:
      - file: transmission_config

# copy config 
transmission_config:
  file.managed:
    - name: {{ transmission.config }}
    - source: {{ transmission.config_src }} 
    - template: jinja
    - user: {{ transmission.user }}
    - group: {{ transmission.group }}
    - require:
      - pkg: transmission
