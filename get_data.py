import http.client

conn = http.client.HTTPSConnection("yahoo-finance15.p.rapidapi.com")

headers = {
    'X-RapidAPI-Key': "",
    'X-RapidAPI-Host': "yahoo-finance15.p.rapidapi.com"
    }

conn.request("GET", "/api/yahoo/hi/history/AAPL/15m?diffandsplits=false", headers=headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
