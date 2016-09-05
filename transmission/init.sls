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
      - file: transmission_config_file
    - onchanges:
      - file: transmission_config_file

#config folder needs to be present to create the config
transmission_config_folder:  
  file.directory:
    - name: {{ transmission.config_folder }}
    - makedirs: True
    - user: {{ transmission.user }}
    - group: {{ transmission.group }}
    - require:
      - pkg: transmission    
      
# set config file
transmission_config_file:
  file.managed:
    - name: {{ transmission.config_folder }}/{{ transmission.config_file }}
    - source: {{ transmission.config_src }} 
    - template: jinja
    - user: {{ transmission.user }}
    - group: {{ transmission.group }}
    - require:
      - file: transmission_config_folder
  service.dead:
    - name: {{ transmission.service }}
    - require:
      - pkg: transmission
    - prereq:
      - file: transmission_config_file