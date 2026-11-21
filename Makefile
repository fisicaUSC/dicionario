SHELL := bash

.PHONY: filtrar contar contidos borrador validar
.PRECIOUS: dicionario/xerados/html/dicionario.html

# Xera os contidos do dicionario en formato Typst, a partir do JSON
contidos: dicionario/xerados/contidos.typ
dicionario/xerados/contidos.typ: RI.json
	$(shell mkdir -p dicionario/xerados/typst)
	jq -r -f trebellos/json_a_typst.jq $^ > dicionario/xerados/typst/contidos.typ

# Xera continuamente un BORRADOR dos contidos en formato HTML, en 127.0.0.1:3000/dicionario.html
# Compila dicionario.typ e xera directorio dicionario/xerados/html
borrador:
	typst watch --pdf-tagged=false --pretty --root=dicionario/ --features=html,bundle --format=bundle dicionario/dicionario.typ dicionario/xerados/html

# Xera o dicionario en formato PDF en 'dicionario/xerados/pdf/'
# Pode usarse 'make pdf metodo=watch' para aprobeitar a compilación continuada
METODO := compile
pdf:
	$(shell mkdir -p dicionario/xerados/pdf)
	typst $(METODO) --pdf-tagged=true --ignore-system-fonts --ignore-embedded-fonts --font-path=dicionario/fontes --root=dicionario/ --format=pdf --features=html,bundle dicionario/dicionario.typ dicionario/xerados/pdf/dicionario.pdf

# Devolve información variada dos termos
contar:
	jq -r -f trebellos/contar.jq RI.json

# Valida o JSON usando o esquema
validar:
	uv run trebellos/validador_json.py RI.json

# Filtrar os ficheiros XML orixinais e xerar un JSON (agora mesmo non se usa para nada)
filtrar:
	uv run trebellos/filtro_XML_JSON/filtro_XML_JSON.py
	uv run trebellos/validador_json.py trebellos/filtro_XML_JSON/xerados/RI.json
