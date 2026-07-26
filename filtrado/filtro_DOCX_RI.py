import json
import pathlib
from datetime import datetime

from validador_json import validar_json

# AVISO -> Perdón, fáltame inspiración e dáseme fatal poñer nomes as variables, pero creo que se entende a idea

# Iste é un pequeno filtro caseiro que colle un XML do estilo dos ficheiros
# XMLs/document_AB.xml e o separa en parágrafos; cada parágrafo, á súa vez, nos
# seu constituintes (aquí chamados 'executables'); e tamén nos da certa info do
# estilo do texto filtrado (itálica, negriña). Para explicalo mellor (simplificado):
#
# <w:p>
#     <w:r>
#         <w:rPr> <w:b/> <w:sz w:val="18"/> </w:rPr>
#         <w:t>Abbe, invariante de</w:t>
#     </w:r>
#     <w:r>
#         <w:rPr> <w:sz w:val="18"/> </w:rPr>
#         <w:t>En óptica, e para o caso dunha superficie esférica de radio</w:t>
#     </w:r>
#     <w:r>
#         <w:rPr> <w:sz w:val="18"/> </w:rPr>
#         <w:t>, que separa dous medios transparentes de distinto *</w:t>
#     </w:r>
#     <w:r>
#         <w:rPr> <w:i/> <w:sz w:val="18"/> </w:rPr>
#         <w:t>índice de refracción</w:t>
#     </w:r>
# </w:p>
#
# máis simplificado inda:
#
# parágrafo      -->  <w:p>
#     executable -->  <w:r> partes dun parágrafo. Separa estilos, imaxes, ecuacións, etc.
#         estilo -->  <w:b> (negriña), <w:i> (itálica), <w:sz> (tamaño da fonte)
#         texto  -->  O propio texto
#
# a tremenda calidade deste código demostra que NON é IA :)


class Documento:
    """Obxecto documento inicializado co nome do documento. Ten un atributo doc
    que contén o texto do documento"""
    def __init__(self,documento):
        self.nome = documento
        file = open(documento,'r',encoding="utf-8")
        self.doc = file.read()
        paragrafo = contido("w:p",self.doc)
        self.paragrafos = []
        for coso in paragrafo:
            self.paragrafos.append(Paragrafo(coso))
        pass

class Paragrafo:
    """Obxecto paragrafo inicializado co contido dun parágrafo. Ten como
    atributos un booleano titulo, e un conxunto de obxectos executables"""
    def __init__(self,texto):
        self.texto = texto
        self.titulo = False
        conten = contido("w:r",texto)
        if "Ttulo" in contido("w:pPr",texto)[0]: # Aínda teño que ver como está organizado o que nos vaian mandando, pero de momento isto funciona
            self.titulo = True
        self.executables = []
        for coso in conten:
            self.executables.append(Executable(coso))

class Executable:
    """Obxecto executable inicializado co contido dun elemento parágrafo. Ten
    como atributos un obxecto estilo, un obxecto e un texto"""
    def __init__(self,texto):
        estilo = contido("w:rPr",texto)[0]
        self.estilo = Estilo(estilo)
        self.texto = contido("w:t",texto)[0]
        self.obxecto = True if ("w:object" in texto) else False # Isto basicamente dime se o executable é unha ecuación. Xa mirarei máis o tema

class Estilo:
    """Obxecto estilo inicializado co contido de calquera dos elementos
    executable ou parágrafo, ten atributos b, i e tamaño."""
    b = False
    i = False
    def __init__(self,texto):
        if "<w:b/>" in texto:
            self.b = True
        if "w:i" in texto:
            self.i = True   # Podería meter tamén o tamaño da fonte (w:sz) pero de momento non é relevante

def contido(elemento,texto):
    """Esta función basicamente colle un texto e un elemento, e me devolve un
    array co contido dos elementos dese tipo no texto"""
    textoSeparado = texto.split("</" + elemento + ">")[:-1]
    textoFinal = []
    for linea in textoSeparado:
        if "<" + elemento + " " in linea: # Isto parece medio raro, pero fágoo así porque se poño só "<" + elemento nalgúns casos non rula como debería (co w:b, por exemplo)
            texto = (linea[linea.index("<" + elemento + " "):])
        else:
            texto = (linea[linea.index("<" + elemento + ">"):])
        textoFinal.append(texto[texto.index(">") + 1:])
    if textoFinal == []:
        textoFinal = [""] #Fago isto porque a función me da problemas cando devolve un array baleiro
    return(textoFinal)

# Falta saber que facer con figuras e ecuacións

# Nomes dos ficheiros XML ca información, para iterar por todos eles despois.
ficheiros = [
    Documento("XMLs/document_AB.xml"),
    Documento("XMLs/document_CDE.xml"),
    Documento("XMLs/document_FGHIJKLMNO.xml"),
    Documento("XMLs/document_PQRST.xml"),
    Documento("XMLs/document_UVXWYZ.xml")
]

