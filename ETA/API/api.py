import flask
from flask import request
import sklearn
import joblib
from flask_cors import CORS, cross_origin 
import json
from numpyencoder import NumpyEncoder

# cores handling
app = flask.Flask(__name__)
app.config["DEBUG"] = True
CORS(app)

# prediction endpoint
@app.route('/predict', methods=['GET'])
@cross_origin()
def Predict():
    # loading clusternig model
    cluster = joblib.load("Cluster.pkl") # Load "Clustet.pkl"
    results = cluster.predict([[request.args.get("center"),request.args.get("lat"), request.args.get("long"),request.args.get("distance"),request.args.get("humadity"),request.args.get("wind_speed"),request.args.get("propoler_size"),request.args.get("max_speed"),request.args.get("altitude"),request.args.get("weight"),request.args.get("ETA")]]);
    print ('Model loaded')

    # loading scaller model
    mms = joblib.load("mms_reg.pkl") # Load "Clustet.pkl"

    # transform data
    t_x = mms.transform([[request.args.get("center"),request.args.get("lat"), request.args.get("long"),request.args.get("distance"),request.args.get("humadity"),request.args.get("wind_speed"),request.args.get("propoler_size"),request.args.get("max_speed"),request.args.get("altitude"),request.args.get("weight"),results[0]]])
    ETA = PredictReg(t_x, results);
    resObj = {"cluster": results[0], "ETA": ETA[0]}
    json_res = json.dumps(resObj,cls=NumpyEncoder)
    return json_res

# predicting using reg model
def PredictReg(details, cluster):
    if(cluster == [0]):
        Model = joblib.load("reg_1.pkl") # Load "reg_1.pkl" for cluster one
        results = Model.predict(details);
        print ('Model loaded')
        print (results)
        return results;
    else:
        Model = joblib.load("reg_2.pkl") # Load "reg_2.pkl for cluster two
        results = Model.predict(details);
        print ('Model loaded')
        print (results)
        return results;

app.run()