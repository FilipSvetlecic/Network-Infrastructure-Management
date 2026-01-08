from neo4j import GraphDatabase
from .config import Config

driver = GraphDatabase.driver(
    Config.NEO4J_URI,
    auth=(Config.NEO4J_USER, Config.NEO4J_PASSWORD)
)

def get_session():
    return driver.session()

def close_driver():
    driver.close()



