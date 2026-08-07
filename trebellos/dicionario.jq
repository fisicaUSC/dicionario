def cadea:
"#termo(
    denominacion: \"\(.termo)\",
    acepcions: (",
    "\(
        ."acepcións".[] |
        "        (
            definicion  : [\(.lingua.gl."definición")],
            clase       : \"\(.lingua.gl."clase")\",
            xenero      : \"\(.lingua.gl."xénero")\",
            numero      : \"\(.lingua.gl."número")\",
            forma       : \"\(.lingua.gl."forma")\",
            abreviacion : \"\(.lingua.gl."abreviación")\",
            simbolo     : \"\(.lingua.gl."símbolo")\"
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
