from flask import Flask, render_template
from flask_restful import Resource, Api, reqparse
import requests
import ast
import json

app = Flask(__name__)
api = Api(app)

@app.route("/")
def homepage():
    return render_template("index.html", title="HOME PAGE")

class LocationService(Resource):
    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('start_latitude', required=True, type=float)
        parser.add_argument('start_longitude', required=True, type=float)
        parser.add_argument('end_latitude', required=True, type=float)
        parser.add_argument('end_longitude', required=True, type=float)
        parser.add_argument('userID', required=True, type=int)
        args = parser.parse_args()
        projectID = "flutter-ade80"
        key = "" #PROJECT KEY
        doc = f"users/{args['userID']}"
        url = f"https://firestore.googleapis.com/v1beta1/projects/{projectID}/databases/(default)/documents/{doc}?key={key}"
        patch_url = f"https://firestore.googleapis.com/v1beta1/projects/{projectID}/databases/(default)/documents/{doc}?updateMask.fieldPaths=Distance&updateMask.fieldPaths=ETA&updateMask.fieldPaths=Latitude&updateMask.fieldPaths=Longitude&update.fieldPaths=Past_Locations&key={key}"
        Google_API = "" # GOOGLE API KEY
        api_request = f"https://maps.googleapis.com/maps/api/directions/json?origin={args['start_latitude']},{args['start_longitude']}&destination={args['end_latitude']},{args['end_longitude']}&key={Google_API}"
        to_return = ""

        response = requests.get(api_request)
        json_obj = json.loads(response.text)
        distance = json_obj['routes'][0]['legs'][0]['distance']['value']
        ETA = json_obj['routes'][0]['legs'][0]['duration']['value']

        response2 = requests.get(url)
        json_obj2 = json.loads(response2.text)
        prev_distance = json_obj2['fields']['Distance']['doubleValue']
        prev_ETA =  json_obj2['fields']['ETA']['doubleValue']

        myobj = "{\r\n\"fields\": {\r\n\"Distance\": {\r\n\"doubleValue\":"
        myobj2 = f"{myobj}{distance}"
        myobj3 = "\r\n},\r\n\"ETA\": {\r\n\"doubleValue\":"
        myobj6 = "\r\n},\r\n\"Latitude\": {\r\n\"doubleValue\":"
        myobj7 = "\r\n},\r\n\"Longitude\": {\r\n\"doubleValue\":"
        myobj4 = "\r\n}\r\n}\r\n}"
        myobj5 = f"{myobj2}{myobj3}{ETA}{myobj6}{args['start_latitude']}{myobj7}{args['start_longitude']}{myobj4}"
        response3 = requests.patch(patch_url, data = myobj5)
        json_obj3 = json.loads(response3.text)

        if prev_distance > distance and prev_ETA > ETA:
            to_return = "Warning"
        else:
            to_return = "Safe"

        return {
            'safety_level': f"{to_return}",
            'ETA': f"{ETA}"
        }, 200

class ShareLocationService(Resource):
    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('friendID', required=True, type=int)
        parser.add_argument('userID', required=True, type=int)
        args = parser.parse_args()
        projectID = "flutter-ade80"
        key = "" #PROJECT KEY
        doc = f"users/{args['friendID']}"
        url = f"https://firestore.googleapis.com/v1beta1/projects/{projectID}/databases/(default)/documents/{doc}?key={key}"
        to_return = "Not Authenticated"

        response2 = requests.get(url)
        json_obj2 = json.loads(response2.text)
        latitude = json_obj2['fields']['Latitude']['doubleValue']
        longitude = json_obj2['fields']['Longitude']['doubleValue']
        friend_list = json_obj2['fields']['Friends']['arrayValue']['values']

        x = 0
        for friend in friend_list:
            check = friend_list[x]['integerValue']
            if int(check) == int(args['userID']):
                to_return = f"http://maps.google.com/maps?q=description+(name)+%40{latitude},{longitude}"
            x = x + 1

        return {
            'friend_location': f"{to_return}"
        }, 200

class GeofenceService(Resource):
    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('start_latitude', required=True, type=float)
        parser.add_argument('start_longitude', required=True, type=float)
        parser.add_argument('end_latitude', required=True, type=float)
        parser.add_argument('end_longitude', required=True, type=float)
        parser.add_argument('time_tolerance', required=True, type=float)
        parser.add_argument('userID', required=True, type=int)
        args = parser.parse_args()
        Google_API = "" # GOOGLE API KEY
        api_request = f"https://maps.googleapis.com/maps/api/directions/json?origin={args['start_latitude']},{args['start_longitude']}&destination={args['end_latitude']},{args['end_longitude']}&key={Google_API}"
        to_return = ""

        response = requests.get(api_request)
        json_obj = json.loads(response.text)
        distance = json_obj['routes'][0]['legs'][0]['distance']['value']
        ETA = json_obj['routes'][0]['legs'][0]['duration']['value']

        if (ETA+30) < (args['time_tolerance']*60):
            to_return = "Arriving"
        else:
            to_return = "Sleeping"

        return {
            'dest_check': f"{to_return}"
        }, 200

