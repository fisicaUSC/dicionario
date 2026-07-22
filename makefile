SHELL := bash

.PHONY: filtrar

filtrar:
	uv run filtrado/filtro_DOCX_RI.py
