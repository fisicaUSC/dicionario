#context {
    // No caso de compilar un PDF
    if target() == "paged" {
        {
            import("/estilo.typ"): *
            show: estilo_documento
            include("/xerados/typst/contidos.typ")
        }
    // No caso de compilar o borrador en formato BUNDLE.
    // Ollo, un ficheiro individual pode ser HTML, PAGED, etc. no estilo dos
    // ficheiros hai que usar 'target() == html'
    } else if target() == "bundle" {
        document(
            "/dicionario.html",
            {
                import("/estilo.typ"): *
                show: estilo_documento
                include("/xerados/typst/contidos.typ")
            }
        )
        asset("/fontes/CommonSerif-VF.ttf", read("/fontes/CommonSerif/CommonSerif-VF.ttf", encoding: none))
        asset("/fontes/CommonSerif-Italic-VF.ttf", read("/fontes/CommonSerif/CommonSerif-Italic-VF.ttf", encoding: none))
        asset("/fontes/LibertinusMath-Regular.otf", read("/fontes/Libertinus/LibertinusMath-Regular.otf", encoding: none))
    }
}
