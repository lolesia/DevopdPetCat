# Run app
```commandline
 uvicorn app.app:app --host 0.0.0.0 --port 5000 --workers 4

```

# See cats on 
```commandline
http://127.0.0.1:5000/random-image
 ```

# Run app from Docker
```commandline
docker run -d -p 8080:80 -p 5000:5000 devops-kitty-cat
```


