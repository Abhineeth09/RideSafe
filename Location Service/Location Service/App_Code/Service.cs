using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using RestSharp;
using Newtonsoft.Json;

public class Service : IService
{
	public string CheckLocation(int start_longitude, int start_latitude, int end_longitude, int end_latitude, int userID)
	{
		string to_return;
		string Google_API = "";

		string api_request = "https://maps.googleapis.com/maps/api/directions/json?origin" + start_longitude + "," + start_latitude + "&destination=" + end_longitude + "," + end_latitude + "&key=" + Google_API;

		var client = new RestClient(api_request);
		var request = new RestRequest(Method.GET);

		IRestResponse response = client.Execute(request);
		string json = response.Content;

		dynamic jsonObj = JsonConvert.DeserializeObject(json);

		int distance = jsonObj.routes.legs.distance.value;

		int ETA = jsonObj.routes.legs.duration.value;

		// GET PREVIOUS ETA AND DISTANCE FROM GOOGLE CLOUD FIREBASE
		//
		int prev_distance = 55;
		int prev_ETA = 55;

		// SAVE TO GOOGLE CLOUD FIREBASE
		//

		if (prev_distance > distance && prev_ETA > ETA)
		{
			to_return = "Warning";
		}
		else
		{
			to_return = "Safe";
		}

		return to_return;
	}

}
