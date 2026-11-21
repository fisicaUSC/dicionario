// Variable para gardar a lista de termos
#let _termos_cache = state("termos_cache", none)
// Función que crea as cabeceiras. Primeiro comproba a lista de termos e se
// está baleira, énchea. Logo reúsase dita lista sen volver calculala.
#let crear_cabeceira() = context {
    // Se a caché está baleira, engadímoslle os termos
    if _termos_cache.get() == none {
        let termos = query(heading.where(level: 2))
        _termos_cache.update(_ => termos)
    // Unha vez non esté baleira
    } else if _termos_cache.get() != none {
        let termos_aqui = _termos_cache
            .get() // collemos o valor dos termos gardado na caché
            // filtramos as que están na páxina actual
            .filter(h2 => here().page() == h2.location().page())
        // Páxina actual
        let num = counter(page).get().first()
        // se non hai termos na páxina actual (pouco probable)
        if termos_aqui.len() == 0 { return none }
        else  {
            // Páxinas pares (esquerda)
            if calc.even(num) {
                align(left, box[#move(dx: -2em, smallcaps[*#termos_aqui.first().body*])])
            // Páxinas impares (dereita)
            } else if calc.odd(num) {
                align(right, box[#move(dx: 2em, smallcaps[*#termos_aqui.last().body*])])
            }
        }
    }
}

// Función para crear os pes de páxina, cos números
#let crear_pe() = context {
    let num = counter(page).get().first()
    if calc.even(num) { align(left, [*#num*]) }
    else { align(right, [*#num*]) }
}

// Función que aplica o estilo ao documento PDF
#let estilo_pdf(doc) = {
    set page(
        margin  : (outside: 2cm, inside: 1cm, top: 1.5cm, bottom: 1.5cm),
        binding : left,
        header  : crear_cabeceira(),
        footer  : crear_pe()
    )
    set par(justify: true, first-line-indent: 0pt)
    set text(size: 11pt, lang: "gl", font: "Common Serif")
    show math.equation: set text(font: "Libertinus Math")
    show image: rect.with(inset: 1pt, radius: 2pt, stroke: 0.5pt + luma(60%))
    set image(width: 100%)
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
    acepcions: none,
    relacionadas: none
) = context {
    // Caso de xerar un PDF
    if target() == "paged" {
        // Movemos o termo un pouco á esquerda
        show heading.where(level: 2): set text(size: 11pt)
        box[#move(dx: -1em, heading(depth: 2, denominacion))]
        // iteramos polas distintas acepcións
        for (i, acepcion) in acepcions.enumerate(start: 1) {
            let d = acepcion.definicion
            let s = acepcion.simbolo
            {
                if i > 1 { [ ] } // espazo para antes dos 2., 3., etc
                if acepcions.len() > 1 { strong[#i. ] }
                if s != none {[Símbolo: #s. ]}
                if acepcion.sinonimos != none {
                    [_#acepcion.sinonimos.join("; ")_]
                }
                d
            }
        }
        if relacionadas != none {
            [#linebreak()*Véxase*: _#relacionadas.join("; ")_.]
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
                    if acepcion.sinonimos != none {
                        html.div(
                            class: "sinonimos",
                            [_#acepcion.sinonimos.join("; ")_]
                        )
                    }
                }
                if relacionadas != none {
                    html.div(
                        class: "relacionadas",
                        [#linebreak()Véxase: _#relacionadas.join("; ")_.]
                    )
                }
            }
        )
    }
}

#let letra(letra) = context {
    if target() == "paged" {
        block(
            inset  : (top: 1em, bottom: 1em),
            outset : (left: 1em),
            width  : 100%,
            stroke : 2pt + luma(60%),
            radius : 5pt,
            heading(depth: 1, text(size: 2em, fill: luma(60%), letra))
        )
    } else if target() == "html" {
        html.div(
            class: "nova-letra",
            {
                heading(depth: 1, strong(letra))
            }
        )
    }
}
