#include <WiFi.h>

const char* ssid = "Redmi Note 11";
const char* password = "nemophilist";

WiFiServer server(80);

String header;

String output23State = "off";
String output22State = "off";
String output1State = "off";
String output3State = "off";

const int output23 = 23;
const int output22 = 22;
const int output1 = 32;
const int output3 = 33;

unsigned long currentTime;
unsigned long previousTime = 0;
const long timeoutTime = 2000;

void setup() {
  Serial.begin(115200);
  
  pinMode(output23, OUTPUT);
  pinMode(output22, OUTPUT);
  pinMode(output1, OUTPUT);
  pinMode(output3, OUTPUT);
  digitalWrite(output23, LOW);
  digitalWrite(output22, LOW);
  digitalWrite(output1, LOW);
  digitalWrite(output3, LOW);
  

  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected.");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  server.begin();
}

void loop() {
  
  WiFiClient client = server.available();

  if (client) {
    currentTime = millis();
    previousTime = currentTime;
    Serial.println("New Client.");
    String currentLine = "";
    while (client.connected() && currentTime - previousTime <= timeoutTime) {
      currentTime = millis();
      if (client.available()) {
        char c = client.read();
        Serial.write(c);
        header += c;
        if (c == '\n') {
          if (currentLine.length() == 0) {
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println("Connection: close");
            client.println();

            if (header.indexOf("GET /23/on") >= 0) {
              Serial.println("GPIO 23 on");
              output23State = "on";
              digitalWrite(output23, HIGH);
              // Turn off other outputs
              digitalWrite(output22, LOW);
              output22State = "off";
              digitalWrite(output1, LOW);
              output1State = "off";
              digitalWrite(output3, LOW);
              output3State = "off";
            } else if (header.indexOf("GET /23/off") >= 0) {
              Serial.println("GPIO 23 off");
              output23State = "off";
              digitalWrite(output23, LOW);
            } else if (header.indexOf("GET /22/on") >= 0) {
              Serial.println("GPIO 22 on");
              output22State = "on";
              digitalWrite(output22, HIGH);
              // Turn off other outputs
              digitalWrite(output23, LOW);
              output23State = "off";
              digitalWrite(output1, LOW);
              output1State = "off";
              digitalWrite(output3, LOW);
              output3State = "off";
            } else if (header.indexOf("GET /22/off") >= 0) {
              Serial.println("GPIO 22 off");
              output22State = "off";
              digitalWrite(output22, LOW);
            } else if (header.indexOf("GET /1/on") >= 0) {
              Serial.println("GPIO 1 on");
              output1State = "on";
              digitalWrite(output1, HIGH);
              // Turn off other outputs
              digitalWrite(output23, LOW);
              output23State = "off";
              digitalWrite(output22, LOW);
              output22State = "off";
              digitalWrite(output3, LOW);
              output3State = "off";
            } else if (header.indexOf("GET /1/off") >= 0) {
              Serial.println("GPIO 1 off");
              output1State = "off";
              digitalWrite(output1, LOW);
            } else if (header.indexOf("GET /3/on") >= 0) {
              Serial.println("GPIO 3 on");
              output3State = "on";
              digitalWrite(output3, HIGH);
              // Turn off other outputs
              digitalWrite(output23, LOW);
              output23State = "off";
              digitalWrite(output22, LOW);
              output22State = "off";
              digitalWrite(output1, LOW);
              output1State = "off";
            } else if (header.indexOf("GET /3/off") >= 0) {
              Serial.println("GPIO 3 off");
              output3State = "off";
              digitalWrite(output3, LOW);
            }
            
            client.println("<!DOCTYPE html><html>");
            client.println("<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
            client.println("<link rel=\"icon\" href=\"data:,\">");
            client.println("<style>html { font-family: Helvetica; display: inline-block; margin: 0px auto; text-align: center;}");
            client.println(".button { background-color: #4CAF50; border: none; color: white; padding: 16px 40px;");
            client.println("text-decoration: none; font-size: 30px; margin: 2px; cursor: pointer;}");
            client.println(".button2 {background-color: #555555;}</style></head>");
            
            client.println("<body><h1>SNAKE GAME CONTROLLER</h1>");
            
            client.println("<p>GPIO 23 - State " + output23State + "</p>");
            if (output23State == "off") {
              client.println("<p><a href=\"/23/on\"><button class=\"button buttonup\" style=\"background-color: #4CAF50;\">UP</button></a></p>");
            } else {
              client.println("<p><a href=\"/23/off\"><button class=\"button buttonup\" style=\"background-color: #A9A9A9;\">UP</button></a></p>");
            }
            
            client.println("<p>GPIO 22 - State " + output22State + "</p>");
            if (output22State == "off") {
              client.println("<p><a href=\"/22/on\"><button class=\"button buttondown\" style=\"background-color: #f44336;\">DOWN</button></a></p>");
            } else {
              client.println("<p><a href=\"/22/off\"><button class=\"button buttondown\" style=\"background-color: #A9A9A9;\">DOWN</button></a></p>");
            }
            
            client.println("<p>GPIO 1 - State " + output1State + "</p>");
            if (output1State == "off") {
              client.println("<p><a href=\"/1/on\"><button class=\"button buttonleft\" style=\"background-color: #2196F3;\">LEFT</button></a></p>");
            } else {
              client.println("<p><a href=\"/1/off\"><button class=\"button buttonleft\" style=\"background-color: #A9A9A9;\">LEFT</button></a></p>");
            }
            
            client.println("<p>GPIO 3 - State " + output3State + "</p>");
            if (output3State == "off") {
              client.println("<p><a href=\"/3/on\"><button class=\"button buttonright\" style=\"background-color: #ff9800;\">RIGHT</button></a></p>");
            } else {
              client.println("<p><a href=\"/3/off\"><button class=\"button buttonright\" style=\"background-color: #A9A9A9;\">RIGHT</button></a></p>");
            }
            client.println("</body></html>");
            client.println();
            break;
          } else {
            currentLine = "";
          }
        } else if (c != '\r') {
          currentLine += c;
        }
      }
    }
    header = "";
    client.stop();
    Serial.println("Client disconnected.");
    Serial.println("");
  }
  
}
