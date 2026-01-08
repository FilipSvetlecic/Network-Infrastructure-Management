import os
from flask import Flask
from .config import Config

template_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), "templates")

app = Flask(__name__, template_folder=template_dir)
app.config.from_object(Config)

from . import routes


