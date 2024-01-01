from flask import Flask, render_template, request
from pyswip import Prolog

app = Flask(__name__)
prolog = Prolog()
prolog.consult("prolog_todolist.pl")

commands = [
    {"name": "add", "description": "Add a new cornea"},
    {"name": "display", "description": "Display all cornea"},
    {"name": "update", "description": "Update a cornea"},
    {"name": "test", "description": "Mark a cornea as tested"},
    {"name": "discard", "description": "Discard a cornea"},
    {"name": "distribute", "description": "Mark a cornea as distributed"},
    {"name": "exit", "description": "Exit Eye bank management system"}
]

@app.route("/")
def home():
    return render_template("index.html", commands=commands)

@app.route("/execute", methods=["POST"])
def execute():
    command = request.form["command"]
    result = list(prolog.query("execute_command({})".format(command)))
    return render_template("result.html", result=result)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080, debug=True)