class RegisterUserService(Resource):
    def get(self):
        parser = reqparse.RequestParser()
        userID = 0
        args = parser.parse_args()
        projectID = "flutter-ade80"
        key = "" # PROJECT KEY
        doc = f"users/"
        url = f"https://firestore.googleapis.com/v1beta1/projects/{projectID}/databases/(default)/documents/{doc}?pageSize=5000&mask.fieldPaths=name&key={key}"
        to_return = "Unsuccessful"
        distance = 9999999.9
        ETA = 999999.9
        latitude = 12.7
        longitude = 12.7

        response2 = requests.get(url)
        json_obj2 = json.loads(response2.text)
        userList = json_obj2['documents']
        test = ""
        for user in userList:
            name_str = user['name']
            check_str = int(name_str[59:len(name_str)])
            test = f"{test},{check_str}"
            if check_str > userID:
                userID = check_str
            
        userID = userID + 1


        patch_url = f"https://firestore.googleapis.com/v1beta1/projects/{projectID}/databases/(default)/documents/users?documentId={userID}&key={key}"

        myobj = "{\r\n\"fields\": {\r\n\"Distance\": {\r\n\"doubleValue\":"
        myobj2 = f"{myobj}{distance}"
        myobj3 = "\r\n},\r\n\"ETA\": {\r\n\"doubleValue\":"
        myobj6 = "\r\n},\r\n\"Latitude\": {\r\n\"doubleValue\":"
        myobj7 = "\r\n},\r\n\"Longitude\": {\r\n\"doubleValue\":"
        myobj8 = "\r\n},\r\n\"Friends\": {\r\n\"arrayValue\": {\r\n\"values\": {\r\n\"integerValue\":" 
        myobj4 = "\r\n}\r\n}\r\n}\r\n}\r\n}"
        myobj5 = f"{myobj2}{myobj3}{ETA}{myobj6}{latitude}{myobj7}{longitude}{myobj8}{userID}{myobj4}"
        response3 = requests.post(patch_url, data = myobj5)
        json_obj3 = json.loads(response3.text)

        to_return = f"{userID}"#userID

        return {
            'registered_id': f"{to_return}"
        }, 200

class AddFriendService(Resource):
    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('toAdd', required=True, type=int)
        parser.add_argument('userID', required=True, type=int)
        args = parser.parse_args()
        projectID = "flutter-ade80"
        key = "" # PROJECT KEY
        doc = f"users/{args['userID']}"
        url = f"https://firestore.googleapis.com/v1beta1/projects/{projectID}/databases/(default)/documents/{doc}?key={key}"
        patch_url = f"https://firestore.googleapis.com/v1beta1/projects/{projectID}/databases/(default)/documents/{doc}?updateMask.fieldPaths=Friends&key={key}"
        to_return = ""

        response2 = requests.get(url)
        json_obj2 = json.loads(response2.text)
        friend_list = json_obj2['fields']['Friends']['arrayValue']['values']

        friends = []
        x = 0
        for friend in friend_list:
            friend_id = int(friend_list[x]['integerValue'])
            friends.append(friend_id)
            x = x + 1
        
        friends.append(args['toAdd'])

        patchobj = ""
        patch_0 = "{\r\n\"integerValue\":"
        patch_1 = "\r\n}"
        for friend in friends:
            patchobj = f"{patchobj},\r\n{patch_0}{friend}{patch_1}"
        patchobj = patchobj[3:]

        myobj = "{\r\n\"fields\": {\r\n\"Friends\": {\r\n\"arrayValue\": {\r\n\"values\": [" 
        myobj2 = "]\r\n}\r\n}\r\n}\r\n}"
        myobj3 = f"{myobj}{patchobj}{myobj2}"
        response3 = requests.patch(patch_url, data = myobj3)
        json_obj3 = json.loads(response3.text)
        to_return = "Success"

        return {
            'friend_added': f"{to_return}"
        }, 200

class DeleteFriendService(Resource):
    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('toDelete', required=True, type=int)
        parser.add_argument('userID', required=True, type=int)
        args = parser.parse_args()
        projectID = "flutter-ade80"
        key = "" # PROJECT KEY
        doc = f"users/{args['userID']}"
        url = f"https://firestore.googleapis.com/v1beta1/projects/{projectID}/databases/(default)/documents/{doc}?key={key}"
        patch_url = f"https://firestore.googleapis.com/v1beta1/projects/{projectID}/databases/(default)/documents/{doc}?updateMask.fieldPaths=Friends&key={key}"
        to_return = ""

        response2 = requests.get(url)
        json_obj2 = json.loads(response2.text)
        friend_list = json_obj2['fields']['Friends']['arrayValue']['values']

        friends = []
        x = 0
        for friend in friend_list:
            friend_id = int(friend_list[x]['integerValue'])
            if friend_id != args['toDelete']:
                friends.append(friend_id)
            x = x + 1

        patchobj = ""
        patch_0 = "{\r\n\"integerValue\":"
        patch_1 = "\r\n}"
        for friend in friends:
            patchobj = f"{patchobj},\r\n{patch_0}{friend}{patch_1}"
        patchobj = patchobj[3:]

        myobj = "{\r\n\"fields\": {\r\n\"Friends\": {\r\n\"arrayValue\": {\r\n\"values\": [" 
        myobj2 = "]\r\n}\r\n}\r\n}\r\n}"
        myobj3 = f"{myobj}{patchobj}{myobj2}"
        response3 = requests.patch(patch_url, data = myobj3)
        json_obj3 = json.loads(response3.text)
        to_return = "Success"

        return {
            'friend_deleted': f"{to_return}"
        }, 200

api.add_resource(GeofenceService, '/geofenceservice')
api.add_resource(LocationService, '/locationservice')
api.add_resource(ShareLocationService, '/sharelocationservice')
api.add_resource(RegisterUserService, '/registeruserservice')
api.add_resource(AddFriendService, '/addfriendservice')
api.add_resource(DeleteFriendService, '/deletefriendservice')

if __name__ == '__main__':
    app.run()