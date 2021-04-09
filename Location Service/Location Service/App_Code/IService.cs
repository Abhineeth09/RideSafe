using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

[ServiceContract]
public interface IService
{

	[OperationContract]
	[WebGet(UriTemplate = "CheckLocation?startLong={start_longitude}&startLat={start_latitude}&endLong={end_longitude}&endLat={end_latitude}&userID={userID}")]
	string CheckLocation(int start_longitude, int start_latitude, int end_longitude, int end_latitude, int userID);

}