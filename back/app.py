import get_data
from flask import Flask, jsonify #pip install Flask
from flask_cors import CORS #pip install flask_cors

app = Flask(__name__)
CORS(app)
@app.route("/")
def show_data():
    return jsonify(get_data.select_data())

if __name__ == "__main__":
    app.run(debug=True)

#get_data(url, start_date, end_date)
#select_data()