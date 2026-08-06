# jq -r 'map(select( any( ."acepcións".[]; .lingua.gl."forma" == "principal" ) ))' CONTIDOS.json
def conta_termos(_):
    "Termos: \(. | length)"
;

def conta_acepcions(_):
    # :NOTA: unha reducción sería máis eficiente ca crear arrays
    "Acepcións: \([.[]."acepcións".[]] | length)"
;

def contar(datos):
    conta_termos(datos),
    conta_acepcions(datos)
;

contar(.)
