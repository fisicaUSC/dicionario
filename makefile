SHELL := bash

.PHONY: filtrar

filtrar:
	uv run trebellos/filtro_XML_JSON/filtro_DOCX_RI.py
	uv run trebellos/validador_json.py trebellos/filtro_XML_JSON/xerados/RI.json
