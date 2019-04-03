import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.FileNotFoundException;
import org.json.*;

public class RestClient 
{
    final static String homeurl = "http://localhost:3005/";
    static String url;
    
    
    static void setAddress()
    {
      try {
        BufferedReader br = new BufferedReader(new FileReader("data/IP_address.txt"));
        try {
          String text = br.readLine();
          if(text.charAt(0)=='h')
           url = text;
          else
           url = "http://"+text+":3005/";
           br.close();
        }catch(IOException ioex){}
    }catch (FileNotFoundException ex)
    {
      System.out.println("No file");
      url=homeurl;
    }
}
    // Generic Rest API
    static int postReq (String entity, String body) {
        HttpClient httpClient = HttpClientBuilder.create().build();  
        try {
            HttpPost request = new HttpPost(url+ entity);
            StringEntity params =new StringEntity(body);
            request.addHeader("content-type", "application/json");
            request.setEntity(params);
            HttpResponse response = httpClient.execute(request);
       
            if (response.getStatusLine().getStatusCode() == 201) {
                String responseAsString = EntityUtils.toString(response.getEntity());
                JSONObject obj = new JSONObject(responseAsString);
                return Integer.parseInt(obj.getString("id"));
            } else return -1;
        } catch (Exception ex) {
            //handle exception here
            return -1;
        } 
    }
    
    static String putReq (int id, String entity, String body) {
        try {
            HttpPut request = new HttpPut(url+entity+"/"+id);
            StringEntity params =new StringEntity(body);
            request.addHeader("content-type", "application/json");
            request.setEntity(params);
            return getResponse(request);
        } catch (Exception ex) {
            return null;
        } 
    }
    
    static String getReq (int id, String entity) {
        try {
            HttpGet request = new HttpGet(url+entity+"/"+id);
            return getResponse(request);
        } catch (Exception ex) {
            return null;
        } 
    }
    
     static String getAllReq (String entity) {
        try {
            HttpGet request = new HttpGet(url+entity);
            return getResponse(request);
        } catch (Exception ex) {
            return null;
        } 
    }
    
   static String delReq (int id, String entity) {
        try {
            HttpDelete request = new HttpDelete(url+entity+"/"+id);
            return getResponse(request);
        } catch (Exception ex) {
            return null;
        } 
    }
    
    static String getResponse (HttpUriRequest request) throws Exception {  
        HttpClient httpClient = HttpClientBuilder.create().build();
        HttpResponse response = httpClient.execute(request);
        if (response.getStatusLine().getStatusCode() == 200) 
                return EntityUtils.toString(response.getEntity());
        else return null;
    }
}
