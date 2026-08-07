#let estilo_corpo(doc) = {
    set page(columns: 2)
    doc
}


#let termo(
    denominacion: none,
    acepcions: none
) = {
    text(size: 1.1em, weight: "bold", denominacion)
    block(
        breakable: true,
        inset: (left: 1em),
        for acepcion in acepcions {
            let d = acepcion.definicion
            let c = acepcion.clase
            let x = acepcion.xenero
            let n = acepcion.numero
            let f = acepcion.forma
            let a = acepcion.abreviacion
            let s = acepcion.simbolo
            [
                #v(1pt)
                (#c, #x, #n)\
                Forma: #f\
                Abrv: #a\
                Simb: #s\
                DEF: #d
            ]
        }
    )
}
