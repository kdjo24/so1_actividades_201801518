use serde::{Deserialize, Serialize};
use std::fs;
use sysinfo::{System, SystemExt, ProcessExt};

#[derive(Debug, Serialize, Deserialize)]
struct Contenedor {
    nombre: String,
    cpu_uso: f32,
    ram_uso: u64,
}

fn leer_archivo_json(ruta: &str) -> Vec<Contenedor> {
    let contenido = fs::read_to_string(ruta).expect("No se pudo leer el archivo");
    let contenedores: Vec<Contenedor> = serde_json::from_str(&contenido).expect("No se pudo parsear el JSON");
    contenedores
}

fn identificar_contenedores(contenedores: Vec<Contenedor>) {
    let mut alto_consumo: Vec<&Contenedor> = Vec::new();
    let mut bajo_consumo: Vec<&Contenedor> = Vec::new();

    for contenedor in &contenedores {
        if contenedor.cpu_uso > 75.0 || contenedor.ram_uso > 1024 * 1024 * 1024 { // 1 GB de RAM
            alto_consumo.push(contenedor);
        } else {
            bajo_consumo.push(contenedor);
        }
    }

    println!("Contenedores de Alto Consumo:");
    for c in alto_consumo {
        println!("{:?}", c);
    }

    println!("\nContenedores de Bajo Consumo:");
    for c in bajo_consumo {
        println!("{:?}", c);
    }
}

fn main() {
    let ruta_json = "/tmp/sysinfo_2000.json";
    let contenedores = leer_archivo_json(ruta_json);
    identificar_contenedores(contenedores);
}

