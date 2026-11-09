## Repositorio para o dicionario de física

Actualmente estamos en proceso de limpar os contidos en formato JSON

Poden xerarse os contidos en formato typst
```bash
make contidos
```
o cal xera `dicionario/xerados/typst/contidos.typ`

Pode xerarse unha **previsualización** dos contidos en formato HTML usando
```bash
make borrador
```
o cal crea `dicionario/xerados/html/*` e comparte ditos ficheiros en `127.0.0.1:3000/dicionario.html`. Moi útil para ir corrixindo cousas.

## Dependencias
- Para todo, [[Make](https://www.gnu.org/software/make/)]
- Para diversas operacións (`json -> typst`, contar termos, etc.), [[jaq](https://github.com/01mf02/jaq)], semellante a [[jq](https://jqlang.org/manual/)]
- Para validar os contidos en formato JSON, [[uv](https://docs.astral.sh/uv/)]
