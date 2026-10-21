#let estilo_corpo(doc) = {
    html.html(
        {
            html.head(
                {
                    html.meta(charset: "utf-8")
                    html.title[Dicionario]
                    html.style(read("/estilo.css"))
                }
            )
            html.body(html.main(doc))
        }
    )
}


#let termo(
    denominacion: none,
    acepcions: none
) = html.div(
    class: "acepcions",
    {
        linebreak()
        html.div(
            class: "termo",
            html.strong(denominacion)
        )
        for (i, acepcion) in acepcions.enumerate(start: 1) {
            let d = acepcion.definicion
            let s = acepcion.simbolo
            html.div(
                class: "acepcion",
                {
                    if acepcions.len() > 1 { strong[#i.] }
                    if s != none {[Símbolo: #s.]}
                    d
                }
            )
        }
    }
)
