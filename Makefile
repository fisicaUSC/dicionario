SHELL := bash

.PHONY: filtrar contar contidos borrador
.PRECIOUS: dicionario/dicionario.html

# Filtrar os ficheiros XML orixinais e xerar un JSON
filtrar:
	uv run trebellos/filtro_XML_JSON/filtro_XML_JSON.py
	uv run trebellos/validador_json.py trebellos/filtro_XML_JSON/xerados/CONTIDOS.json

# Devolve información variada dos termos
contar:
	jq -r -f trebellos/contar.jq CONTIDOS.json

# Xera continuamente un borrador dos contidos en formato HTML, en 127.0.0.1:3000
borrador:
	typst watch --no-pdf-tags --pretty --root . --features html --format html dicionario/dicionario.typ dicionario/dicionario.html

# Xera os contidos do dicionario en formato Typst
contidos: CONTIDOS.json
	jq -r -f trebellos/dicionario.jq $^ > dicionario/contidos.typ
