%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "galaxia.tab.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);

int combustible = 0; // Combustible de la nave
char* ubicacion_nave = NULL; // Ubicación actual de la nave

// Definición de las estructuras de datos para el grafo
typedef struct Arista {
    char* destino;
    int peso;
    struct Arista* siguiente;
} Arista;

typedef struct Galaxia {
    char* nombre;
    Arista* adyacencias;
    struct Galaxia* siguiente;
} Galaxia;

Galaxia* galaxias = NULL;

Galaxia* buscarGalaxia(Galaxia* lista, char* nombre);
Galaxia* agregarGalaxia(Galaxia* lista, char* nombre);
void agregarArista(Galaxia* galaxia, char* destino, int peso);

// Implementación de las funciones del grafo
Galaxia* buscarGalaxia(Galaxia* lista, char* nombre){
    Galaxia* actual = lista;
    while (actual != NULL){
        if (strcmp(actual->nombre, nombre) == 0) {
            return actual;
        }
        actual = actual->siguiente;
    }
    return NULL;
}

Galaxia* agregarGalaxia(Galaxia* lista, char* nombre){
    Galaxia* nueva = (Galaxia*)malloc(sizeof(Galaxia));
    nueva->nombre = strdup(nombre);
    nueva->adyacencias = NULL;
    nueva->siguiente = lista;
    return nueva;
}

void agregarArista(Galaxia* galaxia, char* destino, int peso) {
    // Agregar arista de galaxia -> destino
    Arista* nueva = (Arista*)malloc(sizeof(Arista));
    nueva->destino = strdup(destino);
    nueva->peso = peso;
    nueva->siguiente = galaxia->adyacencias;
    galaxia->adyacencias = nueva;

    // Buscar la galaxia destino para agregar la arista destino -> galaxia
    Galaxia* destinoGalaxia = buscarGalaxia(galaxias, destino);
    if (destinoGalaxia != NULL) {
        Arista* aristaInversa = (Arista*)malloc(sizeof(Arista));
        aristaInversa->destino = strdup(galaxia->nombre);
        aristaInversa->peso = peso;
        aristaInversa->siguiente = destinoGalaxia->adyacencias;
        destinoGalaxia->adyacencias = aristaInversa;
    } else {
        printf("Error: La galaxia destino %s no existe.\n", destino);
    }

    printf("Arista agregada de %s a %s con peso %d\n", galaxia->nombre, destino, peso);
    printf("Arista agregada de %s a %s con peso %d\n", destino, galaxia->nombre, peso);
}


// Definición del algoritmo de Dijkstra
#define INFINITO 999999

Galaxia* encontrarMenorDistancia(Galaxia* lista, int* distancias, int* visitados);
void dijkstra(Galaxia* lista, char* inicio, char* destino);

// Implementación del algoritmo de Dijkstra
Galaxia* encontrarMenorDistancia(Galaxia* lista, int* distancias, int* visitados) {
    Galaxia* menorNodo = NULL;
    int menorDistancia = INFINITO;
    Galaxia* actual = lista;
    int index = 0;
    while (actual != NULL) {
        if (!visitados[index] && distancias[index] < menorDistancia) {
            menorDistancia = distancias[index];
            menorNodo = actual;
        }
        actual = actual->siguiente;
        index++;
    }
    return menorNodo;
}

