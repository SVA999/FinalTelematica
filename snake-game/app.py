import flask

app = flask.Flask(__name__)

@app.route("/")
def home():
    return "este es el servidor servicios1"

@app.route("/api1")
def api1():
    return "funcion retorno api1"

@app.route("/api2")
def api2():
    return "funcion retorno api2"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)