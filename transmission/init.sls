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
      - file: transmission_config
    - watch:
      - file: transmission_config

# set config file
transmission_config:
  file.directory:
    - name: {{ transmission.config_folder }}
    - makedirs: True
    - user: {{ transmission.user }}
    - group: {{ transmission.group }}
  file.managed:
    - name: {{ transmission.config_folder }}/{{ transmission.config_file }}
    - source: {{ transmission.config_src }} 
    - template: jinja
    - user: {{ transmission.user }}
    - group: {{ transmission.group }}
    - require:
      - pkg: transmission
      - service: transmission_config
  service.dead:
    - name: {{ transmission.service }}
    - require:
      - pkg: transmission