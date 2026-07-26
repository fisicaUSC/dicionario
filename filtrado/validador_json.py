import json
import jsonschema

def validar_json(ruta_esquema: str, ruta_json: str):

    with open(ruta_esquema) as f:
        esquema = json.loads(f.read())

    with open(ruta_json) as f:
        datos_json = json.loads(f.read())

    jsonschema.validate(instance=datos_json, schema=esquema)

if __name__ == "__main__":
    validar_json("filtrado/esquema_RI.json", "filtrado/exemplo_RI.json")
