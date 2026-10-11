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
            let l = acepcions.len()
            [
                #if l > 1 { strong[#i.] }
                DEF: #d\
            ]
        }
    )
}
