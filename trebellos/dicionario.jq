def cadea:
"#termo(
    denominacion: \"\(.termo)\",
    acepcions: (",
    "\(
        .acepcions.[] |
        "        (
            definicion  : [\(.lingua.gl.definicion)],
            clase       : \"\(.lingua.gl.clase)\",
            xenero      : \"\(.lingua.gl.xenero)\",
            numero      : \"\(.lingua.gl.numero)\",
            forma       : \"\(.lingua.gl.forma)\",
            abreviacion : \"\(.lingua.gl.abreviacion)\",
            simbolo     : \"\(.lingua.gl.simbolo)\"
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
