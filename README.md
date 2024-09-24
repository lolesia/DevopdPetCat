# Run app
```commandline
 uvicorn app.app:app --host 0.0.0.0 --port 5000 --workers 4

```

# Run app from Docker
```commandline
docker run -d -p 8080:80 -p 5000:5000 devops-kitty-cat
```


# See cats on if instance is running
```commandline
http://http://54.172.220.31:5000/random-image
 ```

# Grafana
```commandline
http://54.172.220.31:3000/
```


