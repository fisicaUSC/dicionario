# Véxse o manual de JQ: https://jqlang.org/manual/

# Pasa letras en maiúscula a minúscula, e quita acentos
def simplifica_letra:
    .
    | ascii_downcase
    | gsub("[áà]"; "a")
    | gsub("[éè]"; "e")
    | gsub("[íì]"; "i")
    | gsub("[óò]"; "o")
    | gsub("[úù]"; "u")
;

# Para unha ACEPCION concreta, devolvenos o símbolo, ou 'none' se non hai
# Por exemplo: ["alpha"]
def simbolo:
    if .lingua.gl.simbolo != "" then "[\(.lingua.gl.simbolo)]" else "none" end
;

# Para unha ACEPCION concreta, devolvenos unha lista de sinónimos, ou
# 'none' se non hai.
# Por exemplo: ("sinonimo_1", "sinónimo_2")
def sinonimos:
    if .lingua.gl.sinonimos != [] then
        # Colle unha lista de sinónimos, engade a cada elemento comiñas usando
        # 'map(...)', e logo xunta todos os elementos con join(", ")
        "(\( .lingua.gl.sinonimos | map(. | @json) | join(", ") ),)"
    else "none" end
;

# Para un TERMO concreto, xera a info das distintas acepcions.
# Por exemplo:
#
# (                                  | Xera tochos de texto coma este,
#     definicion : [...],            | un por cada acepción
#     simbolo    : none,             |
#     sinonimos  : ( "...", "..." )  |
# ),                                 |
# (
#     definicion : [...],
#     simbolo    : none,
#     sinonimos  : ( "...", "..." )
# ),
def info_acepcions:
    .acepcions
    | map(
        "
        (
            definicion : [\(.lingua.gl.definicion)],
            simbolo    : \(simbolo),
            sinonimos  : \(sinonimos)
        ),"
    )
    | join("")
;

# Para un TERMO concreto, xera un array cas distintas palabras relacionadas,
# ou 'none' se non hai ningunha
# Por exemplo: ("relacionada_1", "relacionada_2")
def relacionadas:
    if .relacionadas != [] then
        "(" + ( .relacionadas | map(. | @json) | join(", ") ) + ",)"
    else "none" end
;

# Pasamoslle un TERMO a esta función e devólvenos texto en formato typst
# ca información do termo, símbolos, etc. Tal como:
# #termo(
#     denominacion: "D’Alembert, ecuación de",
#     acepcions: (
#         (
#             definicion : [...],
#             simbolo    : none,
#             sinonimos  : ("...")
#         ),
#     ),
#     relacionadas : ("...", "...")
# )
# Véxase as funcións auxiliares anteriores
def termo_individual:
"#termo(
    denominacion: \"\(.termo)\",
    acepcions: (\(info_acepcions)\n    ),
    relacionadas: \(relacionadas),
)\n"
;


# Para as novas letras, devolvemos texto en formato typst tal como:
# #letra("B")
def titulo_nova_letra:
    "#letra(\"\(.termo[0:1] | simplifica_letra | ascii_upcase)\")\n"
;

# Función complicadilla. O que facemos é coller o array orixinal, e _reducilo_
# (nalgunhas linguaxes chámase 'folding').
#
# reduce ARRAY_ORIXINAL as ACTUAL (ACUMULADOR; FUNCION_ACUMULADORA)
def filtro:
    # para cada elemento do array, imos gardándoo en $actual
    reduce .[] as $actual
    (
        # ACUMULADOR
        #
        # Valor inicial, que se irá actualizando e crecendo. O valor de
        # 'anterior' comeza en '0' para que ao comparar o primeiro termo do
        # dicionario (que comeza por 'a') pase que '0' != 'a' e poña tamén un
        # título eí
        #
        #  {
        #      anterior    = "termo"
        #      lista_final = [ {...}, {...}, "NOVA LETRA", {...} ]
        #  }
        { anterior: "0", lista_final: [] };
        # Función para actualizar ACUMULADOR e tamén '$actual'
        #
        # Equivalente a:
        # ACUMULADOR.lista_final += ( (if .. else ..) + [$actual] )
        .lista_final += (
            # aqui comprobamos se temos unha nova letra e actuamos acorde
            if
                (.anterior[0:1] | simplifica_letra)     #  | se o anterior comeza pola mesma letra
                !=                                      #  | co termo actual
                ($actual.termo[0:1] | simplifica_letra) #  |
            then                                        #
                [ $actual | titulo_nova_letra ]         #  | actualizamos a lista co título da nova letra
                + [ $actual | termo_individual ]        #  | e engadimos o termo actual normal
            else                                        #
                [ $actual | termo_individual ]          #  | se non, engadimos so o termo actual
            end                                         #
        )
        # actualizamos 'anterior' co termo actual. Equivalente a:
        # ACUMULADOR.anterior = $actual.termo
        | .anterior = $actual.termo
    )
    # finalmente, collemos o lista_final, resultado do 'reduce' anterior
    | .lista_final[]
;

def json_a_typst(datos):
    "#import(\"/estilo.typ\"): *\n",
    ( datos | filtro )
;

json_a_typst(.)
