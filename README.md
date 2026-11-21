# Dicionario de Física

Os contidos deste proxectos están suxeitos á licencia [[`CC BY-NC-SA 4.0`](https://creativecommons.org/licenses/by-nc-sa/4.0/)], con respaldo da Universidade de Santiago de Compostela e no seu nome, o Servizo de Normalización Lingüística.

Para calquera dúbida sobre este código, contactar con _Deivis_ na Facultade de Física da USC (correo nas contribucións de git).

## Que temos neste repositorio

Neste repositorio gárdanse os contidos do **Dicionario de Física** en formato JSON, orixinalmente da Editorial Bahía, para súa reedición e distribución da información terminolóxica por outras fontes. Inclúese o código necesario para filtrar o contido orixinal en formato DOCX, os ficheiros de estilo e diversos trebellos para xerar un PDF novo e tamén unha previsualización dos contidos en formato HTML.

> [!NOTE]
> Orixinalmente, os contidos eran ficheiros DOCX, e o paso `DOCX -> JSON` por degraza non é 100% correcto polo que precisa traballo manual. Actualmente estamos a realizar dito traballo, e os resultados en PDF ou noutro formato non son publicables.

> [!NOTE]
> Os contidos están en [RI.json](./RI.json), onde RI significa *Representación Intermedia*, xa que probablemente este non sexa o formato final onde gardar os contidos.

## Como compilar o proxecto

Poden xerarse os contidos en formato Typst a partir do JSON
```bash
make contidos
```
o cal xera `dicionario/xerados/typst/contidos.typ`

Pode xerarse unha **previsualización** dos contidos en formato HTML usando
```bash
make borrador
```
o cal crea `dicionario/xerados/html/*` e comparte ditos ficheiros en `127.0.0.1:3000/dicionario.html`. Moi útil para ir corrixindo cousas.

Pode xerarse un PDF usando
```bash
make pdf # usar METODO=watch para a compilación continuada
```
o cal crea `dicionario/xerados/pdf/dicionario.pdf`. O formato e estilo son temporais.

## Dependencias
- Para todo, [[Make](https://www.gnu.org/software/make/)]
- Para diversas operacións (`json -> typst`, contar termos, etc.), [[jq](https://jqlang.org/manual/)]
- Para validar os contidos en formato JSON, Python, usando [[uv](https://docs.astral.sh/uv/)]
- Para compilar o dicionario, [[typst](https://github.com/typst/typst)]
