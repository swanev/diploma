import get_data
from flask import Flask, jsonify #pip install Flask
from flask_cors import CORS #pip install flask_cors

app = Flask(__name__)
CORS(app)
@app.route("/")
def show_data():
    return jsonify(get_data.select_data())

@app.route("/create")
def create_table():
    return get_data.create_table(get_data.url, get_data.start_date, get_data.end_date)

@app.route("/update")
def update_data():
    return get_data.update_data(get_data.url, get_data.start_date, get_data.end_date)

if __name__ == "__main__":
    app.run(host='0.0.0.0')