termos = [] # Lista con todos os termos atopados
definicions = [] # Lista con todas as definicions
vistos = [] # Lista de termos 'xa vistos'
duplicados = [] # Lista de termos que está duplicados
contidos = [] # Aquí gardaranse dicionarios co formato necesario para a RI
mal = [] # cousas que están mal

# iteramos polos distintos FICHEIROS
print("Filtrando...")
for f in ficheiros:
    paragrafos = f.paragrafos

    # iteramos polos PARÁGRAFOS (en principio, un par. = un termo) Cada
    # parágrafo ten unha lista de 'executables'. Os executables son os pedazos
    # de cada parágrafo, que poden conter texto en itálica, ecuacións, etc.
    for par, i  in zip(paragrafos, range(len(paragrafos))):

        # A primeira palabra do parágrafo. Quítolle espazos finais, *, e cousas raras
        termo = par.executables[0].texto
        termo = termo.strip().strip("*").strip().removesuffix("1.").strip()

        bolds   = []
        italics = []

        # Estamos nun parágrafo, o cal ten un atributo que é unha lista de
        # executables. Deles, collemos todos excepto o primeiro, collemos seu
        # texto e unímolo.
        #
        # par.executables (o elemento 0 é o termo, asique o salto):
        #
        # [                             [
        #     executable_1  map lambda      executable_1.texto
        #     executable_2  --------->      executable_1.texto
        #     executable_3                  executable_1.texto
        #     ...                           ...
        # ]                             ]
        definicion = ''.join(list(map(lambda e: e.texto, par.executables[1:-1])))
        definicion = definicion.replace("*", "").strip().removeprefix("1.").strip()

        # lista con todos os executables con estilo bold, por se os precisase
        bolds = list(map(
            lambda e: e.texto, # collemos o texto dos executables
            filter( lambda e: e.estilo.b, par.executables[1:-1] ) # executables en Bold
        ))

        # lista con todos os executables con estilo italic. En principio, parte
        # destes son as palabras relacionadas (p.e. *mecánica estatística)
        # :FACER: En itálica so están os termos relacionados que teñen varias
        #     palabras (p.e. *mecánica estatística). Se a palabra relacionada é
        #     simple, aqui non está
        italicas = list(map(
            lambda e: e.texto, # collemos o texto dos executables
            filter( lambda e: e.estilo.i, par.executables[1:-1] ) # executables en Italica
        ))

        # Dicionario que segue o esquema de JSON da Representación Intermedia
        info = {
            f"{termo}": [
                {
                    "definición": f"{definicion}",
                    "lingua": {
                        "gl": f"{termo}",
                        "en": "",
                        "es": ""
                    },
                    "clase"       : "",
                    "xénero"      : "",
                    "números"     : "",
                    "abreviación" : "",
                    "sinónimos": [],
                    "palabras relacionadas" : [],
                    "áreas": [],
                    "referencias": [],
                    "figuras" : [],
                    "modificado": f"{datetime.today().strftime('%Y-%m-%d %H:%M:%S')}"
                }
            ]
        }

        if (
            # non quero nin termos nin definicións baleiras
            ((termo != '') and (definicion != ''))
            # nin tampouco unha soa letra
            and not (len(termo) == 1 and len(par.executables) == 1)
            and (info not in contidos)
        ) :
            termos.append(termo)
            contidos.append(info)
            definicions.append(definicion)
        else:
            mal.append(f"Ficheiro {f.nome}, par {i+1}\n    Termo: {termo}\n    Definición: {definicion}")

print("Todo filtrado")
print(f"Termos: {len(termos)}\nDefinicións: {len(definicions)}\nCousas mal: {len(mal)} Véxase `filtrado/xerados/mal.txt`")

# Asegurámonos de que exista a ruta pa gardar os ficheiros xerados
pathlib.Path("filtrado/xerados").mkdir(exist_ok=True)

# Gardamos os contidos en formato JSON
with open("filtrado/xerados/RI.json", 'w', encoding = 'utf8') as f:
    json.dump(contidos, f, indent = 2, ensure_ascii = False)

# Gardamos os termos aparte, por si acaso
with open("filtrado/xerados/termos.txt", "w", encoding = 'utf8') as f:
    f.write("\n".join(termos))

# Gardamos os termos que están mal (termo/definición baleira)
with open("filtrado/xerados/mal.txt", "w", encoding = "utf8") as f:
    f.write("\n".join(mal))

# Gardamos termos e definicións de forma contigua, por si acaso
with open("filtrado/xerados/termos_definicions.txt", "w", encoding = "utf8") as f:
    f.write("\n\n".join([termo + "\n" + definicion for termo, definicion in zip(termos, definicions)]))

print("Validando...")
try:
    validar_json("filtrado/esquema_RI.json","filtrado/xerados/RI.json")
    print("Os contidos filtrados foron validados!")
except:
    print("Os contidos non seguen o esquema da RI!")
