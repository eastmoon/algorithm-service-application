# Import server libraries
from fastapi import FastAPI
from fastapi import __version__ as fastapi_version

# Import server modules
from routes import asa

# Configuration server
app = FastAPI()
app.mount("/asa", asa.module)

# Configuration server root route
@app.get("/")
def show_fastapi_information():
    return {"Server": "FastAPI Server", "Version": f"{fastapi_version}"}
