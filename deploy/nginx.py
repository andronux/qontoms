import sys
import os
import re
from jinja2 import Environment, FileSystemLoader

if __name__ == '__main__':

    templates_dir = os.path.join(os.path.dirname(__file__), 'templates')
    jinja_env = Environment(loader=FileSystemLoader(templates_dir))
    template = jinja_env.get_template(sys.argv[1]+'.jinja')
    result = template.render({'branch': sys.argv[2]})

    print(result)
    with open('/etc/nginx/sites-enabled/'+sys.argv[1], 'w') as f:
      f.write(result)
