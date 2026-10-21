def cadea:
"#termo(
    denominacion: \"\(.termo)\",
    acepcions: (",
    "\(
        .acepcions.[] |
        "        (
            definicion : [\(.lingua.gl.definicion)],
            simbolo    : \(if .lingua.gl.simbolo != "" then "[\(.lingua.gl.simbolo)]" else "none" end),
        ),"
    )",
"    ),
)\n"
;

def contidos(datos):
    "#import(\"/estilo.typ\"): *\n",
    (
        datos # datos orixinais
        | .[] # iteramos polos termos
        | cadea # Agora, traballamos cos elementos individuais do array
    )
;

contidos(.)
