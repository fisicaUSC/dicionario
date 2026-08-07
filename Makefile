SHELL := bash

.PHONY: filtrar contar

filtrar:
	uv run trebellos/filtro_XML_JSON/filtro_XML_JSON.py
	uv run trebellos/validador_json.py trebellos/filtro_XML_JSON/xerados/CONTIDOS.json

contar:
	jq -r -f trebellos/contar.jq CONTIDOS.json
