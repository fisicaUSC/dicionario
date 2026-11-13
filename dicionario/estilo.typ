// Función que aplica o estilo ao documento PDF
#let estilo_pdf(doc) = {
    set page(margin: (outside: 2cm, inside: 1cm, top: 1cm, bottom: 1cm), binding: left)
    set par(justify: true, first-line-indent: 0pt)
    set text(lang: "gl", font: "Common Serif")
    show math.equation: set text(font: "Libertinus Math")
    set columns(gutter: 1cm)
    show: columns
    doc
}

// Función que aplica o estilo ao documento HTML
#let estilo_html(doc) = {
    show figure: html.frame // envolvemos as figuras para que sexan frames
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

// Esta é a función que chamamos para aplicar o estilo ao documento. Aplica o
// estilo correspondente dependendo de se xeramos un PDF ou unha páxina HTML
#let estilo_documento(doc) = context {
    if      target() == "paged"  { show: estilo_pdf;  doc }
    else if target() == "html" { show: estilo_html; doc }
}

#let termo(
    denominacion: none,
    acepcions: none
) = context {
    // Caso de xerar un PDF
    if target() == "paged" {
        // Movemos o termo un pouco á esquerda
        box[#move(dx: -1em, strong(denominacion))]
        // iteramos polas distintas acepcións
        for (i, acepcion) in acepcions.enumerate(start: 1) {
            let d = acepcion.definicion
            let s = acepcion.simbolo
            {
                if i > 1 { [ ] } // espazo para antes dos 2., 3., etc
                if acepcions.len() > 1 { strong[#i. ] }
                if s != none {[Símbolo: #s. ]}
                d
            }
        }
    // Caso de xerar o borrador en formato HTML
    } else if target() == "html" { // HTML porque isto está dentro de dicionario.html
        html.div(
            class: "acepcions",
            {
                linebreak()
                // O termo
                html.div(
                    class: "termo",
                    html.strong(denominacion)
                )
                // As acepcions
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
    }
}
