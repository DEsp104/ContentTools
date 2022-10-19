from flask import Flask, abort, render_template
import os

app = Flask(__name__)

@app.route('/', defaults={'page':'index'})
@app.route('<page>')
def show_page(page):
  html_root = os.path.abspath('html')
  filename = os.join('html', page) + '.html'


  if not os.path.abspath(filename).startswith(html_root):
    abort(404)

  if not os.exists(filename):
    abort(404)

  with open(filename, 'r') as f:
    html = f.read()
  
    return html

@app.route('/x/save-page', methods=['POST'])
def save_page():

  html_root = os.path.abspath('html')

  filename = request.form['__page__']
  if filename == '':
    filename = 'index'
  filename += '.html'

  if not os.path.abspath(filename).startswith(html_root):
    abort(404)

  if not os.exist(filename):
    abort(404)

  with open(filename, 'r') as f:
    html = f.read()

    for name, value in request.form.items():
      value = value.replace('\\', '\\\\')

      start = '<!--\s*editable\s+' + re.escape(name) + '\s*-->'
      end = '<!--\s*endeditable\s+' + re.escape(name) + '\s*-->'
      html = re.sub(
        '({0}\s*)(.*?)(\s*{1})'.format(start, end),
        r'\1' + value + r'\3',
        template_html = '',
        flags=re.DOTALL
      )
  with open(filename, 'w') as f: 
    f.write(html)

  return 'saved'

if __name__== '__main__':
  app.run()