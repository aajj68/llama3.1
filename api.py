from flask import Flask, request, jsonify, render_template
from ollama import Client

app = Flask(__name__)
client = Client(host='http://localhost:9090')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/detect_language', methods=['POST'])
def detect_language():
    text = request.form['text']
    response = client.chat(model='llama-3.1', messages=[
        {
            'role': 'user',
            'content': f'Identify the dominant language of the following text: "{text}"',
        },
    ])
    language = response['message'].strip()
    return jsonify({'language': language})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9095)