void dijkstra(Galaxia* lista, char* inicio, char* destino) {
    int distancias[100];          // Para almacenar la distancia más corta a cada galaxia
    int visitados[100] = {0};     // Marcar galaxias ya visitadas
    Galaxia* predecesores[100] = {NULL}; // Para almacenar el predecesor de cada galaxia
    Galaxia* nodos[100];          // Lista de galaxias por índice para facilitar el acceso
    int index = 0;

    // Inicializar distancias a infinito y predecesores a NULL
    Galaxia* actual = lista;
    while (actual != NULL) {
        distancias[index] = INFINITO;
        nodos[index] = actual;
        actual = actual->siguiente;
        index++;
    }

    int num_nodos = index; // Número total de galaxias

    // La distancia al nodo de inicio es 0
    int idxInicio = -1;
    for (int i = 0; i < num_nodos; i++) {
        if (strcmp(nodos[i]->nombre, inicio) == 0) {
            idxInicio = i;
            break;
        }
    }
    if (idxInicio == -1) {
        printf("Error: La galaxia de inicio no existe\n");
        return;
    }

    int idxDestino = -1;
    for (int i = 0; i < num_nodos; i++) {
        if (strcmp(nodos[i]->nombre, destino) == 0) {
            idxDestino = i;
            break;
        }
    }
    if (idxDestino == -1) {
        printf("Error: La galaxia de destino no existe\n");
        return;
    }

    distancias[idxInicio] = 0;

    // Mientras haya nodos no visitados con distancia finita
    while ((actual = encontrarMenorDistancia(lista, distancias, visitados)) != NULL) {
        int idxActual = -1;
        for (int i = 0; i < num_nodos; i++) {
            if (nodos[i] == actual) {
                idxActual = i;
                break;
            }
        }

        visitados[idxActual] = 1;

        Arista* arista = actual->adyacencias;
        while (arista != NULL) {
            int idxDestinoArista = -1;
            for (int i = 0; i < num_nodos; i++) {
                if (strcmp(nodos[i]->nombre, arista->destino) == 0) {
                    idxDestinoArista = i;
                    break;
                }
            }

            if (idxDestinoArista != -1 && !visitados[idxDestinoArista] && distancias[idxActual] + arista->peso < distancias[idxDestinoArista]) {
                distancias[idxDestinoArista] = distancias[idxActual] + arista->peso;
                predecesores[idxDestinoArista] = actual;
            }

            arista = arista->siguiente;
        }
    }

    if (distancias[idxDestino] == INFINITO) {
        printf("No existe un camino de %s a %s.\n", inicio, destino);
    } else {
        printf("La distancia mas corta de %s a %s es: %d\n", inicio, destino, distancias[idxDestino]);

        Galaxia* camino = nodos[idxDestino];
        printf("El camino mas corto es: %s", destino);
        
        while (camino != nodos[idxInicio]) {
            for (int i = 0; i < num_nodos; i++) {
                if (nodos[i] == camino) {
                    Galaxia* predecesor = predecesores[i];
                    if (predecesor == NULL) {
                        printf(" <- (Camino no válido)\n");
                        return;
                    }

                    // Encontrar la arista entre el predecesor y el nodo actual (camino)
                    Arista* arista = predecesor->adyacencias;
                    while (arista != NULL) {
                        if (strcmp(arista->destino, camino->nombre) == 0) {
                            printf(" <- %s", predecesor->nombre);
                            // Restar el peso al combustible de la nave
                            combustible -= arista->peso;
                            printf(" (combustible restante: %d)", combustible);

                            // Si el combustible llega a cero o menos, la nave no puede continuar
                            if (combustible <= 0) {
                                printf("\nLa nave se ha quedado sin combustible y no puede continuar.\n");
                                return;
                            }

                            break;
                        }
                        arista = arista->siguiente;
                    }

                    camino = predecesor;
                    break;
                }
            }
        }
        printf("\n");
    }
}


%}

%union {
    int numero;
    char* str;
}

%token <str> GALAXIA NAVE ARISTA COMBUSTIBLE PESO SUBGALAXIA
%token <numero> NUMERO
%token <str> IDENTIFICADOR
%token PUNTOYCOMA COMA IGUAL REABASTECER VIAJAR AUTONOMO GUIADO

%type <str> definicion_galaxia definicion_nave definicion_arista ubicacion

%%

programa:
    definiciones
;

definiciones:
    definicion_galaxia
    | definicion_nave
    | definicion_arista
    | definiciones definicion_galaxia
    | definiciones definicion_nave
    | definiciones definicion_arista
;

definicion_galaxia:
    GALAXIA IDENTIFICADOR PUNTOYCOMA
    {
        if(buscarGalaxia(galaxias,$2) == NULL){
            galaxias = agregarGalaxia(galaxias,$2);
        }
    }
;

definicion_nave:
    NAVE IDENTIFICADOR COMA COMBUSTIBLE IGUAL NUMERO COMA ubicacion COMA REABASTECER PUNTOYCOMA
    {
        combustible = $6;
        ubicacion_nave = strdup($8);
        printf("Nave '%s' creada con %d unidades de combustible en la galaxia '%s'\n", $2, combustible, ubicacion_nave);
    }
;

definicion_arista:
    ARISTA IDENTIFICADOR COMA IDENTIFICADOR IGUAL PESO IGUAL NUMERO PUNTOYCOMA
    {
        Galaxia* origen = buscarGalaxia(galaxias,$2);
        Galaxia* destino = buscarGalaxia(galaxias, $4);
        if(origen && destino){
            agregarArista(origen, $4, $8);
        }else{
            printf("Error: Las galaxias %s o %s no existen.\n", $2, $4);
        }
    }
;

ubicacion:
    IDENTIFICADOR
    {
        $$ = $1;
    }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *archivo = fopen(argv[1], "r");
        if (!archivo) {
            perror("No se pudo abrir el archivo");
            return 1;
        }
        yyin = archivo;
    }
    yyparse();
    dijkstra(galaxias, "I1", "C");
    return 0;
 }