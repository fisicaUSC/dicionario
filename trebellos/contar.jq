# jq -r 'map(select( any( ."acepcións".[]; .lingua.gl."forma" == "principal" ) ))' RI.json
def conta_termos(_):
    "Termos: \(. | length)"
;

def conta_acepcions(_):
    "Acepcións: \([.[].acepcions.[]] | length)"
;

def conta_ecuacions(_):
    "Con ecuacións: \([.[] | select(.ten_ecuacions == true)] | length)"
;

def conta_figuras(_):
    "Con figuras: \([.[] | select(.ten_figuras == true)] | length)"
;

def contar(datos):
    conta_termos(datos),
    conta_acepcions(datos),
    conta_ecuacions(datos),
    conta_figuras(datos)
;

contar(.)
