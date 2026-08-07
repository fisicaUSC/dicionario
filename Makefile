SHELL := bash

.PHONY: filtrar contar dicionario

filtrar:
	uv run trebellos/filtro_XML_JSON/filtro_XML_JSON.py
	uv run trebellos/validador_json.py trebellos/filtro_XML_JSON/xerados/CONTIDOS.json

contar:
	jq -r -f trebellos/contar.jq CONTIDOS.json

dicionario:
	jq -r -f trebellos/dicionario.jq CONTIDOS.json > dicionario/contidos.typ
	typst c --no-pdf-tags --root . --format pdf dicionario/dicionario.typ dicionario/dicionario.pdf
