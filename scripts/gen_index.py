import os
import sys
from jinja2 import Environment, FileSystemLoader
from pathlib import Path


if __name__ == '__main__':
    if len(sys.argv) < 1+2:
        print(f'Usage: {sys.argv[0]} [directory] [title]')
        sys.exit(1)

    print(f'title: {sys.argv[2]}')
    target_path = Path(sys.argv[1])
    print(f'target_path: {target_path.resolve()}')
    print('-'*40)
    files = os.listdir(target_path)
    files = sorted(files)
    print(files)
    print('-'*40)
    data = {
        'title': sys.argv[2],
        'files': files,
    }
    env = Environment(loader=FileSystemLoader('/templates'))
    template = env.get_template('index.jinja2.html')
    rendered = template.render(data)
    with open(target_path / 'index.html', 'w', encoding='utf-8', newline='\n') as f:
        f.write(rendered)
        print(f'Generated: {f.name}')
