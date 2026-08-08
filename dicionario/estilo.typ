#let estilo_corpo(doc) = {
    doc
}


#let termo(
    denominacion: none,
    acepcions: none
) = {
    text(size: 1.1em, strong(denominacion))
    block(
        breakable: true,
        inset: (left: 1em),
        for (i, acepcion) in acepcions.enumerate(start: 1) {
            let d = acepcion.definicion
            let c = acepcion.clase
            let x = acepcion.xenero
            let n = acepcion.numero
            let f = acepcion.forma
            let a = acepcion.abreviacion
            let s = acepcion.simbolo
            let l = acepcions.len()
            [
                #if l > 1 { strong[#i.] }
                (#c, #x, #n)\
                Forma: #f\
                Abrv: #a\
                Simb: #s\
                DEF: #d\
            ]
        }
    )
}
