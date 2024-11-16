# -- coding: utf-8 --
import click
import flask
from flask import Flask

app = Flask(_name_)

# the minimal Flask application
@app.route('/')
def index():
    return '<h1>Esta pagina te recibe con un saludo!</h1>'


# bind multiple URL for one view function
@app.route('/hola')
@app.route('/hola1')
def say_hello():
    return '<h1>Hola, Flask!</h1>'

# dynamic route, URL variable default
@app.route('/saludo', defaults={'name': 'Programmer'})
@app.route('/saludo/<name>')
def greet(name):
    return '<h1>Hello, %s!</h1>' % name

# custom flask cli command
@app.cli.command()
def hello():
    """HOLA BIENVENIDO."""
    click.echo('Hola Humano, estoy pensando!')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)