from flask import Flask, request, abort, jsonify, Response
import cv2
import jsonpickle
import numpy as np

app = Flask(__name__)


#app.config["DEBUG"] = True

@app.route("/")
def home():
	return "music score flask api!"



@app.route('/api/get_score', methods=['POST'])
def check_fashion_status():
	nparr = np.fromstring(request.data, np.uint8)
	img = cv2.imdecode(nparr, 1)
	cv2.imwrite('received.jpeg', img)
	response = {'message': 'image received. size={}x{}'.format(img.shape[1], img.shape[0])}
	# encode response using jsonpickle
	response_pickled = jsonpickle.encode(response)

	return Response(response=response_pickled, status=200, mimetype="application/json")

if __name__ == "__main__":
	app.run(debug=True)
