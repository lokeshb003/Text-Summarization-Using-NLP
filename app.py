from flask import Flask, request, render_template
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.corpus import stopwords
from nltk.probability import FreqDist
from string import punctuation
import heapq
import requests
import json
app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/summarize', methods=['POST'])
def summarize():
    text = request.form['text']
    sentences = sent_tokenize(text)
    words = word_tokenize(text)

    stop_words = set(stopwords.words('english') + list(punctuation))
    words = [word for word in words if word.lower() not in stop_words]

    word_frequencies = FreqDist(words)

    maximum_frequency = max(word_frequencies.values())

    for word in word_frequencies.keys():
        word_frequencies[word] = (word_frequencies[word]/maximum_frequency)

    sentence_scores = {}
    for sent in sentences:
        for word in word_tokenize(sent.lower()):
            if word in word_frequencies.keys():
                if len(sent.split(' ')) < 30:
                    if sent not in sentence_scores.keys():
                        sentence_scores[sent] = word_frequencies[word]
                    else:
                        sentence_scores[sent] += word_frequencies[word]

    summary_sentences = heapq.nlargest(7, sentence_scores, key=sentence_scores.get)
    summary = ' '.join(summary_sentences)
    json = {
        'text': summary
    }
    headers = {
        "Content-Type": "application/json"
    }
    url = "https://hooks.slack.com/services/WEBHOOK_URL"

    response = requests.post(url,headers=headers,json=json)
    return render_template('index.html', summary=summary)


if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0', port=8080)
