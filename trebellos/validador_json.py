import json
import jsonschema
import sys

ruta_json = sys.argv[1]
print(f"Validando {ruta_json}...")

def validar_json(ruta_esquema: str, ruta_json: str):

    with open(ruta_esquema) as f:
        esquema = json.loads(f.read())

    with open(ruta_json) as f:
        datos_json = json.loads(f.read())

    jsonschema.validate(instance=datos_json, schema=esquema)

validar_json("trebellos/esquema_RI.json", ruta_json)
