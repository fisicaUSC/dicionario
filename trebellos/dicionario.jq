def cadea:
"#termo(
    denominacion: \"\(.termo)\",
    acepcions: (",
    "\(
        .acepcions.[] |
        "        (
            definicion  : [\(.lingua.gl.definicion)],
        ),"
    )",
"    ),
)\n"
;

def contidos(datos):
    "#import(\"/dicionario/estilo.typ\"): *\n",
    (
        datos # datos orixinais
        | .[] # iteramos polos termos
        | cadea # Agora, traballamos cos elementos individuais do array
    )
;

contidos(.)
